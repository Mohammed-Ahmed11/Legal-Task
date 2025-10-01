-- 001_init.sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE core_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  doc_type text NOT NULL CHECK (doc_type IN ('legislation','judgment','fatwa')),
  title text,
  doc_number text,
  issued_date date,
  language text DEFAULT 'ar',
  source text,
  file_path text,
  file_hash text UNIQUE,
  raw_text text,
  text_snippet text,
  search_tsv tsvector,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE legislation_docs (
  core_id uuid PRIMARY KEY REFERENCES core_documents(id) ON DELETE CASCADE,
  law_number text,
  issuing_body text,
  effective_date date,
  articles jsonb,
  amendments jsonb
);

CREATE TABLE judgment_docs (
  core_id uuid PRIMARY KEY REFERENCES core_documents(id) ON DELETE CASCADE,
  case_number text,
  court_name text,
  judges text[],
  plaintiffs text[],
  defendants text[],
  decision_date date,
  decision_summary text,
  citations text[]
);

CREATE TABLE fatwa_docs (
  core_id uuid PRIMARY KEY REFERENCES core_documents(id) ON DELETE CASCADE,
  mufti_name text,
  issuing_body text,
  question_summary text,
  ruling_summary text,
  references jsonb
);

CREATE INDEX idx_core_doc_type ON core_documents(doc_type);
CREATE INDEX idx_core_issued_date ON core_documents(issued_date);
CREATE INDEX idx_core_file_hash ON core_documents(file_hash);
CREATE INDEX idx_core_search_tsv ON core_documents USING gin(search_tsv);

CREATE FUNCTION core_documents_search_trigger() RETURNS trigger AS $$
BEGIN
  NEW.search_tsv := to_tsvector('arabic', coalesce(NEW.title,'') || ' ' || coalesce(NEW.raw_text,''));
  NEW.text_snippet := left(coalesce(NEW.raw_text,''), 2000);
  NEW.updated_at := now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON core_documents
FOR EACH ROW EXECUTE PROCEDURE core_documents_search_trigger();
