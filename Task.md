# Take‑Home Task — Legal Docs Data Modeling, Parser & API (Node + TypeScript)

## Overview

You will receive **three Arabic legal document types** — **Legislation**, **Judgments**, and **Fatwas** — as **DOCX** files (text‑selectable; **no OCR** needed). Your job is to:

1. **Analyze** each document type’s structure.
2. **Design** a schema that can store these types at scale (hundreds of thousands of docs).
3. **Build** a **parser/loader** that extracts fields from DOCX and loads them into your database.
4. **Expose** a **simple API** to retrieve and search what you stored.

You don’t need any legal domain knowledge. Focus on the **data**, its **shape**, and the **scalability** of your approach.

Sample Link (for illustration only; you will get your own samples): [Example DOCX files](https://drive.google.com/file/d/1XfdwZGQCcr66R1Nce2ED_50Q_vLKAdSM/view?usp=sharing)

## Inputs

* **Document types:** Legislation, Judgments, Fatwas.
* **Format:** DOCX (Arabic, selectable text; no OCR).
* **Samples:** We will provide a small sample set (2–3 files per type).

## Deliverables

### 1) Data Model (ERD + DDL)

* Create a **core table** for shared metadata across all types.
* Create **three type‑specific tables** (one per document type) for fields unique to that type. You decide the fields based on your analysis.
* Provide the **DDL** (SQL migrations). You may use **any database**, but **we use PostgreSQL internally** — if you choose a different DB, add a short note in the README on how this would map to Postgres.
* Add **indexes** you deem important; explain why (e.g., retrieval fields, search fields, uniqueness, partition keys).

### 2) Parser / Loader

* A script/CLI that:

  * Reads the DOCX files.
  * Extracts fields for the **core table** and the **type‑specific** table.
  * Inserts/updates records (**idempotent** operation if re‑run).
  * Logs what was extracted, what was skipped, and any assumptions.
* **Method is your choice** (regex, markup/DOM traversal, rule‑based, ML/LLM, etc.). The **output quality** and clarity of approach matter most.

### 3) API (JSON)

Implement a minimal **REST** API to demonstrate data access.

* **List/Search**: `GET /documents?type=&q=&page=&pageSize=`

  * `type` filters by document type.
  * `q` performs a basic text search (your choice of implementation; can be simple but must be indexed when feasible).
  * Paginate results.

### 4) Search & Indexing Now vs. Later

* **Now (required):** implement a **basic** search that works on your chosen DB (e.g., FTS / LIKE / trigram) and add the right indexes.

### 5) README (concise)

Include:

* Assumptions you made for each document type.
* Schema diagram and rationale.
* How to run (simple steps; Docker optional).
* Limitations.
* **Future improvements** you’d make if you had more time.

### 6) Reflection (short note)

Add a small document (e.g., `REFLECTION.md`) covering:

* Any issues or problems you faced.
* What you would improve in your implementation.
* What you would change in the task description (if anything).

## Tech Requirements

* **Language/Runtime:** **Node.js + TypeScript**.
* **Database:** Your choice; **note** in the README that we use **PostgreSQL** internally and how your solution would map.
* **No UI required.** API only.
* Keep it easy to run locally (a few simple commands or Docker Compose).

## Scale Assumptions & Guidance

* Design with **hundreds of thousands** of documents in mind.
* Consider: batch ingestion, idempotency, deduplication keys, retry strategy, and monitoring points.
*

## Timeline & Submission

* **Timebox:** up to **5 days** from receipt of samples.
* **Submission:** Git repo link (source + README + tiny example output from `/documents`). Postman collection or OpenAPI spec is welcome but optional.

## Acceptance Criteria (summary)

* Runs locally with minimal steps.
* Creates **one core** table + **three type‑specific** tables.
* Parses provided DOCX samples and loads data.
* Exposes working API with list/search + detail.
* Includes README + REFLECTION.
* Shows a credible path to scale the ingestion and search.
