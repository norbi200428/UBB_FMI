USE Lab6_OnlineUjsag;
GO

--1 SELECT utasítások segítségével adjuk meg a legrégebben megjelent cikkek (Cikkek.CikkCim, Cikkek.Ertekeles) közül az(oka)t,
--amely(ek)hez a legkevesebb felhasználó szólt hozzá! Ügyeljünk arra, hogy létezhet olyan cikk, amelyhez még senki nem szólt
--hozzá!
SELECT c.CikkCim, c.Ertekeles
FROM Cikkek c
	LEFT JOIN (SELECT Hozzaszolasok.CikkID, COUNT(DISTINCT Hozzaszolasok.FelhasznaloID) AS KulonbozoHozzaszolaszok
				FROM Hozzaszolasok
				GROUP BY Hozzaszolasok.CikkID) H ON C.CikkID = H.CikkID
WHERE c.Datum = (SELECT MIN(Cikkek.Datum) FROM Cikkek)
	  AND (H.KulonbozoHozzaszolaszok IS NULL OR H.KulonbozoHozzaszolaszok = (
				SELECT MIN(CommentNr.CommentNrFromDistinctUsers)
					FROM (SELECT Cikkek.CikkID, COUNT(DISTINCT Hozzaszolasok.FelhasznaloID) AS CommentNrFromDistinctUsers
						  FROM Cikkek
							LEFT JOIN Hozzaszolasok ON Cikkek.CikkID = Hozzaszolasok.CikkID
						  GROUP BY Cikkek.CikkID
						  ) AS CommentNr
						)) 
GO

-- masodik megoldas

DECLARE @LegregebbiDatum DATE
SELECT @LegregebbiDatum = Min(c.Datum) 
FROM Cikkek c

DECLARE @MinHozzaszolasokSzama INT
SELECT @MinHozzaszolasokSzama = MIN(HozzaszolasokSzama)
FROM (SELECT c.CikkID, COUNT(DISTINCT h.FelhasznaloID) AS HozzaszolasokSzama
	  FROM Cikkek c
			LEFT JOIN Hozzaszolasok h ON c.CikkID = h.CikkID
	  GROUP BY c.CikkID) AS CikkekHozzaszolasSzama

SELECT c.CikkCim, c.Ertekeles
FROM Cikkek c
WHERE c.Datum = @LegregebbiDatum AND (SELECT COUNT(DISTINCT h.FelhasznaloID)
											 FROM Hozzaszolasok h WHERE h.CikkID = C.CikkID) = @MinHozzaszolasokSzama

GO

--2 
CREATE OR ALTER PROCEDURE FelhasznalokKevesebbHozzaszolasal (@pSzam INT)
AS
BEGIN 
	SET NOCOUNT ON
	IF @pSzam < 0
		BEGIN 	
			RAISERROR ('Hibas parameter', 16, 1)
			RETURN
		END

	CREATE TABLE #Temporary_CikkekHozzaszolasainakSzama (
		CikkID INT,
		SzerzoID INT,
		HozzaszolasokSzam INT
	)

	INSERT INTO #Temporary_CikkekHozzaszolasainakSzama
		SELECT c.CikkID, c.SzerzoID, COUNT(h.HozzaszolasID) as HozzaszolasokSzama
		FROM Cikkek c
			LEFT JOIN Hozzaszolasok h ON c.CikkID = h.CikkID
		GROUP BY c.CikkID, c.SzerzoID
	
	SELECT f.TeljesNev
	FROM Felhasznalok f
		LEFT JOIN #Temporary_CikkekHozzaszolasainakSzama t ON f.FelhasznaloID = t.SzerzoID
	GROUP BY f.FelhasznaloID, f.TeljesNev
	HAVING SUM(ISNULL(t.HozzaszolasokSzam,0)) < @pSzam

	DROP TABLE #Temporary_CikkekHozzaszolasainakSzama
END
GO

EXECUTE FelhasznalokKevesebbHozzaszolasal 3
GO

--3
CREATE OR ALTER FUNCTION ElteltNapokAzElsoCikktol (@pFelhasznaloNev VARCHAR(20))
RETURNS INT
AS
BEGIN 
	DECLARE @ElsoCikkDatum DATE
	DECLARE @ElteltNapok INT

	IF @pFelhasznaloNev IS NULL OR @pFelhasznaloNev = '' OR NOT EXISTS (SELECT 1 FROM Felhasznalok WHERE FelhasznaloNev = @pFelhasznaloNev)
	BEGIN 
		RETURN -1
	END

	SELECT @ElsoCikkDatum = MIN(c.Datum)
	FROM Cikkek c
		INNER JOIN Felhasznalok f ON c.SzerzoID = f.FelhasznaloID

	IF @ElsoCikkDatum IS NULL
		BEGIN
			RETURN -1
		END

		SET @ElteltNapok = DATEDIFF(DAY,@ElsoCikkDatum,GETDATE())

	RETURN @ElteltNapok
END

GO

DECLARE @vElteltNapokSzama INT
EXECUTE @vElteltNapokSzama = ElteltNapokAzElsoCikktol Levente
SELECT @vElteltNapokSzama
GO

--4
CREATE OR ALTER PROCEDURE CsokkentFiztes(@pKedvelesSzam INT, @pSzazalek INT, @pmfsz INT OUT)
AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #Temp_FelhasznalokOsszkedvelese (
		FelhasznaloID INT,
		Osszkedveles INT)

	INSERT INTO #Temp_FelhasznalokOsszkedvelese
		SELECT c.SzerzoID, COUNT(k.FelhasznaloID)
		FROM Cikkek c
			LEFT JOIN Kedvencek k ON c.CikkID = k.CikkID
		GROUP BY c.SzerzoID
		HAVING COUNT(k.FelhasznaloID) < @pKedvelesSzam

	UPDATE Felhasznalok 
	SET Fizetes = Fizetes - (Fizetes * @pSzazalek / 100)
	WHERE FelhasznaloID IN (SELECT FelhasznaloID
							  FROM #Temp_FelhasznalokOsszkedvelese
							  WHERE Osszkedveles < @pKedvelesSzam)

   SELECT @pmfsz = COUNT(*) FROM #Temp_FelhasznalokOsszkedvelese

   SELECT f.FelhasznaloNev, f.TeljesNev, o.OrszagNev, STRING_AGG(c.CikkCim, ', ') AS KedveltCikkCimek
   FROM Felhasznalok f
		INNER JOIN Orszagok O on f.OrszagID = o.OrszagID
		LEFT JOIN Cikkek c ON f.FelhasznaloID = c.SzerzoID
		LEFT JOIN Kedvencek k ON c.CikkID = k.CikkID
   WHERE f.FelhasznaloID IN (SELECT FelhasznaloID FROM #Temp_FelhasznalokOsszkedvelese)
	GROUP BY f.FelhasznaloID, f.FelhasznaloNev, f.TeljesNev, o.OrszagID, o.OrszagNev
END
GO

DECLARE @vModositottFelhasznalokSzama INT
EXECUTE CsokkentFiztes 5, 20, @vModositottFelhasznalokSzama OUT
SELECT @vModositottFelhasznalokSzama
GO

--5
	CREATE OR ALTER FUNCTION CikkekKulcsszoNelkul (@pKulcsszoNev VARCHAR(30), @pKategoriaNev VARCHAR(30))
	RETURNS @eredmeny TABLE (
		CikkID INT,
		CikkCim VARCHAR(50),
		Datum DATE,
		Szoveg VARCHAR(max),
		SzerzoID INT,
		KategoriaID INT,
		Ertekeles INT
	)
	AS
	BEGIN 
		INSERT INTO @eredmeny
		SELECT c.CikkID,c.CikkCim,c.Datum,c.Szoveg,c.SzerzoID,c.KategoriaID,c.Ertekeles
		FROM Cikkek c
			INNER JOIN Kategoriak k ON c.KategoriaID = k.KategoriaID
		WHERE k.KategoriaNev = @pKategoriaNev AND
			c.CikkID NOT IN (SELECT Kulcsszavai.CikkID
							 FROM Kulcsszavai
								INNER JOIN Kulcsszavak ON Kulcsszavai.KulcsszoID = Kulcsszavak.KulcsszoID
							 WHERE Kulcsszavak.KulcsszoNev = @pKulcsszoNev)

		RETURN
	END

	GO

SELECT * FROM CikkekKulcsszoNelkul ('karacsony', 'Eletmod' )
GO

--6
CREATE OR ALTER PROCEDURE FelhasznalokKulcsszoNelkul (@pKulcsszoNev VARCHAR(30), @pKategoriaNev VARCHAR(30), @pDatum DATE)
AS
BEGIN
	SET NOCOUNT ON
	IF @pDatum < '1990-01-01' OR @pDatum > GETDATE()
		BEGIN 	
			RAISERROR ('Hibas datum', 12, 1)
			RETURN 1
		END
	IF @pKulcsszoNev = '' OR @pKategoriaNev = ''
		BEGIN 	
			RAISERROR ('Ures Kategoria vagy Kulcsszo', 30, 1)
			RETURN 2
		END	
	IF NOT EXISTS (SELECT 1 FROM Kategoriak WHERE KategoriaNev = @pKategoriaNev)
		BEGIN 	
			RAISERROR ('Hibas Kategoria', 16, 1)
			RETURN
		END
	IF NOT EXISTS (SELECT 1 FROM Kulcsszavak WHERE KulcsszoNev = @pKulcsszoNev)
		BEGIN 	
			RAISERROR ('Hibas Kulcsszo', 15, 1)
			RETURN
		END
	
	DECLARE @cikkek TABLE (
		CikkID INT,
		CikkCim VARCHAR(50),
		Datum DATE,
		Szoveg VARCHAR(max),
		SzerzoID INT,
		KategoriaID INT,
		Ertekeles INT
	)

	INSERT INTO @cikkek 
	SELECT * FROM CikkekKulcsszoNelkul(@pKulcsszoNev, @pKategoriaNev)

	DECLARE @eredmeny TABLE (
		FelhasznaloNev VARCHAR(20),
		EmailCim VARCHAR(20)
	)

	INSERT INTO @eredmeny
	SELECT DISTINCT f.FelhasznaloNev, f.EmailCim
	FROM Felhasznalok f
		INNER JOIN Hozzaszolasok h ON f.FelhasznaloID = h.FelhasznaloID
		INNER JOIN Cikkek c ON h.CikkID = c.CikkID
		INNER JOIN Kategoriak k ON c.KategoriaID = k.KategoriaID
	WHERE c.Datum < @pDatum 
		AND k.KategoriaNev = @pKategoriaNev 
		AND NOT EXISTS (SELECT 1
						FROM Kulcsszavai ksz
							INNER JOIN Kulcsszavak k ON ksz.KulcsszoID = k.KulcsszoID
						WHERE ksz.CikkID = c.CikkID AND k.KulcsszoNev = @pKulcsszoNev)

	SELECT * FROM @eredmeny

END
GO

EXECUTE FelhasznalokKulcsszoNelkul 'karacsony','Politika','2024-12-31'