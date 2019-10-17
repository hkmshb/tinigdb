CREATE OR REPLACE VIEW nigeria_master.locations
 AS
 SELECT st.id,
    st.name::text AS name,
    'Nigeria'::text AS parents,
    'State'::text AS level,
    NULL::text AS ward_code,
    NULL::text AS lga_code,
    st.code::text AS state_code,
    count(s.id) AS settlement_count
   FROM nigeria_master.states st
     LEFT JOIN nigeria_master.local_government_areas l ON l.state_code::text = st.code::text
     LEFT JOIN nigeria_master.wards w ON l.code::text = w.lga_code::text
     LEFT JOIN nigeria_master.settlements s ON w.code::text = s.ward_code::text
  GROUP BY st.id, st.name, st.code
UNION
 SELECT l.id,
    l.name::text AS name,
    ('Nigeria'::text || ' * '::text) || btrim(st.name::text) AS parents,
    'LGA'::text AS level,
    NULL::text AS ward_code,
    l.code::text AS lga_code,
    st.code::text AS state_code,
    count(s.id) AS settlement_count
   FROM nigeria_master.local_government_areas l
     LEFT JOIN nigeria_master.states st ON l.state_code::text = st.code::text
     LEFT JOIN nigeria_master.wards w ON l.code::text = w.lga_code::text
     LEFT JOIN nigeria_master.settlements s ON w.code::text = s.ward_code::text
  GROUP BY l.id, l.name, st.name, st.code, l.code
UNION
 SELECT w.id,
    w.name::text AS name,
    ((('Nigeria'::text || ' * '::text) || btrim(st.name::text)) || ' * '::text) || btrim(l.name::text) AS parents,
    'Ward'::text AS level,
    s.ward_code::text AS ward_code,
    st.code::text AS lga_code,
    w.lga_code::text AS state_code,
    count(s.id) AS settlement_count
   FROM nigeria_master.wards w
     LEFT JOIN nigeria_master.settlements s ON w.code::text = s.ward_code::text
     LEFT JOIN nigeria_master.local_government_areas l ON w.lga_code::text = l.code::text
     LEFT JOIN nigeria_master.states st ON l.state_code::text = st.code::text
  GROUP BY w.id, w.name, l.name, st.name, st.code, s.ward_code, w.lga_code
UNION
 SELECT s.id,
    s.name::text AS name,
    ((((('Nigeria'::text || ' * '::text) || btrim(st.name::text)) || ' * '::text) || btrim(l.name::text)) || ' * '::text) || btrim(w.name::text) AS parents,
    'Settlement'::text AS level,
    s.ward_code::text AS ward_code,
    w.lga_code::text AS lga_code,
    st.code::text AS state_code,
    1 AS settlement_count
   FROM nigeria_master.settlements s
     LEFT JOIN nigeria_master.wards w ON s.ward_code::text = w.code::text
     LEFT JOIN nigeria_master.local_government_areas l ON w.lga_code::text = l.code::text
     LEFT JOIN nigeria_master.states st ON l.state_code::text = st.code::text;