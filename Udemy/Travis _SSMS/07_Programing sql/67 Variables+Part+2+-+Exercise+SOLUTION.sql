--Let's say your company pays once per month, on the 15th.
-- If it's already the 15th of the current month (or later), 
--the previous pay period will run from the 15th of the previous month, to the 14th of the current month.
-- If on the other hand it's not yet the 15th of the current month, 
--the previous pay period will run from the
-- 15th two months ago to the 14th on the previous month.
-- Set up variables defining the beginning and end of the previous
--pay period in this scenario. Select the variables to ensure they are working properly.
-- Hint: In addition to incorporating date logic, you will probably
--also need to use CASE statements in one of your variable definition



DECLARE @Today DATE = CAST(GETDATE() AS DATE)

SELECT @Today

DECLARE @Current14 DATE = DATEFROMPARTS(YEAR(@Today),MONTH(@Today),14)

DECLARE @PayPeriodEnd DATE = 
	CASE
		WHEN DAY(@Today) < 15 THEN DATEADD(MONTH,-1,@Current14)
		ELSE @Current14
	END

DECLARE @PayPeriodStart DATE = DATEADD(DAY,1,DATEADD(MONTH,-1,@PayPeriodEnd))


SELECT @PayPeriodStart
SELECT @PayPeriodEnd

