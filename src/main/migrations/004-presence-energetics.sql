-- Plant Presence Energetics: How plants interact with our field through living proximity
-- Not consumption — the gift of sharing space with living plant intelligence
CREATE TABLE IF NOT EXISTS plant_presence_energetics (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  plant_id INTEGER NOT NULL UNIQUE REFERENCES plants(id),
  home_placement TEXT,        -- Which rooms/areas and why
  field_interaction TEXT,     -- How the plant's living field interacts with your energy
  energetic_gift TEXT,        -- The gift or balance through mere presence
  presence_practice TEXT,     -- How to sit with the plant, attune, receive
  spatial_influence TEXT,     -- How the plant transforms the energy of the space
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_presence_plant ON plant_presence_energetics(plant_id);
