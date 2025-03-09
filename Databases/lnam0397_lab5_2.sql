USE AdventureWorks2022;

--(1)
--Adjuk meg azon üzletkötőket, akiknek bónusza (lsd. Sales.SalesPerson.Bonus) nagyobb,
--mint az üzletkötők átlagbónusza a ’Northeast’ nevű régióban (lsd. Sales.SalesTerritory.Name attribútum)! 
--Kiírandó attribútumok: Person.Person.FirstName, Person.Person.LastName, Sales.SalesPerson.Bonus

SELECT pp.FirstName, pp.LastName, ssp.Bonus
FROM Person.Person AS pp
	INNER JOIN HumanResources.Employee AS he ON pp.BusinessEntityID = he.BusinessEntityID
	INNER JOIN Sales.SalesPerson AS ssp ON he.BusinessEntityID = ssp.BusinessEntityID
	INNER JOIN Sales.SalesTerritory AS sst ON ssp.TerritoryID = sst.TerritoryID
WHERE ssp.Bonus > (SELECT AVG(ssp.Bonus)
					FROM Sales.SalesPerson AS ssp
						INNER JOIN Sales.SalesTerritory AS sst ON ssp.TerritoryID = sst.TerritoryID
					WHERE sst.Name = 'Northeast')
GO

--(3) Adjuk meg azon termékeket, melyeket vélemenyeztek (Production.ProductReview táblában szerepelnek),
--de nincs hozzájuk kép rendelve (Production.ProductProductPhoto táblában nem szerepelnek)! 
--A termékek csak egyszer jelenjenek meg a felsorolásban!
--Kiírandó attribútumok: Production.Product.Name

SELECT p.Name
FROM Production.Product AS p 
WHERE p.ProductID IN (SELECT DISTINCT pr.ProductID
						FROM Production.ProductReview AS pr 
					   EXCEPT 
						SELECT ppp.ProductID
							FROM Production.ProductProductPhoto AS ppp)
GO

--(2)  Adjuk meg minden alkategória esetén (lsd. Production.ProductSubcategory tábla), 
--hogy az adott alkategóriába tartozó termékek hány különböző helyen (raktárban) találhatóak meg 
--és milyen összmennyiségben (lsd. Production.ProductInventory tábla), összmennyiség szerint növekvő sorrendben!  
--Kiírandó attribútumok: Production.ProductSubcategory.Name, RaktarakSzama, Osszmennyiseg

SELECT	pps.Name, COUNT(DISTINCT ppi.LocationID) AS RaktarakSzama, SUM(ppi.Quantity) AS Osszmennyiseg	
FROM Production.ProductSubcategory AS pps
	LEFT JOIN Production.Product AS pp ON pps.ProductSubcategoryID = pp.ProductSubcategoryID
	LEFT JOIN Production.ProductInventory AS ppi ON pp.ProductID = ppi.ProductID
GROUP BY pps.Name
ORDER BY Osszmennyiseg ASC
GO

--(4) Adjuk meg azon személyeket, akik a legkevesebb szabadságot vették ki 
--(lsd. HumanResources.Employee.VacationHours attribútum) és min 2x váltottak részleget 
--(átmentek egyik részlegről a másikra) 2008 és 2011 között. (A join-nál szükség van a 
--HumanResources.EmployeeDepartmentHistory, HumanResources.Employee és Person.BusinessEntity táblákra.) 
--Ugyanazon a részlegen többször is dolgozhatott ugyanaz a személy.
--Kiírandó attribútumok: Person.Person.BusinessEntityID, Person.Person.FirstName, Person.Person.LastName, ReszlegekSzama

SELECT p.BusinessEntityID,p.FirstName, p.LastName, COUNT(DISTINCT edh.DepartmentID) AS ReszlegekSzama
FROM Person.Person AS p
	INNER JOIN HumanResources.Employee AS hre ON p.BusinessEntityID = hre.BusinessEntityID
	INNER JOIN HumanResources.EmployeeDepartmentHistory AS edh ON hre.BusinessEntityID = edh.BusinessEntityID
WHERE edh.StartDate >= '2008-01-01'AND edh.EndDate <= '2011-12-31'
GROUP BY p.BusinessEntityID, p.FirstName, p.LastName, hre.VacationHours
HAVING 
	COUNT(DISTINCT edh.DepartmentID) >= 2 AND hre.VacationHours = (SELECT MIN(VacationHours) 
																   FROM HumanResources.Employee)
GO

--(5) Adjuk meg azon bankkártyákat (lsd. Sales.CreditCard tábla), amelyek adatait az elmúlt 5 évben nem módosították 
--(lsd. Sales.CreditCard tábla ModifiedDate attribútuma) és minimum 2 eladásnál (lsd. Sales.SalesOrderHeader)
--használták őket, eladások száma szerint csökkenő sorrendben. 
--Kiírandó attribútumok: Sales.CreditCard.CreditCardID, Sales.CreditCard.CardType, EladasokSzama


SELECT cc.CreditCardID, cc.CardType, COUNT(soh.CreditCardID) AS EladasokSzama 
FROM Sales.CreditCard AS cc
	INNER JOIN Sales.PersonCreditCard as pcc ON cc.CreditCardID = pcc.CreditCardID
	INNER JOIN Sales.SalesOrderHeader as soh on pcc.CreditCardID = soh.CreditCardID
WHERE DATEDIFF(year, cc.ModifiedDate,GETDATE()) >= 5
GROUP BY cc.CreditCardID,cc.CardType,soh.CreditCardID
HAVING 
	COUNT(soh.CreditCardID) >= 2
ORDER BY
	EladasokSzama DESC
GO

--(6) Adjuk meg azon részlegeket (lsd. HumanResources.Department tábla), ahol dolgoznak nappali és
--esti műszakban is (lsd. HumanResources.Shift tábla Name oszlopa szerint: ‘Day’, ‘Night’)!
--A részlegek csak egyszer szerepeljenek a felsorolásban! 
--A lekérdezést adjuk meg kétféleképpen: i) halmazművelettel, majd ii) anélkül!
--Megj. A HumanResources.Employee és HumanResources.EmployeeDepartmentHistory táblákat is kell 
--használni a lekérdezésben, hogy a kért eredményt megadhassuk.
--Kiírandó attribútumok: HumanResources.Department.Name

SELECT DISTINCT hrd.Name
FROM HumanResources.Department as hrd
	INNER JOIN HumanResources.EmployeeDepartmentHistory as edh ON hrd.DepartmentID = edh.DepartmentID
WHERE hrd.DepartmentID IN (SELECT edh.DepartmentID
						   FROM HumanResources.EmployeeDepartmentHistory as edh
								INNER JOIN HumanResources.Employee as e ON edh.BusinessEntityID = e.BusinessEntityID
								INNER JOIN HumanResources.Shift as s ON edh.ShiftID = s.ShiftID
						   WHERE s.Name = 'Day'
						   INTERSECT
						   SELECT edh.DepartmentID
						   FROM HumanResources.EmployeeDepartmentHistory as edh
								INNER JOIN HumanResources.Employee as e ON edh.BusinessEntityID = e.BusinessEntityID
								INNER JOIN HumanResources.Shift as s ON edh.ShiftID = s.ShiftID
						   WHERE s.Name = 'Night'
						   );
GO

SELECT DISTINCT d.Name
FROM HumanResources.Department d
WHERE d.DepartmentID IN (
    SELECT edh.DepartmentID
    FROM HumanResources.EmployeeDepartmentHistory edh
    JOIN HumanResources.Shift s ON edh.ShiftID = s.ShiftID
    WHERE s.Name = 'Day'
)
AND d.DepartmentID IN (
    SELECT edh.DepartmentID
    FROM HumanResources.EmployeeDepartmentHistory edh
    JOIN HumanResources.Shift s ON edh.ShiftID = s.ShiftID
    WHERE s.Name = 'Night'
);
GO