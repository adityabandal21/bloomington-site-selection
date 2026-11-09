CREATE OR REPLACE VIEW poi_tract AS
SELECT p.osm_id, p.name, p.category, p.is_coffee, t.geoid
FROM pois p
JOIN tract_geom t
  ON ST_Within(ST_Point(p.lon, p.lat), t.geom);
