USE Lab3;
GO

DROP TABLE IF EXISTS Vasarlo;
DROP TABLE IF EXISTS ReceptGyogyszerek;
DROP TABLE IF EXISTS Rendelesek;
DROP TABLE IF EXISTS Receptek;
DROP TABLE IF EXISTS Ugyfelek;
DROP TABLE IF EXISTS Orvosok;
DROP TABLE IF EXISTS Forgalmazok;
DROP TABLE IF EXISTS Gyogyszerek;
DROP TABLE IF EXISTS Gyogyszertarak;
GO

CREATE TABLE Gyogyszertarak (
	GyogyszertarID INT IDENTITY,
		CONSTRAINT PK_GyogyszertarID PRIMARY KEY (GyogyszertarID),
	GyogyszertarNev VARCHAR(255),
	GyogyszertarCim VARCHAR(255),
	GyogyszertarTelefonszam CHAR(10) DEFAULT '1234567890'
);

CREATE TABLE Gyogyszerek (
	GyogyszerID INT IDENTITY,
		CONSTRAINT PK_GyogyszerID PRIMARY KEY (GyogyszerID),
	GyogyszerNev VARCHAR(255),
	GyogyszerAr DECIMAL(6,2)
);

CREATE TABLE Orvosok(
	OrvosID INT IDENTITY,
		CONSTRAINT PK_OrvosID PRIMARY KEY (OrvosID),
	OrvosKNev VARCHAR(50),
	OrvosCsNev VARCHAR(50),
	OrvosTelefonszam CHAR(10) DEFAULT '1234567890',
	OrvosSzakterulet VARCHAR(100)
);

CREATE TABLE Forgalmazok(
	ForgalmazoID INT IDENTITY,
		CONSTRAINT PK_ForgalmazoID PRIMARY KEY (ForgalmazoID),
	ForgalmazoNev VARCHAR(255),
	ForgalmazoOrszag VARCHAR(255),
	ForgalamzoEmail VARCHAR(50) DEFAULT 'unknown@gmail.com',
	ForgalmazoTelefonszam CHAR(10) DEFAULT '1234567890',
);

CREATE TABLE Ugyfelek(
	UgyfelID INT IDENTITY,
		CONSTRAINT PK_UgyfelID PRIMARY KEY (UgyfelID),
	UgyfelKNev VARCHAR(50),
	UgyfelCsNev VARCHAR(50),
	UgyfelSzemelyiszam VARCHAR(13) DEFAULT '1111222233330',
	UgyfelEmail VARCHAR(50) DEFAULT 'unknown@gmail.com',
	UgyfelTelefonszam CHAR(10) DEFAULT '1234567890',
);

CREATE TABLE Receptek (
	ReceptID INT IDENTITY,
		CONSTRAINT PK_ReceptID PRIMARY KEY (ReceptID),
	ReceptDatum DATE,
	ReceptErteke DECIMAL(8,2),
	UgyfelID INT,
	OrvosID INT,
		CONSTRAINT FK_Receptek_UgyfelID_Ugyfelek_UgyfelID FOREIGN KEY (UgyfelID) REFERENCES Ugyfelek(UgyfelID) ON DELETE CASCADE,
		CONSTRAINT FK_Receptek_OrvosID_Orvosok_OrvosID FOREIGN KEY (OrvosID) REFERENCES Orvosok(OrvosID) ON DELETE CASCADE,
);

CREATE TABLE Rendelesek (
	GyogyszertarID INT,
	ForgalmazoID INT,
	GyogyszerID INT,
	RendelesDatum DATE,
	RendelesErteke DECIMAL(10,2),
		CONSTRAINT PK_Rendeles PRIMARY KEY (GyogyszertarID,ForgalmazoID,GyogyszerID),
		CONSTRAINT FK_Rendeles_GyogyszertarID FOREIGN KEY (GyogyszertarID) REFERENCES Gyogyszertarak(GyogyszertarID) ON DELETE CASCADE ,
		CONSTRAINT FK_Rendeles_ForgalmazoID FOREIGN KEY (ForgalmazoID) REFERENCES Forgalmazok(ForgalmazoID) ON DELETE CASCADE,
		CONSTRAINT FK_Rendeles_GyogyszerID FOREIGN KEY (GyogyszerID) REFERENCES Gyogyszerek(GyogyszerID) ON DELETE CASCADE
);


CREATE TABLE ReceptGyogyszerek(
	ReceptID INT,
	GyogyszerID INT,
		CONSTRAINT PK_ReceptID_GyogyszerID PRIMARY KEY (ReceptID,GyogyszerID),
		CONSTRAINT FK_ReceptGyogyszerek_ReceptID FOREIGN KEY (ReceptID) REFERENCES Receptek(ReceptID) ON DELETE CASCADE ,
		CONSTRAINT FK_ReceptGyogyszerek_GyogyszerID FOREIGN KEY (GyogyszerID) REFERENCES Gyogyszerek(GyogyszerID) ON DELETE CASCADE
);

CREATE TABLE Vasarlo(
	GyogyszertarID INT,
	UgyfelID INT,
		CONSTRAINT PK_GyogyszertarID_UgyfelID PRIMARY KEY (GyogyszertarID,UgyfelID),
		CONSTRAINT FK_Vasarlo_GyogyszertarID_Gyogyszertarak_GyogyszertarID FOREIGN KEY (GyogyszertarID) REFERENCES Gyogyszertarak(GyogyszertarID) ON DELETE CASCADE,
		CONSTRAINT FK_Vasarlo_UgyfelID_Ugyfelek_UgyfelID FOREIGN KEY (UgyfelID) REFERENCES Ugyfelek(UgyfelID) ON DELETE CASCADE
);

INSERT INTO Gyogyszertarak (GyogyszertarNev, GyogyszertarCim, GyogyszertarTelefonszam)
VALUES 
    ('Aranykereszt Gyógyszertár', 'Budapest, Fő utca 10', '1234567890'),
    ('Szent István Patika', 'Kolozsvar, Kossuth utca 23', '2345678901'),
    ('Hársfa Gyógyszertár', 'Pécs, Hársfa utca 5', '3456789012'),
    ('Rózsa Gyógyszertár', 'Győr, Rózsa tér 12', '4567890123'),
    ('Vörösmarty Gyógyszertár', 'Szeged, Vörösmarty utca 45', '5678901234');

INSERT INTO Gyogyszerek (GyogyszerNev, GyogyszerAr)
VALUES 
    ('Aspirin', 1200.50),
    ('Ibuprofen', 800.99),
    ('Paracetamol', 500.75),
    ('Diclofenac', 950.00),
    ('Antibioticum', 1250.25);

INSERT INTO Orvosok (OrvosKNev, OrvosCsNev, OrvosTelefonszam, OrvosSzakterulet)
VALUES 
    ('Csaba', 'Kovács', '1234567890', 'Kardiológia'),
    ('Beáta', 'Nagy', '2345678901', 'Neurológia'),
    ('Csaba', 'Tóth', '3456789012', 'Pediátria'),
    ('Dóra', 'Szabó', '4567890123', 'Dermatológia'),
    ('Erika', 'Kiss', '5678901234', 'Neurológia');

INSERT INTO Forgalmazok (ForgalmazoNev, ForgalmazoOrszag, ForgalamzoEmail, ForgalmazoTelefonszam)
VALUES 
    ('Richter Gedeon Nyrt', 'Magyarország', 'richter.contact@gmail.com', '1234567890'),
    ('Bayer AG', 'Németország', 'bayer.contact@gmail.com', '2345678901'),
    ('Novartis AG', 'Svájc', 'novartis.contact@gmail.com', '3456789012'),
    ('Sanofi S.A.', 'Franciaország', 'sanofi.contact@gmail.com', '4567890123'),
    ('Teva Pharmaceutical', 'Izrael', 'teva.contact@gmail.com', '5678901234');

INSERT INTO Ugyfelek (UgyfelKNev, UgyfelCsNev, UgyfelSzemelyiszam, UgyfelEmail, UgyfelTelefonszam)
VALUES 
    ('Péter', 'Farkas', '1111222233330', 'peter.farkas@gmail.com', '1234567890'),
    ('Anna', 'Kiss', '1111222233331', 'anna.kiss@gmail.com', '2345678901'),
    ('Lajos', 'Nagy', '1111222233332', 'lajos.nagy@gmail.com', '3456789012'),
    ('Erzsébet', 'Horváth', '1111222233333', 'erzsebet.horvath@gmail.com', '4567890123'),
    ('Ferenc', 'Varga', '1111222233334', 'ferenc.varga@gmail.com', '5678901234');

INSERT INTO Receptek (ReceptDatum, ReceptErteke, UgyfelID, OrvosID)
VALUES 
    ('2024-01-15', 500.00, 1, 1),
    ('2024-02-20', 300.50, 2, 2),
    ('2024-03-10', 400.75, 3, 3),
    ('2024-04-05', 200.00, 4, 4),
    ('2024-05-22', 350.25, 5, 5);

INSERT INTO Rendelesek (GyogyszertarID, ForgalmazoID, GyogyszerID, RendelesDatum, RendelesErteke)
VALUES 
    (1, 1, 1, '2024-06-15', 1000.50),
    (2, 2, 2, '2024-07-18', 1500.75),
    (3, 3, 3, '2024-08-20', 1200.25),
    (4, 4, 4, '2024-09-22', 1400.00),
    (5, 5, 5, '2024-10-25', 1600.50);

INSERT INTO ReceptGyogyszerek (ReceptID, GyogyszerID)
VALUES 
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

INSERT INTO Vasarlo (GyogyszertarID, UgyfelID)
VALUES 
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

UPDATE Gyogyszertarak 
SET GyogyszertarTelefonszam = '0987654321' 
WHERE GyogyszertarCim LIKE 'Kolozsvar%';

UPDATE Gyogyszerek
SET GyogyszerAr = GyogyszerAr + GyogyszerAr * 0.1
WHERE GyogyszerAr < 900;

UPDATE Ugyfelek
SET UgyfelEmail = 'csaba_az_orvosa@gmail.com'
FROM Ugyfelek AS u
INNER JOIN Receptek AS r ON u.UgyfelID = r.UgyfelID
INNER JOIN Orvosok AS o ON r.OrvosID = o.OrvosID
WHERE o.OrvosKNev = 'Csaba';

UPDATE Forgalmazok
SET ForgalmazoTelefonszam = '0123321311'
WHERE ForgalmazoOrszag = 'Magyarország' OR ForgalmazoOrszag = 'Németország';

UPDATE Orvosok
SET OrvosSzakterulet = 'Pszichiátria'
WHERE OrvosSzakterulet = 'Neurológia';

DELETE FROM Gyogyszertarak
WHERE GyogyszertarCim LIKE 'Kolozsvar%';

DELETE FROM Gyogyszerek
WHERE GyogyszerAr < 600;

DELETE FROM Orvosok
WHERE OrvosSzakterulet = 'Pediátria';

DELETE FROM Forgalmazok
WHERE ForgalmazoOrszag = 'Németország';

DELETE r
FROM Rendelesek AS r
INNER JOIN Forgalmazok AS f ON r.ForgalmazoID = f.ForgalmazoID
INNER JOIN Gyogyszertarak AS g ON r.GyogyszertarID = g.GyogyszertarID
WHERE f.ForgalmazoNev = 'Bayer AG';
