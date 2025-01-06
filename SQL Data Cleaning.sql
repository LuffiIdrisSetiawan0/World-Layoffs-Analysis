-- SQL Project - Data Cleaning

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022


SELECT * 
FROM layoffs;

-- Convert the data type properly
ALTER TABLE layoffs
MODIFY COLUMN total_laid_off INT,
MODIFY COLUMN percentage_laid_off DOUBLE,
MODIFY COLUMN `date` DATE;

-- first thing we want to do is create a staging table. This is the one we will work in and clean the data. We want a table with the raw data in case something happens
CREATE TABLE layoffs_staging 
LIKE layoffs;

INSERT layoffs_staging 
SELECT * FROM layoffs;


-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Analyze at null values
-- 4. remove any columns and rows that are not necessary



-- 1. Remove Duplicates

# First let's check for duplicates
SELECT *
FROM layoffs_staging;
    
-- We need to really look at every single row to show the duplicates 
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised
			) AS row_num
	FROM 
		layoffs_staging
) duplicates
WHERE row_num > 1;


-- these are the ones we want to delete where the row number is > 1 or 2 or greater essentially


-- let's just look at Beyond Meat and Cazoo to confirm
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised
			) AS row_num
	FROM 
		layoffs_staging
) duplicates
WHERE company = 'Beyond Meat' OR company = 'Cazoo';


-- Delete where row numbers are over 2, then delete that rows
CREATE TABLE `world_layoffs`.`layoffs_staging2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` DOUBLE,
`date` date,
`stage`text,
`country` text,
`funds_raised` Double,
row_num INT
);

INSERT INTO layoffs_staging2
SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised,
	ROW_NUMBER() OVER (
		PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised
		) AS row_num
FROM layoffs_staging;

UPDATE layoffs_staging2
SET percentage_laid_off = ROUND(percentage_laid_off, 2);

SELECT *
FROM layoffs_staging2
WHERE row_num > 1
ORDER BY company;

-- now that we have this we can delete rows were row_num is greater than 1
DELETE FROM layoffs_staging2
WHERE row_num > 1;





-- 2. Standardize Data

SELECT * 
FROM layoffs_staging2;

-- Trims the leading and trailing spaces from the company column to avoid issues with extra spaces
SELECT company, TRIM(company)
FROM layoffs_staging2
ORDER BY company;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- if we look at location, industry, and stage, it looks like we have nulls or empty rows (blanks). let's take a look at these
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE location IS NULL 
OR location = ''
ORDER BY industry;

SELECT *
FROM layoffs_staging2
WHERE stage IS NULL 
OR stage = '';

-- I plan to check for similar companies within the dataset to find a suitable reference for filling the blanks value.
SELECT *
FROM layoffs_staging2
WHERE company = 'Appsmith'; 

SELECT *
FROM layoffs_staging2
WHERE company = 'Product Hunt';

SELECT *
FROM layoffs_staging2
WHERE company IN ('Advata', 'Gatherly', 'Relevel', 'Soundwide', 'Spreetail', 'Verily', 'Zapp')
ORDER BY company;


-- As there is only one entry for the company and no other data to reference, I will change the blank value into NULL value
-- since those are typically easier to work with
-- Or if I found the suitable reference from same company,
-- I will fill the NULLS with the same value as suitable reference

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging2
SET location = NULL
WHERE location = '';

UPDATE layoffs_staging2
SET stage = NULL
WHERE stage = '';

UPDATE layoffs_staging2 as t1
JOIN layoffs_staging2 as t2
	ON t1.company = t2.company
SET t1.stage = t2.stage
WHERE t1.stage IS NULL AND t2.stage IS NOT NULL;

-- now if we check those are all null
SELECT *
FROM layoffs_staging2
WHERE company = 'Appsmith'; 

SELECT *
FROM layoffs_staging2
WHERE company = 'Product Hunt';

SELECT *
FROM layoffs_staging2
WHERE company IN ('Advata', 'Gatherly', 'Relevel', 'Soundwide', 'Spreetail', 'Verily', 'Zapp')
ORDER BY company;


-- I identified several instances where the columns total_laid_off, percentage_laid_off, and funds_raised contained values of 0. 
-- After investigating, it was determined that these values represent missing or unavailable data rather than actual zero values. 
-- Therefore, these 0 values were converted to NULL to accurately reflect the absence of data and makes it easier for calculations during the EDA phase.

SELECT total_laid_off, percentage_laid_off, funds_raised
FROM layoffs_staging2
WHERE total_laid_off = '' OR percentage_laid_off = '' OR funds_raised = ''
ORDER BY 1, 2, 3;

UPDATE layoffs_staging2
SET total_laid_off = NULL
WHERE total_laid_off = '';

UPDATE layoffs_staging2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '';

UPDATE layoffs_staging2
SET funds_raised = NULL
WHERE funds_raised = '';


-- now let's check again to make sure those values are null
SELECT total_laid_off, percentage_laid_off, funds_raised
FROM layoffs_staging2
WHERE total_laid_off IS NULL OR percentage_laid_off IS NULL OR funds_raised IS NULL
ORDER BY 1, 2, 3;


-- --------------------------------------------------


-- My next step will be to review some columns in the dataset and identify any discrepancies or inconsistencies that might exist
SELECT DISTINCT company, location, industry, country
FROM layoffs_staging2
ORDER BY company;


SELECT company, location, industry, country
FROM layoffs_staging2
WHERE company LIKE 'Butterfly%'
ORDER BY company, location;

UPDATE layoffs_staging2
SET company = 'Butterfly Network'
WHERE company LIKE 'Butterfly Network%';


SELECT company, location, industry, country
FROM layoffs_staging2
WHERE company LIKE 'Cue%'
ORDER BY company, industry;

UPDATE layoffs_staging2
SET company = 'Cue Health'
WHERE company = 'Cue';


SELECT DISTINCT company, location, industry, country
FROM layoffs_staging2
WHERE company LIKE 'Beamery%';

UPDATE layoffs_staging2
SET country = 'United Kingdom'
WHERE company = 'Beamery';




-- 3. Look at Null Values

-- At this stage, I reviewed the null values generated after converting blanks to nulls.
-- Since there are no other reference rows or logical methods to fill in these missing values, no further action was taken in this step. 
-- The null values remain unmodified as they do not have a valid substitute

SELECT total_laid_off, percentage_laid_off, funds_raised
FROM layoffs_staging2
WHERE total_laid_off IS NULL OR percentage_laid_off IS NULL OR funds_raised IS NULL
ORDER BY 1, 2, 3;

-- The next step involved removing rows where both 'total_laid_off' and 'percentage_laid_off' columns contained null values. 
-- Since these two columns are critical for analysis, rows without any valid data in both fields were considered redundant 
-- and were thus dropped to maintain the integrity of the dataset




-- 4. remove any columns and rows we need to

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Delete Useless data we can't really use
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2;
