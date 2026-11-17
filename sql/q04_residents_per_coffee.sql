-- Q4: How many residents does each coffee shop serve, by tract?
-- Caveat: tracts with zero coffee shops show NULL (no competitor), and some zeros are outside the OSM bounding box.
WITH coffee AS (
  SELECT geoid, COUNT(*) AS n_coffee
  FROM poi_tract
  WHERE is_coffee
  GROUP BY geoid
)
SELECT t.geoid, t.pop,
       COALESCE(c.n_coffee, 0) AS n_coffee,
       t.pop / NULLIF(COALESCE(c.n_coffee, 0), 0) AS residents_per_coffee
FROM tracts t
LEFT JOIN coffee c USING (geoid)
ORDER BY residents_per_coffee DESC NULLS FIRST;
