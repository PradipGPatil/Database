--Re-write an optimized version of the below query using temp tables and UPDATE statements:

SELECT 
	   A.BusinessEntityID
      ,A.Title
      ,A.FirstName
      ,A.MiddleName
      ,A.LastName
	  ,B.PhoneNumber
	  ,PhoneNumberType = C.Name
	  ,D.EmailAddress

FROM Person.Person A
	LEFT JOIN Person.PersonPhone B
		ON A.BusinessEntityID = B.BusinessEntityID
	LEFT JOIN Person.PhoneNumberType C
		ON B.PhoneNumberTypeID = C.PhoneNumberTypeID
	LEFT JOIN Person.EmailAddress D
		ON A.BusinessEntityID = D.BusinessEntityID


--Rewrite:

CREATE TABLE #PersonContactInfo
(
	   BusinessEntityID INT
      ,Title VARCHAR(8)
      ,FirstName VARCHAR(50)
      ,MiddleName VARCHAR(50)
      ,LastName VARCHAR(50)
	  ,PhoneNumber VARCHAR(25)
	  ,PhoneNumberTypeID VARCHAR(25)
	  ,PhoneNumberType VARCHAR(25)
	  ,EmailAddress VARCHAR(50)
)

INSERT INTO #PersonContactInfo
(
	   BusinessEntityID
      ,Title
      ,FirstName
      ,MiddleName
      ,LastName
)

SELECT
	   BusinessEntityID
      ,Title
      ,FirstName
      ,MiddleName
      ,LastName

FROM Person.Person


UPDATE A
SET
	PhoneNumber = B.PhoneNumber,
	PhoneNumberTypeID = B.PhoneNumberTypeID

FROM #PersonContactInfo A
	JOIN Person.PersonPhone B
		ON A.BusinessEntityID = B.BusinessEntityID


UPDATE A
SET	PhoneNumberType = B.Name

FROM #PersonContactInfo A
	JOIN Person.PhoneNumberType B
		ON A.PhoneNumberTypeID = B.PhoneNumberTypeID


UPDATE A
SET	EmailAddress = B.EmailAddress

FROM #PersonContactInfo A
	JOIN Person.EmailAddress B
		ON A.BusinessEntityID = B.BusinessEntityID


SELECT * FROM #PersonContactInfo