-- 002 Body Systems: Organs, Ailment Mapping, Plant Part Correspondences
-- Adds the body_systems entity table and two junction tables that connect
-- body systems to ailments and to plant parts (including nutritional foods).

-- ── Core entity ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS body_systems (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  category TEXT CHECK(category IN ('organ','system','tissue','gland','structure')) NOT NULL,
  description TEXT,
  tcm_element TEXT,                    -- Traditional Chinese Medicine five-element mapping
  ayurvedic_dosha TEXT,                -- Ayurvedic dosha association
  ruling_planet_id INTEGER REFERENCES planets(id),
  zodiac_sign_id INTEGER REFERENCES zodiac_signs(id),
  image_url TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ── Junction: body system ↔ ailments ────────────────────────────────────
-- Links each ailment to one or more body systems it primarily affects.
-- This supersedes the free-text ailments.body_system column with a proper
-- many-to-many relationship so one ailment can map to multiple organs.
CREATE TABLE IF NOT EXISTS body_system_ailments (
  body_system_id INTEGER NOT NULL REFERENCES body_systems(id),
  ailment_id INTEGER NOT NULL REFERENCES ailments(id),
  relevance TEXT CHECK(relevance IN ('primary','secondary','associated')) DEFAULT 'primary',
  notes TEXT,
  PRIMARY KEY (body_system_id, ailment_id)
);

-- ── Junction: body system ↔ plant parts (includes nutritional foods) ────
-- Maps which plant part types support / heal each body system, following
-- the Doctrine of Signatures, traditional herbalism, and nutritional science.
-- The `plant_id` is optional: when NULL, the row describes a generic
-- part-type → body-system correspondence; when set, it captures a specific
-- plant's relationship (e.g., walnut → brain).
CREATE TABLE IF NOT EXISTS body_system_plant_parts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  body_system_id INTEGER NOT NULL REFERENCES body_systems(id),
  plant_id INTEGER REFERENCES plants(id),
  part_type TEXT CHECK(part_type IN (
    'root','bark','stem','leaf','flower','seed_fruit',
    'resin_sap','fungal_body','whole'
  )),
  correspondence_type TEXT CHECK(correspondence_type IN (
    'doctrine_of_signatures',    -- visual / morphological resemblance
    'traditional_herbalism',     -- historical use in herbalism
    'nutritional',               -- food-as-medicine relationship
    'tcm',                       -- Traditional Chinese Medicine mapping
    'ayurvedic',                 -- Ayurvedic tradition
    'clinical'                   -- modern clinical evidence
  )) NOT NULL DEFAULT 'traditional_herbalism',
  signature_description TEXT,    -- how the plant resembles or signals the organ
  therapeutic_action TEXT,       -- what the plant does for this body system
  is_food INTEGER DEFAULT 0,    -- 1 = this is a nutritional/food plant entry
  food_name TEXT,                -- e.g. "Walnut", "Kidney Bean", "Tomato"
  notes TEXT
);

-- ── Indexes ─────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_body_systems_category ON body_systems(category);
CREATE INDEX IF NOT EXISTS idx_body_systems_name ON body_systems(name);
CREATE INDEX IF NOT EXISTS idx_bsa_body_system ON body_system_ailments(body_system_id);
CREATE INDEX IF NOT EXISTS idx_bsa_ailment ON body_system_ailments(ailment_id);
CREATE INDEX IF NOT EXISTS idx_bspp_body_system ON body_system_plant_parts(body_system_id);
CREATE INDEX IF NOT EXISTS idx_bspp_plant ON body_system_plant_parts(plant_id);
CREATE INDEX IF NOT EXISTS idx_bspp_food ON body_system_plant_parts(is_food);
