-- Making use of temp tables and UPDATE statements, re-write an optimized version of the query in the "Optimizing With UPDATE - Exercise Starter Code.sql" file, 
-- which you'll find in the resources for this section.


SELECT 
	   A.BusinessEntityID
      ,A.Title
      ,A.FirstName
      ,A.MiddleName
      ,A.LastName
	  ,B.PhoneNumber
	  ,PhoneNumberType = C.Name
	  ,D.EmailAddress

FROM AdventureWorks2022.Person.Person A
	LEFT JOIN AdventureWorks2022.Person.PersonPhone B
		ON A.BusinessEntityID = B.BusinessEntityID
	LEFT JOIN AdventureWorks2022.Person.PhoneNumberType C
		ON B.PhoneNumberTypeID = C.PhoneNumberTypeID
	LEFT JOIN AdventureWorks2022.Person.EmailAddress D
		ON A.BusinessEntityID = D.BusinessEntityID