-- Q1: Which tracts have the most people?
SELECT geoid, pop
FROM tracts
ORDER BY pop DESC
LIMIT 10;
