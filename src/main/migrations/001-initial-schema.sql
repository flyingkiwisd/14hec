-- 14 HEC Initial Schema
-- Core entity tables
CREATE TABLE IF NOT EXISTS plants (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  common_name TEXT NOT NULL,
  latin_name TEXT NOT NULL UNIQUE,
  family TEXT,
  genus TEXT,
  species TEXT,
  description TEXT,
  habitat TEXT,
  native_region TEXT,
  category TEXT CHECK(category IN ('conventional','entheogenic','both')),
  energetic_quality TEXT,
  doctrine_of_signatures TEXT,
  safety_notes TEXT,
  image_url TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS plant_parts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  plant_id INTEGER NOT NULL REFERENCES plants(id),
  part_type TEXT CHECK(part_type IN (
    'root','bark','stem','leaf','flower','seed_fruit',
    'resin_sap','fungal_body','whole'
  )),
  typical_compounds TEXT,
  therapeutic_properties TEXT,
  notes TEXT
);

CREATE TABLE IF NOT EXISTS ailments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  category TEXT CHECK(category IN ('physical','emotional','spiritual')),
  body_system TEXT,
  description TEXT,
  symptoms TEXT
);

CREATE TABLE IF NOT EXISTS preparations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  solvent TEXT,
  best_plant_parts TEXT,
  absorption_speed TEXT,
  concentration_level TEXT,
  shelf_life TEXT,
  general_instructions TEXT,
  safety_notes TEXT
);

CREATE TABLE IF NOT EXISTS planets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  symbol TEXT,
  associated_signs TEXT,
  body_systems TEXT,
  energetic_quality TEXT,
  description TEXT
);

CREATE TABLE IF NOT EXISTS zodiac_signs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  symbol TEXT,
  element TEXT CHECK(element IN ('fire','water','air','earth')),
  modality TEXT CHECK(modality IN ('cardinal','fixed','mutable')),
  ruling_planet_id INTEGER REFERENCES planets(id),
  date_range_start TEXT,
  date_range_end TEXT,
  body_parts_ruled TEXT,
  description TEXT
);

CREATE TABLE IF NOT EXISTS compounds (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  compound_type TEXT,
  pharmacological_action TEXT,
  psychoactive INTEGER DEFAULT 0
);

-- Junction / relationship tables
CREATE TABLE IF NOT EXISTS plant_compounds (
  plant_id INTEGER REFERENCES plants(id),
  compound_id INTEGER REFERENCES compounds(id),
  concentration_notes TEXT,
  PRIMARY KEY (plant_id, compound_id)
);

CREATE TABLE IF NOT EXISTS plant_ailments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  plant_id INTEGER REFERENCES plants(id),
  ailment_id INTEGER REFERENCES ailments(id),
  plant_part_id INTEGER REFERENCES plant_parts(id),
  preparation_id INTEGER REFERENCES preparations(id),
  efficacy_notes TEXT,
  evidence_level TEXT CHECK(evidence_level IN (
    'traditional','clinical','anecdotal','ethnobotanical'
  )),
  dosage_notes TEXT,
  source_reference TEXT
);

CREATE TABLE IF NOT EXISTS plant_planet_associations (
  plant_id INTEGER REFERENCES plants(id),
  planet_id INTEGER REFERENCES planets(id),
  association_type TEXT CHECK(association_type IN (
    'primary_ruler','sympathetic','antipathetic'
  )),
  notes TEXT,
  PRIMARY KEY (plant_id, planet_id)
);

CREATE TABLE IF NOT EXISTS plant_zodiac_associations (
  plant_id INTEGER REFERENCES plants(id),
  zodiac_sign_id INTEGER REFERENCES zodiac_signs(id),
  notes TEXT,
  PRIMARY KEY (plant_id, zodiac_sign_id)
);

CREATE TABLE IF NOT EXISTS ailment_planet_associations (
  ailment_id INTEGER REFERENCES ailments(id),
  planet_id INTEGER REFERENCES planets(id),
  notes TEXT,
  PRIMARY KEY (ailment_id, planet_id)
);

CREATE TABLE IF NOT EXISTS ailment_zodiac_associations (
  ailment_id INTEGER REFERENCES ailments(id),
  zodiac_sign_id INTEGER REFERENCES zodiac_signs(id),
  notes TEXT,
  PRIMARY KEY (ailment_id, zodiac_sign_id)
);

CREATE TABLE IF NOT EXISTS plant_part_preparations (
  plant_part_id INTEGER REFERENCES plant_parts(id),
  preparation_id INTEGER REFERENCES preparations(id),
  specific_instructions TEXT,
  dosage_notes TEXT,
  suitability TEXT CHECK(suitability IN ('optimal','viable','not_recommended')),
  PRIMARY KEY (plant_part_id, preparation_id)
);

CREATE TABLE IF NOT EXISTS preparation_compound_effects (
  preparation_id INTEGER REFERENCES preparations(id),
  compound_id INTEGER REFERENCES compounds(id),
  effect TEXT CHECK(effect IN ('extracts','concentrates','destroys','preserves')),
  notes TEXT,
  PRIMARY KEY (preparation_id, compound_id)
);

CREATE TABLE IF NOT EXISTS plant_research_notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  plant_id INTEGER REFERENCES plants(id),
  title TEXT,
  content TEXT,
  source_url TEXT,
  evidence_type TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS plant_contraindications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  plant_id INTEGER REFERENCES plants(id),
  ailment_id INTEGER REFERENCES ailments(id),
  reason TEXT,
  severity TEXT CHECK(severity IN ('high','moderate','low')),
  notes TEXT
);

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_plants_category ON plants(category);
CREATE INDEX IF NOT EXISTS idx_plants_common_name ON plants(common_name);
CREATE INDEX IF NOT EXISTS idx_plant_parts_plant ON plant_parts(plant_id);
CREATE INDEX IF NOT EXISTS idx_plant_ailments_plant ON plant_ailments(plant_id);
CREATE INDEX IF NOT EXISTS idx_plant_ailments_ailment ON plant_ailments(ailment_id);
CREATE INDEX IF NOT EXISTS idx_ailments_body_system ON ailments(body_system);
CREATE INDEX IF NOT EXISTS idx_ailments_category ON ailments(category);
CREATE INDEX IF NOT EXISTS idx_contraindications_plant ON plant_contraindications(plant_id);
CREATE INDEX IF NOT EXISTS idx_contraindications_ailment ON plant_contraindications(ailment_id);
