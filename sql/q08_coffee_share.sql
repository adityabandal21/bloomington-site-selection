-- Q8: What share of each tract's food and drink places are coffee shops?
-- Caveat: tracts with only a few places give unstable shares (1 of 2 = 50%).
SELECT geoid,
       COUNT(*) AS food_drink_places,
       SUM(CASE WHEN is_coffee THEN 1 ELSE 0 END) AS coffee_places,
       ROUND(100.0 * SUM(CASE WHEN is_coffee THEN 1 ELSE 0 END) / COUNT(*), 1) AS coffee_share_pct
FROM poi_tract
WHERE category IN ('cafe', 'restaurant', 'fast_food', 'bakery', 'ice_cream', 'tea', 'coffee') OR is_coffee
GROUP BY geoid
ORDER BY coffee_share_pct DESC, food_drink_places DESC;
