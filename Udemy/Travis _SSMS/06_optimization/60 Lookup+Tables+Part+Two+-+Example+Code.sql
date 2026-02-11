--Update NULL fields in Calendar table

UPDATE dbo.Calendar
SET
DayOfWeekNumber = DATEPART(WEEKDAY,DateValue),
DayOfWeekName = FORMAT(DateValue,'dddd'),
DayOfMonthNumber = DAY(DateValue),
MonthNumber = MONTH(DateValue),
YearNumber = YEAR(DateValue)


SELECT * FROM dbo.Calendar

-- update the weekend flag value if it is 1 as daynumber like sunday and 7 and saturday

UPDATE dbo.Calendar
SET
WeekendFlag = 
	CASE
		WHEN DayOfWeekNumber IN(1,7) THEN 1
		ELSE 0
	END


SELECT * FROM dbo.Calendar



UPDATE dbo.Calendar
SET
HolidayFlag =
	CASE
		WHEN DayOfMonthNumber = 1 AND MonthNumber = 1 THEN 1
		ELSE 0
	END


SELECT * FROM dbo.Calendar


--Use Calendar table in a query


SELECT
A.*

FROM Sales.SalesOrderHeader A
	JOIN dbo.Calendar B
		ON A.OrderDate = B.DateValue

WHERE B.WeekendFlag = 1






