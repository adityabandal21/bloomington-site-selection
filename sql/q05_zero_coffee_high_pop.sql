-- Q5: Which tracts have zero coffee shops but above-median population?
-- Caveat: a zero may mean the tract is outside the OSM bounding box, not that it has no coffee shops.
WITH coffee AS (
  SELECT geoid, COUNT(*) AS n_coffee
  FROM poi_tract
  WHERE is_coffee
  GROUP BY geoid
),
med AS (
  SELECT MEDIAN(pop) AS median_pop FROM tracts
)
SELECT t.geoid, t.pop, m.median_pop
FROM tracts t
CROSS JOIN med m
LEFT JOIN coffee c USING (geoid)
WHERE COALESCE(c.n_coffee, 0) = 0
  AND t.pop > m.median_pop
ORDER BY t.pop DESC;
