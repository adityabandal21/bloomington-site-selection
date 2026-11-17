-- Q3: How many coffee competitors does each tract have?
SELECT t.geoid, t.pop, COUNT(pt.osm_id) AS coffee_shops
FROM tracts t
LEFT JOIN poi_tract pt
  ON pt.geoid = t.geoid AND pt.is_coffee
GROUP BY t.geoid, t.pop
ORDER BY coffee_shops DESC;
