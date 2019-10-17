CREATE OR REPLACE VIEW nigeria_master.boundaries
 AS
 SELECT w.id,
    w.name,
    w.code,
    w.status,
    w.geom,
    w.source,
    w."timestamp",
    w.lga_code,
    l.name AS lga_name,
    l.state_code,
    s.name AS state_name
   FROM nigeria_master.wards w
     JOIN nigeria_master.local_government_areas l ON w.lga_code::text = l.code::text
     JOIN nigeria_master.states s ON l.state_code::text = s.code::text;