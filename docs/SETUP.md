# SpecSentinel - Development Environment Setup Guide

## 🎯 Project Overview

**SpecSentinel** is an Agentic AI-powered API Health, Compliance & Governance Bot built for the IBM Hackathon. It analyzes OpenAPI specifications using a vector database (ChromaDB) rule engine to identify security, design, error handling, documentation, and governance issues.

### Architecture Components

```
┌─────────────────────────────────────────────────────────────┐
│                    OpenAPI Spec (YAML/JSON)                 │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  Signal Extractor (signal_extractor.py)                     │
│  • Parses OpenAPI spec                                       │
│  • Extracts 50+ compliance signals                           │
│  • Categories: Security, Design, Error, Doc, Governance      │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  Rule Matcher (rule_matcher.py)                             │
│  • Semantic search in ChromaDB                               │
│  • Matches signals to rules using cosine similarity          │
│  • Threshold: 0.35 minimum similarity                        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  Vector DB - ChromaDB (chroma_client.py)                    │
│  ├─ security_rules         (OWASP API Top 10)               │
│  ├─ design_rules           (OpenAPI best practices)         │
│  ├─ error_handling_rules   (RFC 7807)                       │
│  ├─ documentation_rules                                      │
│  └─ governance_rules                                         │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  Health Scorer (scorer.py)                                   │
│  • Weighted scoring: 0-100                                   │
│  • Security: 35% | Design: 20% | Error: 15%                 │
│  • Documentation: 15% | Governance: 15%                      │
│  • Severity deductions: Critical=-20, High=-12, Medium=-6   │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  Report Generator (reporter.py)                             │
│  • JSON + Text formats                                       │
│  • Benchmark alignment                                       │
│  • Priority recommendations                                  │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  FastAPI Server (app.py)                                     │
│  • POST /analyze - Upload spec file                         │
│  • POST /analyze/text - Send spec as JSON                   │
│  • GET /stats - Vector DB statistics                        │
│  • POST /refresh - Manual rule refresh                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 📋 Prerequisites

- **Python 3.13.11** (or Python 3.9+)
- **pip** package manager
- **Git** (for version control)
- **Windows PowerShell** or **Command Prompt**

---

## 🚀 Quick Setup (5 Minutes)

### Step 1: Create Virtual Environment

```powershell
# Navigate to project directory
cd c:\Users\DebapriyoDasgupta\OneDrive - IBM\Desktop\Work\working with IBM\IBM_Hackathon_26\SpecSentinal_IBM_Hackathon

# Create virtual environment
python -m venv venv

# Activate virtual environment (PowerShell)
.\venv\Scripts\Activate.ps1

# Or for Command Prompt
.\venv\Scripts\activate.bat
```

### Step 2: Install Dependencies

```powershell
# Install all required packages
pip install -r requirements.txt

# Verify installation
python -c "import chromadb, fastapi, yaml; print('✅ All packages installed!')"
```

### Step 3: Test the Pipeline

```powershell
# Run integration test (no server needed)
python test_pipeline.py
```

Expected output:
```
============================================================
  SpecSentinel — Pipeline Integration Test
============================================================

[1/5] Initializing Vector Store...
  Rule counts: {'security': 10, 'design': 8, ...}

[2/5] Loading test spec...
  Paths: 3

[3/5] Extracting signals...
  24 signals extracted

[4/5] Matching rules from Vector DB...
  18 findings matched

[5/5] Computing health score and generating report...

  OVERALL HEALTH SCORE: 42.5/100  🟡 Moderate
  ...
```

### Step 4: Start the API Server

```powershell
# Start FastAPI server
python app.py

# Or use uvicorn directly
uvicorn app:app --reload --port 8000
```

Server will be available at: `http://localhost:8000`

---

## 📁 Project Structure

```
SpecSentinal_IBM_Hackathon/
├── venv/                          # Virtual environment (created)
├── .chromadb/                     # ChromaDB storage (auto-created)
│
├── app.py                         # FastAPI server
├── test_pipeline.py               # Integration test
│
├── chroma_client.py               # Vector DB wrapper
├── signal_extractor.py            # OpenAPI parser
├── rule_matcher.py                # Semantic search engine
├── scorer.py                      # Health score calculator
├── reporter.py                    # Report generator
├── scraper.py                     # Web scraper for rules
├── scheduler.py                   # Auto-refresh scheduler
│
├── owasp_rules.json               # OWASP security rules (10 rules)
├── openapi_rules.json             # OpenAPI design rules (8 rules)
├── governance_rules.json          # Error/Doc/Gov rules (11 rules)
│
├── sample_bad_spec.yaml           # Test spec with issues
├── requirements.txt               # Python dependencies
├── README.md                      # Project documentation
├── SETUP.md                       # This file
└── SpecSentinal_IBM_Hackathon.code-workspace
```

---

## 🧪 Testing & Validation

### 1. Run Integration Test

```powershell
python test_pipeline.py
```

This will:
- Initialize ChromaDB with seed rules
- Analyze `sample_bad_spec.yaml`
- Generate health report
- Save `report_output.json`

### 2. Test API Endpoints

```powershell
# Start server
python app.py

# In another terminal, test endpoints:

# Health check
curl http://localhost:8000/health

# Get statistics
curl http://localhost:8000/stats

# Analyze a spec (upload file)
curl -X POST http://localhost:8000/analyze -F "file=@sample_bad_spec.yaml"

# Get text report
curl -X POST "http://localhost:8000/analyze?format=text" -F "file=@sample_bad_spec.yaml"

# Trigger rule refresh
curl -X POST http://localhost:8000/refresh
```

### 3. Verify Vector DB

```powershell
python -c "from chroma_client import SpecSentinelVectorStore; store = SpecSentinelVectorStore(); store.initialize(); print(store.get_collection_stats())"
```

Expected output:
```python
{'security': 10, 'design': 8, 'error_handling': 4, 'documentation': 3, 'governance': 4}
```

---

## 🔧 Configuration

### Vector DB Settings

Edit `chroma_client.py` to customize:
- **Persist path**: Default is `.chromadb/`
- **Similarity metric**: Default is `cosine`
- **Collection names**: 5 collections for rule categories

### Scoring Weights

Edit `scorer.py` to adjust category weights:
```python
CATEGORY_WEIGHTS = {
    "Security":      35,  # Most important
    "Design":        20,
    "ErrorHandling": 15,
    "Documentation": 15,
    "Governance":    15,
}
```

### Severity Deductions

```python
SEVERITY_DEDUCTIONS = {
    "Critical": 20,  # -20 points per critical issue
    "High":     12,
    "Medium":    6,
    "Low":       2,
}
```

---

## 🌐 API Endpoints Reference

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Service info |
| GET | `/health` | Health check + rule counts |
| GET | `/stats` | Vector DB collection stats |
| POST | `/analyze` | Upload spec file (multipart) |
| POST | `/analyze/text` | Send spec as JSON body |
| POST | `/refresh` | Trigger manual rule refresh |

### Example: Analyze Spec via API

```bash
curl -X POST http://localhost:8000/analyze \
  -F "file=@myapi.yaml" \
  -H "accept: application/json"
```

Response:
```json
{
  "meta": {
    "spec_name": "myapi.yaml",
    "generated_at": "2026-03-05T09:00:00Z",
    "tool": "SpecSentinel v1.0"
  },
  "health_score": {
    "total": 68.5,
    "band": "Moderate",
    "band_emoji": "🟡",
    "finding_counts": {
      "total": 15,
      "critical": 2,
      "high": 5,
      "medium": 6,
      "low": 2
    }
  },
  "findings": [...],
  "recommendations": [...]
}
```

---

## 🔄 Auto Rule Refresh

SpecSentinel automatically refreshes rules from external sources:

### Sources
- **OWASP API Security Top 10 2023**
- **OpenAPI 3.x Best Practices**
- **RFC 7807 Problem Details**

### Schedule
- Default: **Weekly** (Sunday 2:00 AM UTC)
- Configurable: `daily`, `hourly`, or `startup_only`

### Manual Refresh
```powershell
# Via API
curl -X POST http://localhost:8000/refresh

# Via CLI
python scheduler.py --schedule startup_only --run-now
```

---

## 🐛 Troubleshooting

### Issue: ModuleNotFoundError

```powershell
# Ensure virtual environment is activated
.\venv\Scripts\Activate.ps1

# Reinstall dependencies
pip install -r requirements.txt
```

### Issue: ChromaDB Not Initializing

```powershell
# Delete and recreate ChromaDB
Remove-Item -Recurse -Force .chromadb
python -c "from chroma_client import SpecSentinelVectorStore; store = SpecSentinelVectorStore(); store.initialize()"
```

### Issue: Port 8000 Already in Use

```powershell
# Use different port
uvicorn app:app --reload --port 8080
```

### Issue: Import Errors

```powershell
# Verify Python path
python -c "import sys; print(sys.path)"

# Ensure you're in project root
cd c:\Users\DebapriyoDasgupta\OneDrive - IBM\Desktop\Work\working with IBM\IBM_Hackathon_26\SpecSentinal_IBM_Hackathon
```

---

## 📊 Scoring Model

### Category Weights
| Category | Weight | What's Checked |
|----------|--------|----------------|
| Security | 35% | Auth schemes, 401/403/429, sensitive data |
| Design | 20% | Versioning, operationId, REST naming, pagination |
| Error Handling | 15% | Error schema, RFC 7807 compliance |
| Documentation | 15% | Summaries, examples, property descriptions |
| Governance | 15% | Versioning, contact, license, deprecation |

### Maturity Bands
- 🔴 **Poor** (0–40): Critical issues, major gaps
- 🟡 **Moderate** (41–70): Some issues, needs improvement
- 🟢 **Good** (71–85): Minor issues, mostly compliant
- ✅ **Excellent** (86–100): Best practices followed

---

## 🎓 Development Workflow

### 1. Make Changes
```powershell
# Edit source files
code signal_extractor.py
```

### 2. Test Changes
```powershell
# Run integration test
python test_pipeline.py
```

### 3. Test API
```powershell
# Start server with auto-reload
uvicorn app:app --reload --port 8000
```

### 4. Add New Rules
```powershell
# Edit rule files
code owasp_rules.json

# Reinitialize vector DB
python -c "from chroma_client import SpecSentinelVectorStore; store = SpecSentinelVectorStore(); store.initialize(force_reseed=True)"
```

---

## 📚 Additional Resources

- **OWASP API Security**: https://owasp.org/API-Security/
- **OpenAPI Specification**: https://spec.openapis.org/oas/v3.1.0
- **RFC 7807**: https://datatracker.ietf.org/doc/html/rfc7807
- **ChromaDB Docs**: https://docs.trychroma.com/
- **FastAPI Docs**: https://fastapi.tiangolo.com/

---

## ✅ Setup Checklist

- [ ] Python 3.9+ installed
- [ ] Virtual environment created
- [ ] Dependencies installed
- [ ] Integration test passes
- [ ] Vector DB initialized
- [ ] API server starts successfully
- [ ] Sample spec analysis works
- [ ] All endpoints respond correctly

---

## 🤝 Support

For issues or questions:
1. Check the troubleshooting section
2. Review the README.md
3. Inspect logs in the terminal
4. Verify all dependencies are installed

---

**SpecSentinel v1.0** - IBM Hackathon 2026
Agentic AI API Health, Compliance & Governance Bot