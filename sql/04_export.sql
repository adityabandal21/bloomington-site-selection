-- 04_export.sql: export clean data for the Excel check (Week 3)
-- Run with: python notebooks/run_sql.py sql/04_export.sql
COPY (
  SELECT t.*, g.land_sqm
  FROM tracts t
  JOIN tract_geom g USING (geoid)
) TO 'data/clean/tracts.csv' (HEADER);

COPY (SELECT * FROM poi_tract) TO 'data/clean/poi_tract.csv' (HEADER);
