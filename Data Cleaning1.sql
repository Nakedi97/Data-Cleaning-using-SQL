##copied data to another table

SELECT *
FROM layoffs;

CREATE TABLE layoffs1
LIKE layoffs;

INSERT layoffs1
SELECT *
FROM layoffs;

SELECT *
FROM layoffs1;

##remove the dublicates using ctes

WITH dublicate_cte AS 
(
SELECT *,ROW_NUMBER()
OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs1
)
SELECT *
FROM dublicate_cte
WHERE row_num > 1;

##CREATE A SECOND TABLE AND ADD ROW_NUM TO DELETE THE DUBLICATES

CREATE TABLE table3 
(company TEXT,
 location TEXT, 
 industry TEXT, 
 total_laid_off  INT,
 percentage_laid_off INT,
 `date` text, 
 stage TEXT,
 country TEXT, 
 funds_raised_millions INT,
 row_num INT
 );
 
 INSERT INTO table3
 SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country,funds_raised_millions) AS row_num
 FROM layoffs1;
 
DELETE
FROM table3
WHERE row_num > 1;

SELECT *
FROM table3
WHERE row_num > 1;

##standardizing data

UPDATE table3
SET company = TRIM(company);

##Check if the columns have the samething slightly written different
SELECT *
FROM table3;

SELECT DISTINCT industry
FROM table3
ORDER BY 1; 

SELECT *
FROM table3
WHERE industry LIKE 'crypto%';

UPDATE table3
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';

SELECT DISTINCT country
FROM table3
ORDER BY 1;

SELECT DISTINCT country
FROM table3;

UPDATE table3
SET country = TRIM(TRAILING '.' FROM country)
WHERE COUNTRY LIKE 'United States%';

SELECT *
FROM table3;

SELECT DISTINCT company,industry,stage
FROM table3
;

SELECT *
FROM TABLE3
WHERE COMPANY LIKE 'SPOTIFY';
##CHANGE THE COLUMN FORMAT

SELECT `DATE`,
STR_TO_DATE(`DATE`,'%m/%d/%Y')
FROM TABLE3;

UPDATE TABLE3
SET `DATE` =STR_TO_DATE(`DATE`,'%m/%d/%Y');



##CHANGING DATA TYPE OF THE COLUMN

ALTER TABLE TABLE3
MODIFY COLUMN `Date` DATE;

ALTER TABLE TABLE3
MODIFY COLUMN percentage_laid_off DECIMAL;

ALTER TABLE TABLE3
MODIFY COLUMN funds_raised_millions DECIMAL;


##FIXING NULL COLUMNS

SELECT *
FROM table3
WHERE INDUSTRY IS NULL OR INDUSTRY = '';

SELECT *
FROM TABLE3
WHERE COMPANY LIKE 'AIRBNB';

SELECT distinct company,stage,industry,total_laid_off
FROM TABLE3
WHERE STAGE LIKE 'UNKNOWN';



UPDATE TABLE3
SET INDUSTRY = NULL
WHERE INDUSTRY ='';

UPDATE TABLE3 T3
JOIN TABLE3 T4
ON T3.COMPANY=T4.COMPANY
AND t3.location = t4.location
SET T3.INDUSTRY=T4.INDUSTRY
WHERE (T3.INDUSTRY IS NULL) AND T4.INDUSTRY IS NOT NULL;

##DELETE THE ROW_NUM COLUMN

ALTER TABLE TABLE3
DROP COLUMN ROW_NUM;

SELECT *
FROM TABLE3;



