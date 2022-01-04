USE [data analyst job positions]


-- Cheak for duplicate valuse in table, No duplicate was found. useing CTE and ROW_NUMBER function
WITH DuplicateRemoveCte AS
	(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY [position],[company],[description],[reviews],[location] ORDER BY [position]) AS RowNumber
	FROM [original_data]
	)
DELETE FROM DuplicateRemoveCte WHERE RowNumber> 1


-- Delete blank rows (all values are "NULL")
DELETE FROM [data analyst job positions].[dbo].[original_data]
WHERE ([position] IS NULL) AND ([company] IS NULL) AND ([description] IS NULL) AND ([reviews] IS NULL) AND ([location] IS NULL) 


-- ADD STATE Abbreviation column
ALTER TABLE original_data 
	ADD state varchar(31),
	ADD city varchar(63)

	
-- Categorize location to states
UPDATE [original_data] SET [state] = 'New York' where location like '%NY%' AND (location NOT like '%SUNNYVALE%') AND (location NOT like '%, NJ')
UPDATE [original_data] SET [state] = 'New Jersey' where location like '%NJ%'
UPDATE [original_data] SET [state] = 'Georgia' where location like '%ga%' AND (location NOT like '%Burlingame%')
UPDATE [original_data] SET [state] = 'Texas' where location like '%TX%'
UPDATE [original_data] SET [state] = 'Colorado' where location like '%co%' AND (location NOT like '%San Francisco%')
UPDATE [original_data] SET [state] = 'Massachusetts' where location like '%, MA%'
UPDATE [original_data] SET [state] = 'Illinois' where location like '%Chicago, IL%'
UPDATE [original_data] SET [state] = 'Washington' where location like '%Washington, DC%'
UPDATE [original_data] SET [state] = 'California' where location like '%, CA%'
UPDATE [original_data] SET [state] = 'Washington' where location like '%, WA%'


-- Categorize location to cities  
UPDATE original_data SET city = SUBSTRING(location, 1, CHARINDEX(',', location) - 1) 
UPDATE original_data SET city ='New York' WHERE CITY IN ('Bronx','Brooklyn','Manhattan','Queens','New Hyde Park','Staten Island', 'Port Washington')

-- Change NULL reviews to 0 reviews
UPDATE original_data SET reviews = 0 WHERE reviews is NULL 

SELECT *
FROM [data analyst job positions].[dbo].[original_data]
ORDER BY reviews DESC













