-- Q10: Which tracts are the best opportunity for a new coffee shop?
-- Score = 40% population + 40% residents per coffee shop + 20% income, each min-max scaled to 0-1.
-- Caveat: weights are a judgment call; income is unreliable where the margin of error is large.
WITH coffee AS (
  SELECT geoid, COUNT(*) AS n_coffee
  FROM poi_tract
  WHERE is_coffee
  GROUP BY geoid
),
base AS (
  SELECT t.geoid, t.pop, t.median_income, t.median_income_moe,
         COALESCE(c.n_coffee, 0) AS n_coffee,
         -- +1 avoids dividing by zero and still rewards tracts with no competition
         t.pop / (COALESCE(c.n_coffee, 0) + 1.0) AS residents_per_coffee
  FROM tracts t
  LEFT JOIN coffee c USING (geoid)
),
scaled AS (
  SELECT *,
         (pop - MIN(pop) OVER ()) / NULLIF(MAX(pop) OVER () - MIN(pop) OVER (), 0) AS pop_s,
         (residents_per_coffee - MIN(residents_per_coffee) OVER ())
           / NULLIF(MAX(residents_per_coffee) OVER () - MIN(residents_per_coffee) OVER (), 0) AS rpc_s,
         (median_income - MIN(median_income) OVER ())
           / NULLIF(MAX(median_income) OVER () - MIN(median_income) OVER (), 0) AS income_s
  FROM base
)
SELECT geoid, pop, n_coffee, median_income,
       ROUND(0.4 * pop_s + 0.4 * rpc_s + 0.2 * COALESCE(income_s, 0), 3) AS score,
       RANK() OVER (ORDER BY 0.4 * pop_s + 0.4 * rpc_s + 0.2 * COALESCE(income_s, 0) DESC) AS score_rank,
       CASE WHEN median_income_moe > 0.3 * median_income THEN 'check' ELSE 'ok' END AS income_reliability
FROM scaled
ORDER BY score_rank;
