INSTALL spatial;
LOAD spatial;

CREATE OR REPLACE TABLE acs_raw AS
SELECT * FROM read_csv('data/raw/acs_tracts.csv', header = true,
  types = {'geoid': 'VARCHAR', 'state': 'VARCHAR', 'county': 'VARCHAR', 'tract': 'VARCHAR'});

CREATE OR REPLACE TABLE pois_raw AS
SELECT * FROM read_csv_auto('data/raw/pois.csv');

CREATE OR REPLACE TABLE tract_geom AS
SELECT GEOID AS geoid, ALAND AS land_sqm, geom
FROM ST_Read('data/raw/tracts/tl_2023_18_tract.shp')
WHERE COUNTYFP = '105';
