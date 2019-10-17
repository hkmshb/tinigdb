CREATE OR REPLACE VIEW nigeria_master.settlements_view
 AS
 SELECT s.global_id::uuid AS id,
    s.name,
    s.category,
    st_asgeojson(s.geom)::json AS point,
    st_asgeojson(sa.geom)::json AS polygon,
    w.name AS ward_name,
    s.ward_code,
    l.name AS lga_name,
    w.lga_code,
    st.name AS state_name,
    l.state_code
   FROM nigeria_master.settlements s
     LEFT JOIN nigeria_master.settlement_areas sa ON s.sa_global_id::uuid = sa.global_id
     LEFT JOIN nigeria_master.wards w ON s.ward_code::text = w.code::text
     LEFT JOIN nigeria_master.local_government_areas l ON w.lga_code::text = l.code::text
     LEFT JOIN nigeria_master.states st ON l.state_code::text = st.code::text;