USE Vizsga_Utazasi_Iroda;
GO

--1

SELECT h.nev, v.nev
FROM Hotelek h
	INNER JOIN Varosok v ON h.VarosID = v.VarosID
	INNER JOIN Utazasok_Hoteljei u ON h.HotelID = u.HotelID
	INNER JOIN Utazasok ut ON u.UtazasID = ut.UtazasID
WHERE ut.kezdo_datum >= '2022-01-01' AND ut.kezdo_datum <= '2023-12-31'

--2 
SELECT v.nev, h.nev, COUNT(u.HotelID)
FROM Hotelek h
	INNER JOIN Varosok v on h.VarosID = v.VarosID
	INNER JOIN Utazasok_Hoteljei u on h.HotelID = u.HotelID
GROUP BY v.nev, h.nev 
ORDER BY v.nev


--3 

--4 
SELECT v.nev, o.nev
FROM Varosok v
	INNER JOIN Orszagok o ON v.OrszagID = o.OrszagID
WHERE v.VarosID NOT IN (SELECT i.VarosID
						FROM Irodak i)

--5 

SELECT a.nev, COUNT(a.nev) AS UtazasokSzama
FROM Alkalmazottak a
	LEFT JOIN Utazasok u ON a.AlkalmazottID = u.AlkalmazottID
GROUP BY a.nev
HAVING COUNT(a.nev) < 4
ORDER BY UtazasokSzama ASC

--6 

SELECT t.nev, t.UtazasokSzama
FROM (SELECT o.OrszagID,o.nev, COUNT(o.OrszagID) as UtazasokSzama
	FROM Utazasok u
	INNER JOIN Utazasok_Varosai uv ON u.UtazasID = uv.UtazasID
	INNER JOIN Varosok v ON uv.VarosID = v.VarosID
	INNER JOIN Orszagok o ON v.OrszagID = o.OrszagID
GROUP BY o.OrszagID, o.nev) t
WHERE t.UtazasokSzama = (SELECT MAX(tm.UtazasokSzama)
						FROM (SELECT o.OrszagID,o.nev, COUNT(o.OrszagID) as UtazasokSzama
								FROM Utazasok u
								INNER JOIN Utazasok_Varosai uv ON u.UtazasID = uv.UtazasID
								INNER JOIN Varosok v ON uv.VarosID = v.VarosID
								INNER JOIN Orszagok o ON v.OrszagID = o.OrszagID
							    GROUP BY o.OrszagID, o.nev) tm)

--7 



--8 

SELECT u.nev
FROM Ugyfelek u
	INNER JOIN Utazasok ut ON u.UgyfelID = ut.UgyfelID
	INNER JOIN Utazasok_Varosai uv ON ut.UtazasID =uv.VarosID
WHERE DATEDIFF(YEAR, ut.kezdo_datum, GETDATE()) <= 5
GROUP BY u.UgyfelID, u.nev
HAVING COUNT(DISTINCT uv.VarosID) > 8
UNION
SELECT DISTINCT u.nev
FROM Ugyfelek u
	INNER JOIN Utazasok ut ON u.UgyfelID = ut.UgyfelID
	INNER JOIN Utazasok_Extrai ue ON ut.UtazasID = ue.UtazasID
	INNER JOIN Extrak e ON ue.ExtraID = e.ExtraID
WHERE e.elnevezes = 'All inclusive'

--9a

--9b

ALTER TABLE Irodak
DROP COLUMN alapitas_datum

--10
GO

CREATE OR ALTER PROCEDURE HibaKereses (@pIrodaID INT, @pOut INT OUT)
AS
BEGIN
		SET NOCOUNT ON
		IF NOT EXISTS (SELECT 1 FROM Irodak WHERE Irodak.IrodaID = @pIrodaID)
			BEGIN 
				RAISERROR('Nem megfelelo IrodaID',16,1)
			    SET @pOut = -1
				RETURN 
			END

		SELECT a.nev
		FROM Alkalmazottak a
			INNER JOIN Irodak i ON a.IrodaID = i.IrodaID
			INNER JOIN Utazasok u ON a.AlkalmazottID = u.AlkalmazottID
		WHERE i.IrodaID = @pIrodaID AND DATEDIFF(day,u.kezdo_datum,i.alapitas_datum) > 0

		SELECT a.nev
		FROM Alkalmazottak a
			INNER JOIN Utazasok u ON a.AlkalmazottID = u.AlkalmazottID
			INNER JOIN Ugyfelek ugy ON u.UgyfelID = ugy.UgyfelID
		WHERE DATEDIFF(day,u.kezdo_datum,ugy.szul_datum) > 0
END

GO

DECLARE @pOut INT
EXEC HibaKereses 1,@pOut


