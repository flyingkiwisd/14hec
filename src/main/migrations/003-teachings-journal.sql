-- Plant Teachings: What the plant desires to teach us
-- Plants activate what is already within us — they are mirrors, not additions
CREATE TABLE IF NOT EXISTS plant_teachings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  plant_id INTEGER NOT NULL REFERENCES plants(id),
  energetic_teaching TEXT,      -- What the plant activates energetically
  mental_teaching TEXT,         -- What the plant awakens mentally/cognitively
  physical_teaching TEXT,       -- What the plant reveals about our physical body
  spiritual_teaching TEXT,      -- What the plant illuminates spiritually
  activation_principle TEXT,    -- The core activation principle (what it awakens WITHIN us)
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Journal prompts for guided reflection with each plant
CREATE TABLE IF NOT EXISTS journal_prompts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  plant_id INTEGER REFERENCES plants(id),  -- NULL = universal prompt
  prompt_text TEXT NOT NULL,
  prompt_category TEXT CHECK(prompt_category IN ('energetic','mental','physical','spiritual','integration','relationship')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- User journal entries — personal reflections and experiences
CREATE TABLE IF NOT EXISTS journal_entries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  plant_id INTEGER REFERENCES plants(id),
  prompt_id INTEGER REFERENCES journal_prompts(id),
  title TEXT,
  content TEXT NOT NULL,
  mood TEXT,
  season TEXT,
  entry_date DATE DEFAULT (date('now')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_teachings_plant ON plant_teachings(plant_id);
CREATE INDEX IF NOT EXISTS idx_journal_prompts_plant ON journal_prompts(plant_id);
CREATE INDEX IF NOT EXISTS idx_journal_entries_plant ON journal_entries(plant_id);
CREATE INDEX IF NOT EXISTS idx_journal_entries_date ON journal_entries(entry_date);
