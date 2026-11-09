CREATE OR REPLACE TABLE tracts AS
SELECT geoid,
       pop,
       CASE WHEN median_income < 0 THEN NULL ELSE median_income END AS median_income,
       CASE WHEN median_income_moe < 0 THEN NULL ELSE median_income_moe END AS median_income_moe,
       median_age,
       CASE WHEN median_rent < 0 THEN NULL ELSE median_rent END AS median_rent
FROM acs_raw;

-- Draft competitor definition: revise it after you review the results
CREATE OR REPLACE TABLE pois AS
SELECT *,
       CASE
         WHEN category = 'cafe' THEN TRUE
         WHEN shop = 'coffee' THEN TRUE
         WHEN cuisine = 'coffee_shop' THEN TRUE
         WHEN lower(name) LIKE '%coffee%'
           OR lower(name) LIKE '%espresso%'
           OR lower(name) LIKE '%roast%' THEN TRUE
         ELSE FALSE
       END AS is_coffee
FROM pois_raw
WHERE lat IS NOT NULL AND lon IS NOT NULL;
