-- Cloudflare D1 database for the courier app.
-- You do NOT have to run this by hand: the Worker creates these tables by itself the first time it starts.
-- It is here so you can see (and read) exactly what the database holds.

-- Every saved piece of the app. A shipment, a rider, an invoice, a setting... each is one row.
CREATE TABLE IF NOT EXISTS parts (
  doc     TEXT    NOT NULL,   -- which data set: the platform, or one courier company
  part    TEXT    NOT NULL,   -- which piece inside it, e.g. one shipment
  json    TEXT,               -- the content of that piece
  h       TEXT,               -- a short fingerprint, used to spot differences quickly
  ver     INTEGER NOT NULL,   -- change number: tells phones what is new
  deleted INTEGER NOT NULL DEFAULT 0,  -- 1 = this piece was removed
  PRIMARY KEY (doc, part)
);
CREATE INDEX IF NOT EXISTS idx_parts_ver ON parts (ver);

-- One counter that numbers every change.
CREATE TABLE IF NOT EXISTS meta (k TEXT PRIMARY KEY, v INTEGER NOT NULL);
INSERT OR IGNORE INTO meta (k, v) VALUES ('seq', 0);

-- Where each rider is right now (for the Live Tracking map).
CREATE TABLE IF NOT EXISTS live (
  company TEXT    NOT NULL,
  rider   TEXT    NOT NULL,
  json    TEXT    NOT NULL,
  at      INTEGER NOT NULL,
  PRIMARY KEY (company, rider)
);
CREATE INDEX IF NOT EXISTS idx_live_at ON live (company, at);
