USE master;
GO

USE Lab4_2;
GO

--1 Adjuk meg azon bentlakások nevét, amelyeknek legalább 30 szobája van és laknak benne ‘földrajz’ szakos diákok, szobák száma szerint csökkenő sorrendben (BNev)! 
SELECT b.BNev, b.SzobaSzama
FROM Bentlakasok AS b
	INNER JOIN Szobak AS sz ON b.BID = sz.BentlakasID
	INNER JOIN Lakik AS l ON sz.SzobaSzam = l.SzobaSzam
	INNER JOIN Diakok AS d ON l.DiakID = d.DiakID
	INNER JOIN Szakok AS sza ON d.SzakID = sza.SzakID
WHERE b.SzobaSzama > 30 AND sza.SzakNev = 'földrajz'
ORDER BY b.SzobaSzama DESC
GO

--2 Adjuk meg azon diákok nevét, e-mail címét és szobaszámukat, akiknek a vezetékneve ‘K’ betűben végződik és az elmúlt 1 hónapban
--költöztek be egy új bentlakásba (Miota attribútumot figyelembe véve) (VezetekNev, KeresztNev, Email, Lakik.SzobaSzam)!
SELECT VezetekNev, KeresztNev,Email, l.SzobaSzam
FROM Diakok AS d
		INNER JOIN Lakik AS l ON d.DiakID = l.DiakiD
WHERE d.VezetekNev LIKE '%k' AND DATEDIFF(month, l.miota, GETDATE()) <= 1
GO

--3 Adjuk meg azon bentlakásokat, melyekben laknak olyan diákok, akik a következő listában szereplő szakok valamelyikére járnak: 
--(‘info’, ‘matinfo’, ‘fizinfo’) (Bentlakasok.BNev, Bentlakasok.Cim, Bentlakasok.SzobaSzam)! Minden bentlakás csak egyszer jelenjen meg az eredményben!
SELECT DISTINCT b.BNev, b.Cim, b.SzobaSzama
FROM Bentlakasok AS b
		INNER JOIN	Szobak AS sz ON b.BID = sz.BentlakasID
		INNER JOIN Lakik AS l ON sz.SzobaSzam = l.SzobaSzam
		INNER JOIN Diakok AS d ON l.DiakID = d.DiakID
		INNER JOIN Szakok AS sza ON d.SzakID = sza.SzakID
WHERE sza.SzakNev IN ('info','mat-info','fizinfo')
GO

--4  Adjuk meg bentlakásonként az ott lakó diákok számát! Azokat a bentlakásokat is jelenítsük meg, melyekben egy diák sem lakik! (Bentlakasok.BNev, DiakokSzama)
SELECT b.BNev, COUNT(l.DiakID) AS DiakokSzama
FROM Bentlakasok AS b
		LEFT JOIN Szobak AS sz ON b.BID = sz.BentlakasID
		LEFT JOIN Lakik AS l ON sz.SzobaSzam = l.SzobaSzam
GROUP BY b.BID, b.BNev
GO

--5 Adjuk meg minden szak esetén, hogy hány diák jár az adott szakra az 1990 és 1999 között született diákok között! (Szakok.SzakNev, DiakokSzama)

SELECT Sz.SzakNev, COUNT(D.DiakID) AS DiakokSzama
FROM Szakok AS Sz
		INNER JOIN Diakok AS D ON Sz.SzakID = D.SzakID
WHERE D.SzulDatum BETWEEN '1990-01-01' AND '1999-12-31'
GROUP BY Sz.SzakID, Sz.SzakNev
GO

--6 Adjuk meg szakoként a diákok számát, akik ezen a szakon tanulnak!
--Csak azokat a szakokat jelenítsük meg, melyen tanul legalább 5 diák! (Szakok.SzakNev, DiakokSzama)

SELECT Sz.SzakNev, COUNT(D.DiakID) AS DiakokSzama
FROM Szakok AS Sz
	INNER JOIN Diakok AS D ON Sz.SzakID = D.SzakID
GROUP BY Sz.SzakID, Sz.SzakNev
HAVING COUNT(D.DiakID) >= 5
GO

--7 Adjuk meg hány diák költözött az ‘A2’ bentlakásba az elmúlt fél évben! (DiakokSzama)!

SELECT COUNT(D.DiakID) AS DiakokSzama
FROM Diakok AS D
		INNER JOIN Lakik AS L ON D.DiakID = L.DiakID
		INNER JOIN Szobak AS Sz ON L.SzobaSzam = Sz.SzobaSzam
		INNER JOIN Bentlakasok AS B ON Sz.BentlakasID = B.BID
WHERE DATEDIFF(month, L.miota, '2019-10-10') <= 6 AND B.BNev = 'A2'
GO

--8 Adjuk meg a legtöbb szobával rendelkező bentlakás(oka)t! (Bentlakasok.Nev, Bentlakasok.Cim, Bentlakasok.SzobaSzam)

SELECT B.BNev, B.Cim, B.SzobaSzama
FROM Bentlakasok AS B
WHERE B.SzobaSzama = (SELECT MAX(SzobaSzama) FROM Bentlakasok)
GO

--9 Adjuk meg azon diákokat, akik legalább 2 bentlakásban laktak és ‘yahoo’-s email címmel rendelkeznek! (Diákok.VezetekNev, Diakok.KeresztNev)

SELECT D.VezetekNev, D.KeresztNev
FROM Diakok AS D
	INNER JOIN Lakik AS L ON D.DiakID = L.DiakID
	INNER JOIN Szobak AS Sz ON L.SzobaSzam = Sz.SzobaSzam
	INNER JOIN Bentlakasok AS B ON Sz.BentlakasID = B.BID	
WHERE D.Email LIKE '%yahoo%'
GROUP BY D.DiakID, D.VezetekNev, D.KeresztNev
HAVING COUNT(DISTINCT B.BID) >= 2
GO

--10  Adjuk meg azon bentlakás(oka)t, mely(ek)ben van ‘3 agyas’, DE ‘5 agyas’ szoba nincs! (Bentlakasok.Nev)

SELECT DISTINCT B.BNev
FROM Bentlakasok AS B
	INNER JOIN Szobak AS Sz ON B.BID = Sz.BentlakasID
	INNER JOIN SzobaTipusok AS SzT ON Sz.SzobaTipusID = SzT.SzobaTipusID
WHERE SzT.SzTNev = '3 agyas' AND Sz.BentlakasID NOT IN (SELECT Sz.BentlakasID
														FROM Szobak AS Sz
															INNER JOIN SzobaTipusok AS SzT ON Sz.SzobaTipusID = SzT.SzobaTipusID
														WHERE SzT.SzTNev = '5 agyas')
GO