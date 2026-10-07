PRAGMA foreign_keys = ON;
CREATE TABLE IF NOT EXISTS admins (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, email TEXT NOT NULL UNIQUE, password_hash TEXT NOT NULL, created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS events (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, event_date TEXT NOT NULL DEFAULT '', venue TEXT NOT NULL DEFAULT '', description TEXT NOT NULL DEFAULT '', status TEXT NOT NULL DEFAULT 'Active', created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS participants (id INTEGER PRIMARY KEY AUTOINCREMENT, event_id INTEGER NOT NULL REFERENCES events(id) ON DELETE CASCADE, student_name TEXT NOT NULL, mobile TEXT NOT NULL, email TEXT NOT NULL, participation TEXT NOT NULL DEFAULT '', certificate_id TEXT NOT NULL UNIQUE, certificate_status TEXT NOT NULL DEFAULT 'Available', created_at TEXT NOT NULL, UNIQUE(event_id, mobile, email));
CREATE TABLE IF NOT EXISTS certificate_templates (id INTEGER PRIMARY KEY AUTOINCREMENT, event_id INTEGER NOT NULL UNIQUE REFERENCES events(id) ON DELETE CASCADE, template_file TEXT, configuration TEXT NOT NULL DEFAULT '{}', created_at TEXT NOT NULL, updated_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS certificates (id INTEGER PRIMARY KEY AUTOINCREMENT, participant_id INTEGER NOT NULL UNIQUE REFERENCES participants(id) ON DELETE CASCADE, generated_file TEXT, generated_at TEXT, download_count INTEGER NOT NULL DEFAULT 0);
CREATE TABLE IF NOT EXISTS settings (key TEXT PRIMARY KEY, value TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS idx_participant_lookup ON participants(mobile, email);
CREATE INDEX IF NOT EXISTS idx_participant_event ON participants(event_id);
