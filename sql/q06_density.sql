-- Q6: What is each tract's population density per square mile?
-- Caveat: land area includes parks and IU campus land, so density understates how crowded the built-up parts are.
SELECT t.geoid, t.pop,
       ROUND(g.land_sqm / 2589988.0, 2) AS land_sq_mi,
       ROUND(t.pop / (g.land_sqm / 2589988.0), 0) AS pop_per_sq_mi
FROM tracts t
JOIN tract_geom g USING (geoid)
ORDER BY pop_per_sq_mi DESC;
