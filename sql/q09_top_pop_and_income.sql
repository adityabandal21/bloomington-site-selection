-- Q9: Which tracts rank in the top 10 on both population and income?
-- Caveat: tracts with missing income get no income rank and drop out.
WITH ranked AS (
  SELECT geoid, pop, median_income,
         RANK() OVER (ORDER BY pop DESC) AS pop_rank,
         RANK() OVER (ORDER BY median_income DESC NULLS LAST) AS income_rank
  FROM tracts
)
SELECT *
FROM ranked
WHERE pop_rank <= 10
  AND income_rank <= 10
  AND median_income IS NOT NULL
ORDER BY pop_rank + income_rank;
