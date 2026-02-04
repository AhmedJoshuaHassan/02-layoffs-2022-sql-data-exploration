/* EXPLORATORY DATA ANALYSIS */

SELECT *
FROM layoffs_cleaned_dataset;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_cleaned_dataset;


SELECT *
FROM layoffs_cleaned_dataset
WHERE percentage_laid_off = 1;

SELECT *
FROM layoffs_cleaned_dataset
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT Company, SUM(total_laid_off)
FROM layoffs_cleaned_dataset
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_cleaned_dataset;

SELECT industry, SUM(total_laid_off)
FROM layoffs_cleaned_dataset
GROUP BY Industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_cleaned_dataset
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaned_dataset
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_cleaned_dataset
GROUP BY stage
ORDER BY 2 DESC;

-- look at the progression of layoffs using rolling total

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_cleaned_dataset
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_cleaned_dataset
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)

SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaned_dataset
GROUP BY company, YEAR(`date`)
ORDER BY 2;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaned_dataset
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaned_dataset
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *,
 DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;