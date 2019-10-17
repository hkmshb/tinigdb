CREATE OR REPLACE VIEW nigeria_master.wards_view
 AS
 SELECT w.id,
    w.name,
    w.code,
    st_asgeojson(w.geom)::json AS geom,
    l.name AS lga_name,
    w.lga_code,
    st.name AS state_name,
    l.state_code
   FROM nigeria_master.wards w
     LEFT JOIN nigeria_master.local_government_areas l ON w.lga_code::text = l.code::text
     LEFT JOIN nigeria_master.states st ON l.state_code::text = st.code::text;