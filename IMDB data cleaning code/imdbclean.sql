--inspecting table--

SELECT *
FROM IMDB




-- drop unnecessarily column -- --inspecting table--

ALTER TABLE IMDB
DROP COLUMN column9


-- checking for duplicates --

SELECT imbd_title_id, COUNT(imbd_title_id)
FROM IMDB
GROUP BY imbd_title_id
HAVING COUNT(imbd_title_id) > 1


-- deleting null value--

DELETE FROM IMDB
WHERE imbd_title_id IS NULL


-- deleting day and month from relese_year column --

SELECT  release_year = SUBSTRING(release_year, 1, 4)
FROM  IMDB
WHERE release_year LIKE '____-__-__'


UPDATE IMDB
SET release_year = SUBSTRING(release_year, 1, 4)
WHERE release_year LIKE '____-__-__'


--finding titles with other date formats--

SELECT IMDB_title_ID, release_year 
FROM IMDB 
WHERE release_year  NOT LIKE '____'

--updating rows with different date formats--

UPDATE IMDB
SET release_year = 1972
WHERE IMDB_title_ID = 'tt0068646'


UPDATE IMDB
SET release_year = 2008
WHERE IMDB_title_ID = 'tt0468569'


UPDATE IMDB
SET release_year = 2004
WHERE IMDB_title_ID = 'tt0167260'


UPDATE IMDB
SET release_year = 1999
WHERE IMDB_title_ID = 'tt0137523'


UPDATE IMDB
SET release_year = 1966
WHERE IMDB_title_ID = 'tt0060196'


UPDATE IMDB
SET release_year = 2003
WHERE IMDB_title_ID = 'tt0167261'


UPDATE IMDB
SET release_year = 1976
WHERE IMDB_title_ID = 'tt0073486'



UPDATE IMDB
SET release_year = 1946
WHERE IMDB_title_ID = 'tt0034583'


UPDATE IMDB
SET release_year = 1951
WHERE IMDB_title_ID = 'tt0043014'




--trimming duration column to only 3 characters --


SELECT LEFT(duration, 3)
FROM IMDB


UPDATE IMDB
SET duration = LEFT(duration, 3)


--removing texts characters from duration column--

UPDATE IMDB
SET duration = SUBSTRING(duration, 1, PATINDEX('%[^0-9]%', duration + 'x') - 1)

UPDATE IMDB 
SET duration = NULLIF(duration, '')



--removing numeric value from country column --

UPDATE IMDB 

SET country = REPLACE(country, '1', '')



--standardizing country names --

UPDATE IMDB

SET country = CASE WHEN country LIKE '%US%' THEN 'USA'	
			ELSE country 
			END
			

UPDATE IMDB

SET country = CASE WHEN country LIKE '%New%' THEN 'New Zealand'	
			ELSE country 
			END
			

UPDATE IMDB 
SET country = CASE WHEN country LIKE '%Germany%' THEN 'Germany'	
			ELSE country 
			END
		
-- clean content_rating column--

UPDATE IMDB 

SET content_rating =  CASE WHEN content_rating LIKE '%PG%' THEN 'PG-13'
						WHEN content_rating LIKE 'Approved%' THEN 'R'
						WHEN content_rating IN ('Not Rated', 'Unrated', '#N/A') THEN NULL
						ELSE content_rating 
						END 

--cleaning income column--

UPDATE IMDB
SET income = REPLACE(income,',', '')

UPDATE IMDB 
SET income = REPLACE(income,'$', '')

UPDATE IMDB
SET income = REPLACE(income,'o', '0')


--cleaning votes column--

UPDATE IMDB 
SET votes = REPLACE(votes,'.', '')



--cleaning score column--

UPDATE IMDB 
SET score = REPLACE(REPLACE(REPLACE(score, '++', ''), 'f', ''), 'e-0', '')


UPDATE IMDB 
SET score =  REPLACE(score, '08.9', '8.9')
			WHERE score = '08.9'


UPDATE IMDB
SET SCORE = REPLACE(score, ',', '.')



UPDATE IMDB
SET score = REPLACE(REPLACE(REPLACE(score, ',', '.'), ':', '.'),'..', '.')


UPDATE IMDB 
SET score = REPLACE(score, '9.', '9')
WHERE score = '9.'




--casting columns to correct data type--

ALTER TABLE IMDB
ALTER COLUMN Release_year INT


ALTER TABLE IMDB
ALTER COLUMN duration INT



ALTER TABLE IMDB
ALTER COLUMN income NUMERIC


ALTER TABLE IMDB
ALTER COLUMN votes NUMERIC



ALTER TABLE IMDB
ALTER COLUMN score FLOAT






