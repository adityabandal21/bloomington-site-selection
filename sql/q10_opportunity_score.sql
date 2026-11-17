-- Q10: Which in-town tracts are the best opportunity for a new coffee shop?
-- Score = 40% density + 40% residents per coffee shop + 20% income.
-- v3 changes (see stuck_log.md, 2026-11-17):
--   1. Keeps only tracts with at least 1,000 people per sq mi (a common urban threshold),
--      because raw population ranked large rural tracts first.
--   2. Scales each factor with PERCENT_RANK (0 to 1 by rank) instead of min-max,
--      because one very dense campus tract squashed every other tract's density score.
-- Caveat: weights and the density cutoff are judgment calls; income is unreliable where the margin of error is large.
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
         t.pop / (COALESCE(c.n_coffee, 0) + 1.0) AS residents_per_coffee,
         t.pop / (g.land_sqm / 2589988.0) AS density
  FROM tracts t
  LEFT JOIN coffee c USING (geoid)
  JOIN tract_geom g USING (geoid)
),
scaled AS (
  SELECT *,
         PERCENT_RANK() OVER (ORDER BY density) AS density_s,
         PERCENT_RANK() OVER (ORDER BY residents_per_coffee) AS rpc_s,
         CASE WHEN median_income IS NULL THEN 0
              ELSE PERCENT_RANK() OVER (ORDER BY median_income) END AS income_s
  FROM base
  WHERE density >= 1000
)
SELECT geoid, pop, ROUND(density, 0) AS density, n_coffee, median_income,
       ROUND(0.4 * density_s + 0.4 * rpc_s + 0.2 * income_s, 3) AS score,
       RANK() OVER (ORDER BY 0.4 * density_s + 0.4 * rpc_s + 0.2 * income_s DESC) AS score_rank,
       CASE WHEN median_income_moe > 0.3 * median_income THEN 'check' ELSE 'ok' END AS income_reliability
FROM scaled
ORDER BY score_rank;
