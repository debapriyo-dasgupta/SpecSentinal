# SpecSentinel 🛡️
**Agentic AI API Health, Compliance & Governance Bot**

IBM Hackathon MVP — Vector DB Rule Engine

---

## Architecture

```
OpenAPI Spec (YAML/JSON)
        │
        ▼
 Signal Extractor          ← Parses spec, finds issues
        │
        ▼
  Rule Matcher             ← Semantic search in ChromaDB
        │
  Vector DB (ChromaDB)     ← 5 collections, auto-refreshed from web
     ├─ security_rules         (OWASP API Top 10)
     ├─ design_rules           (OpenAPI best practices)
     ├─ error_handling_rules   (RFC 7807)
     ├─ documentation_rules
     └─ governance_rules
        │
        ▼
  Health Scorer            ← Weighted 0-100 score
        │
        ▼
  Report Generator         ← JSON + text report
        │
        ▼
  FastAPI Server           ← POST /analyze
```

---

## Quick Start

### 1. Install dependencies

```bash
cd specsentinel
pip install -r requirements.txt
```

### 2. Run the integration test (no server needed)

```bash
python tests/test_pipeline.py
```

This will:
- Initialize ChromaDB with seed rules
- Analyze the sample bad spec
- Print the health report to console
- Save `tests/report_output.json`

### 3. Start the API server

```bash
cd api
uvicorn app:app --reload --port 8000
```

### 4. Analyze a spec via API

```bash
# Upload a YAML file
curl -X POST http://localhost:8000/analyze \
  -F "file=@myapi.yaml" \
  -H "accept: application/json"

# Get text report
curl -X POST "http://localhost:8000/analyze?format=text" \
  -F "file=@myapi.yaml"

# Check rule counts
curl http://localhost:8000/stats

# Manually trigger rule refresh from OWASP/OpenAPI sites
curl -X POST http://localhost:8000/refresh
```

---

## Project Structure

```
specsentinel/
├── vectordb/
│   ├── seed_rules/          # Curated JSON rules (fallback + baseline)
│   │   ├── owasp_rules.json         (10 OWASP API Security rules)
│   │   ├── openapi_rules.json       (8 OpenAPI design rules)
│   │   └── governance_rules.json    (11 error/doc/governance rules)
│   ├── store/
│   │   └── chroma_client.py         # ChromaDB wrapper (5 collections)
│   └── ingest/
│       ├── scraper.py               # Web scraper + text chunker
│       └── scheduler.py             # APScheduler (weekly auto-refresh)
│
├── engine/
│   ├── signal_extractor.py          # Parses OpenAPI → signals
│   ├── rule_matcher.py              # Semantic search → matched rules
│   ├── scorer.py                    # Weighted health score (0-100)
│   └── reporter.py                  # JSON + text report generator
│
├── api/
│   └── app.py                       # FastAPI server
│
├── tests/
│   ├── sample_bad_spec.yaml         # Intentionally flawed test spec
│   └── test_pipeline.py             # Full pipeline integration test
│
└── requirements.txt
```

---

## Scoring Model

| Category         | Weight | What's Checked |
|-----------------|--------|---------------|
| Security        | 35%    | Auth schemes, 401/403/429, sensitive data |
| Design          | 20%    | Versioning, operationId, REST naming, pagination |
| Error Handling  | 15%    | Error schema, RFC 7807 compliance |
| Documentation   | 15%    | Summaries, examples, property descriptions |
| Governance      | 15%    | Versioning, contact, license, deprecation |

**Severity deductions:** Critical=−20pts | High=−12pts | Medium=−6pts | Low=−2pts

**Maturity bands:**
- 🔴 Poor (0–40)
- 🟡 Moderate (41–70)
- 🟢 Good (71–85)
- ✅ Excellent (86–100)

---

## Auto Rule Refresh

Rules are automatically updated from external sources weekly:

| Source | Category | URL |
|--------|----------|-----|
| OWASP API Security Top 10 2023 | Security | owasp.org |
| OpenAPI 3.x Best Practices | Design | learn.openapis.org |
| RFC 7807 Problem Details | ErrorHandling | datatracker.ietf.org |

To add more sources, add a `RuleSource` entry to `vectordb/ingest/scraper.py → RULE_SOURCES`.

Manual refresh: `POST /refresh` or run `python vectordb/ingest/scheduler.py --schedule startup_only`

---

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | / | Service info |
| GET | /health | Health check + rule counts |
| GET | /stats | Vector DB collection stats |
| POST | /analyze | Upload spec file (multipart) |
| POST | /analyze/text | Send spec as JSON body |
| POST | /refresh | Trigger manual rule refresh |
