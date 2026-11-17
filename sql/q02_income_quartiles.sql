-- Q2: How are income levels distributed across tracts?
-- Caveat: student-heavy tracts near campus show low income that may not reflect spending power.
SELECT geoid, median_income,
       NTILE(4) OVER (ORDER BY median_income) AS income_quartile
FROM tracts
WHERE median_income IS NOT NULL
ORDER BY median_income;
