-- Q7: How does each tract's median rent compare to the county average?
-- Caveat: this is a simple average of tract medians, not a true county-wide median rent.
SELECT geoid, median_rent,
       ROUND(AVG(median_rent) OVER (), 0) AS county_avg_rent,
       median_rent - ROUND(AVG(median_rent) OVER (), 0) AS diff_from_avg,
       ROUND(100.0 * median_rent / AVG(median_rent) OVER (), 1) AS pct_of_avg
FROM tracts
WHERE median_rent IS NOT NULL
ORDER BY diff_from_avg DESC;
