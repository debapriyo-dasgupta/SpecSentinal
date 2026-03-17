# SpecSentinel - Complete Setup Guide

**Agentic AI API Health, Compliance & Governance Bot**  
IBM Hackathon 2026 | Version 1.0.0

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation Steps](#installation-steps)
3. [Environment Configuration](#environment-configuration)
4. [Running the Application](#running-the-application)
5. [Verification & Testing](#verification--testing)
6. [Troubleshooting](#troubleshooting)
7. [Advanced Configuration](#advanced-configuration)
8. [API Reference](#api-reference)

---

## Prerequisites

### Required Software

- **Python 3.11 or higher** (Python 3.9+ supported)
  - Download: https://www.python.org/downloads/
  - Verify: `python --version`

- **pip** (Python package manager)
  - Usually included with Python
  - Verify: `pip --version`

- **Git** (for cloning repository)
  - Download: https://git-scm.com/downloads
  - Verify: `git --version`

### System Requirements

- **OS**: Windows 10/11, Linux, macOS
- **RAM**: 4GB minimum, 8GB recommended
- **Disk Space**: 2GB free space
- **Network**: Internet connection for initial setup and rule updates

---

## Installation Steps

### Step 1: Clone the Repository

```bash
# Clone the repository
git clone <repository-url>
cd SpecSentinel

# Or if you already have the project
cd path/to/SpecSentinel
```

### Step 2: Create Virtual Environment

**Windows (PowerShell):**
```powershell
# Create virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\Activate.ps1

# If you get execution policy error, run:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Windows (Command Prompt):**
```cmd
# Create virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\activate.bat
```

**Linux/Mac:**
```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate
```

**Verify activation:**
```bash
# Your prompt should show (venv) prefix
# Check Python path
which python  # Linux/Mac
where python  # Windows
```

### Step 3: Install Dependencies

```bash
# Install all dependencies (backend + frontend + AI)
pip install -r requirements.txt

# Verify installation
python -c "import chromadb, fastapi, flask, yaml; print('✅ All core packages installed!')"
```

**Expected output:**
```
✅ All core packages installed!
```

### Step 4: Configure Environment Variables (Optional)

```bash
# Copy example environment file
cp .env.example .env

# Edit .env file with your preferred text editor
# Windows: notepad .env
# Linux/Mac: nano .env
```

See [Environment Configuration](#environment-configuration) section for details.

---

## Environment Configuration

### Create .env File

Create a `.env` file in the project root directory:

```bash
# Copy the example file
cp .env.example .env
```

### Available Environment Variables

#### 1. Logging Configuration

```bash
# Log level: DEBUG, INFO, WARNING, ERROR, CRITICAL
LOG_LEVEL=INFO

# Enable JSON logging (recommended for production)
JSON_LOGGING=false

# Enable file logging (logs saved to logs/ directory)
FILE_LOGGING=true
```

#### 2. AI/LLM Configuration (Optional)

**Choose ONE or more LLM providers:**

**OpenAI (GPT Models):**
```bash
OPENAI_API_KEY=sk-your-openai-api-key-here
OPENAI_MODEL=gpt-4o-mini
```
- Get API key: https://platform.openai.com/api-keys
- Models: `gpt-4o-mini`, `gpt-4o`, `gpt-3.5-turbo`
- Cost: ~$0.01-0.05 per analysis

**Anthropic (Claude Models):**
```bash
ANTHROPIC_API_KEY=sk-ant-your-anthropic-api-key-here
ANTHROPIC_MODEL=claude-3-5-sonnet-20241022
```
- Get API key: https://console.anthropic.com/
- Models: `claude-3-5-sonnet-20241022`, `claude-3-haiku-20240307`
- Cost: ~$0.02-0.10 per analysis

**IBM WatsonX.ai (Granite, Llama, Mixtral):**
```bash
WATSONX_API_KEY=your-ibm-cloud-api-key
WATSONX_PROJECT_ID=your-project-id
WATSONX_URL=https://us-south.ml.cloud.ibm.com
WATSONX_MODEL=ibm/granite-13b-chat-v2
```
- Get credentials: https://cloud.ibm.com/
- Models: `ibm/granite-13b-chat-v2`, `meta-llama/llama-3-70b-instruct`, `mistralai/mixtral-8x7b-instruct-v01`
- Cost: Based on IBM Cloud pricing

**Google Gemini:**
```bash
GOOGLE_API_KEY=your-google-api-key
GOOGLE_MODEL=gemini-1.5-flash
```
- Get API key: https://makersuite.google.com/app/apikey
- Models: `gemini-1.5-flash`, `gemini-1.5-pro`
- Cost: Free tier available

#### 3. Feature Flags

```bash
# Enable multi-agent analysis (requires LLM)
USE_MULTI_AGENT=false

# Maximum AI-generated fixes per severity level
AI_FIX_MAX_COUNT=2

# Severity levels for AI fix generation
AI_FIX_SEVERITIES=Critical,High,Medium
```

#### 4. Backend Configuration

```bash
# Backend API URL (for frontend)
BACKEND_API_URL=http://localhost:8000
```

#### 5. Vector Database Configuration

```bash
# ChromaDB persistence path
CHROMA_DB_PATH=.chromadb

# Run rule ingestion on startup
RUN_INGESTION_ON_STARTUP=false

# Ingestion schedule: daily, weekly, monthly
INGESTION_SCHEDULE=weekly
```

### Minimal Configuration (No AI)

If you don't want AI features, you can skip all LLM configuration. The system works perfectly without AI:

```bash
# .env file (minimal)
LOG_LEVEL=INFO
FILE_LOGGING=true
USE_MULTI_AGENT=false
```

---

## Running the Application

### Option 1: Run Everything (Recommended)

**Single command to start both backend and frontend:**

```bash
python run_app.py
```

**Expected output:**
```
============================================================
SpecSentinel - API Health Analyzer
============================================================

🚀 Starting Backend API on http://localhost:8000...
🌐 Starting Frontend on http://localhost:5000...

============================================================
✅ Both servers are running!
============================================================

📍 Backend API:  http://localhost:8000
📍 Frontend UI:  http://localhost:5000

🌐 Open your browser and navigate to: http://localhost:5000

Press Ctrl+C to stop both servers
============================================================
```

**Access the application:**
- Frontend UI: http://localhost:5000
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

### Option 2: Run Backend Only

```bash
# Navigate to API directory
cd src/api

# Start backend
python app.py

# Or use uvicorn directly
uvicorn app:app --reload --port 8000
```

### Option 3: Run Frontend Only

```bash
# Navigate to frontend directory
cd frontend

# Start frontend
python app.py
```

**Note:** Frontend requires backend to be running on port 8000.

### Option 4: Run Integration Test (No Server)

```bash
# Test the complete pipeline without starting servers
python tests/test_pipeline.py
```

---

## Verification & Testing

### 1. Test Backend API

**Check health endpoint:**
```bash
curl http://localhost:8000/health
```

**Expected response:**
```json
{
  "status": "healthy",
  "version": "1.0.0",
  "rule_counts": {
    "security": 10,
    "design": 8,
    "error_handling": 4,
    "documentation": 3,
    "governance": 4
  }
}
```

### 2. Test Vector Database

```bash
# Check collection statistics
curl http://localhost:8000/stats
```

**Expected response:**
```json
{
  "collections": {
    "security": 10,
    "design": 8,
    "error_handling": 4,
    "documentation": 3,
    "governance": 4
  },
  "total_rules": 29
}
```

### 3. Test API Analysis

```bash
# Analyze a sample spec
curl -X POST http://localhost:8000/analyze \
  -F "file=@tests/sample_bad_spec.yaml" \
  -H "accept: application/json"
```

### 4. Test Frontend

1. Open browser: http://localhost:5000
2. Upload `tests/sample_bad_spec.yaml`
3. Click "Analyze Specification"
4. Verify results are displayed

### 5. Run Integration Test

```bash
python tests/test_pipeline.py
```

**Expected output:**
```
============================================================
  SpecSentinel — Pipeline Integration Test
============================================================

[1/5] Initializing Vector Store...
  ✅ Vector store initialized
  Rule counts: {'security': 10, 'design': 8, ...}

[2/5] Loading test spec...
  ✅ Loaded: tests/sample_bad_spec.yaml
  Paths: 3, Operations: 3

[3/5] Extracting signals...
  ✅ Extracted 24 signals

[4/5] Matching rules from Vector DB...
  ✅ Matched 18 findings

[5/5] Computing health score and generating report...
  ✅ Report generated

============================================================
  OVERALL HEALTH SCORE: 42.5/100  🟡 Moderate
============================================================
```

---

## Troubleshooting

### Issue 1: ModuleNotFoundError

**Problem:**
```
ModuleNotFoundError: No module named 'chromadb'
```

**Solution:**
```bash
# Ensure virtual environment is activated
# Windows PowerShell:
.\venv\Scripts\Activate.ps1

# Linux/Mac:
source venv/bin/activate

# Reinstall dependencies
pip install -r requirements.txt

# Verify installation
pip list | grep chromadb
```

### Issue 2: Port Already in Use

**Problem:**
```
Error: [Errno 48] Address already in use
```

**Solution:**

**Windows:**
```powershell
# Find process using port 8000
netstat -ano | findstr :8000

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F

# Or use different port
uvicorn src.api.app:app --port 8080
```

**Linux/Mac:**
```bash
# Find process using port 8000
lsof -i :8000

# Kill the process
kill -9 <PID>

# Or use different port
uvicorn src.api.app:app --port 8080
```

### Issue 3: ChromaDB Not Initializing

**Problem:**
```
Error: ChromaDB initialization failed
```

**Solution:**
```bash
# Delete ChromaDB directory
# Windows:
Remove-Item -Recurse -Force .chromadb

# Linux/Mac:
rm -rf .chromadb

# Reinitialize
python -c "from src.vectordb.store.chroma_client import SpecSentinelVectorStore; store = SpecSentinelVectorStore(); store.initialize()"
```

### Issue 4: Import Errors

**Problem:**
```
ImportError: cannot import name 'X' from 'Y'
```

**Solution:**
```bash
# Ensure you're in project root
cd path/to/SpecSentinel

# Check Python path
python -c "import sys; print(sys.path)"

# Reinstall in editable mode
pip install -e .
```

### Issue 5: Virtual Environment Not Activating

**Problem (Windows):**
```
cannot be loaded because running scripts is disabled
```

**Solution:**
```powershell
# Run as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Then activate again
.\venv\Scripts\Activate.ps1
```

### Issue 6: Frontend Can't Connect to Backend

**Problem:**
```
Failed to fetch: http://localhost:8000/analyze
```

**Solution:**
1. Verify backend is running:
   ```bash
   curl http://localhost:8000/health
   ```

2. Check CORS settings in `src/api/app.py`

3. Check browser console (F12) for errors

4. Verify `BACKEND_API_URL` in `.env`:
   ```bash
   BACKEND_API_URL=http://localhost:8000
   ```

### Issue 7: AI Agent Not Working

**Problem:**
```
AI Agent not available
```

**Solution:**
```bash
# Verify API key is set
# Windows:
echo $env:OPENAI_API_KEY

# Linux/Mac:
echo $OPENAI_API_KEY

# Set API key
# Windows:
$env:OPENAI_API_KEY = "sk-your-key"

# Linux/Mac:
export OPENAI_API_KEY="sk-your-key"

# Or add to .env file
echo "OPENAI_API_KEY=sk-your-key" >> .env
```

### Issue 8: Logs Not Generated

**Problem:**
No log files in `logs/` directory

**Solution:**
```bash
# Check if FILE_LOGGING is enabled
# Windows:
echo $env:FILE_LOGGING

# Linux/Mac:
echo $FILE_LOGGING

# Enable file logging
# Windows:
$env:FILE_LOGGING = "true"

# Linux/Mac:
export FILE_LOGGING=true

# Or add to .env
echo "FILE_LOGGING=true" >> .env

# Create logs directory if missing
mkdir logs
```

### Issue 9: Permission Denied

**Problem:**
```
PermissionError: [Errno 13] Permission denied
```

**Solution:**
```bash
# Windows: Run as Administrator
# Linux/Mac: Use sudo or fix permissions
chmod -R 755 .
```

### Issue 10: Slow Performance

**Problem:**
Analysis takes too long

**Solution:**
1. Check system resources (CPU, RAM)
2. Reduce AI fix generation:
   ```bash
   AI_FIX_MAX_COUNT=1
   AI_FIX_SEVERITIES=Critical
   ```
3. Disable multi-agent mode:
   ```bash
   USE_MULTI_AGENT=false
   ```
4. Use faster LLM model:
   ```bash
   OPENAI_MODEL=gpt-4o-mini
   ```

---

## Advanced Configuration

### Custom Scoring Weights

Edit `src/engine/scorer.py`:

```python
CATEGORY_WEIGHTS = {
    "Security":      35,  # Adjust these values
    "Design":        20,  # Must sum to 100
    "ErrorHandling": 15,
    "Documentation": 15,
    "Governance":    15,
}

SEVERITY_DEDUCTIONS = {
    "Critical": 20,  # Points deducted per finding
    "High":     12,
    "Medium":    6,
    "Low":       2,
}
```

### Custom Rules

Add rules to JSON files in `data/rules/`:

**Example: Add security rule to `data/rules/owasp_rules.json`:**
```json
{
  "id": "custom-sec-001",
  "title": "Missing Rate Limiting",
  "category": "Security",
  "severity": "High",
  "description": "API endpoints should implement rate limiting",
  "check_pattern": "missing rate limit",
  "fix_guidance": "Add rate limiting middleware",
  "tags": ["security", "rate-limit", "dos"]
}
```

**Reinitialize vector database:**
```bash
python -c "from src.vectordb.store.chroma_client import SpecSentinelVectorStore; store = SpecSentinelVectorStore(); store.initialize(force_reseed=True)"
```

### Auto Rule Refresh

Configure automatic rule updates in `.env`:

```bash
# Run ingestion on startup
RUN_INGESTION_ON_STARTUP=true

# Schedule: daily, weekly, monthly
INGESTION_SCHEDULE=weekly
```

**Manual refresh:**
```bash
# Via API
curl -X POST http://localhost:8000/refresh

# Via CLI
python src/vectordb/ingest/scheduler.py --schedule startup_only --run-now
```

---

## API Reference

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Service information |
| GET | `/health` | Health check + rule counts |
| GET | `/stats` | Vector DB statistics |
| POST | `/analyze` | Upload spec file (multipart/form-data) |
| POST | `/analyze/text` | Send spec as JSON body |
| POST | `/refresh` | Trigger manual rule refresh |

### Example: Analyze Spec

```bash
# Upload file
curl -X POST http://localhost:8000/analyze \
  -F "file=@myapi.yaml" \
  -H "accept: application/json"

# Get text report
curl -X POST "http://localhost:8000/analyze?format=text" \
  -F "file=@myapi.yaml"

# Send as JSON
curl -X POST http://localhost:8000/analyze/text \
  -H "Content-Type: application/json" \
  -d @myapi.json
```

### Response Format

```json
{
  "meta": {
    "spec_name": "myapi.yaml",
    "generated_at": "2026-03-17T12:00:00Z",
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
    },
    "category_scores": {
      "Security": 45.0,
      "Design": 70.0,
      "ErrorHandling": 60.0,
      "Documentation": 80.0,
      "Governance": 75.0
    }
  },
  "findings": [...],
  "recommendations": [...]
}
```

---

## Quick Reference

### Start Application
```bash
python run_app.py
```

### Test Pipeline
```bash
python tests/test_pipeline.py
```

### Check Health
```bash
curl http://localhost:8000/health
```

### View Logs
```bash
# Windows:
Get-Content logs\specsentinel.log -Wait

# Linux/Mac:
tail -f logs/specsentinel.log
```

### Stop Application
```
Press Ctrl+C in terminal
```

---

## Support & Resources

### Documentation
- Main README: `README.md`
- Frontend Guide: `frontend/README.md`
- This Setup Guide: `docs/SETUP.md`

### External Resources
- **OWASP API Security**: https://owasp.org/API-Security/
- **OpenAPI Specification**: https://spec.openapis.org/oas/v3.1.0
- **ChromaDB Docs**: https://docs.trychroma.com/
- **FastAPI Docs**: https://fastapi.tiangolo.com/

### Getting Help
1. Check troubleshooting section above
2. Review logs in `logs/` directory
3. Verify all dependencies are installed
4. Check environment variables in `.env`

---

## Setup Checklist

- [ ] Python 3.11+ installed and verified
- [ ] Virtual environment created and activated
- [ ] Dependencies installed (`pip install -r requirements.txt`)
- [ ] `.env` file configured (optional)
- [ ] Integration test passes (`python tests/test_pipeline.py`)
- [ ] Backend starts successfully (`python run_app.py`)
- [ ] Frontend accessible at http://localhost:5000
- [ ] Sample spec analysis works
- [ ] All API endpoints respond correctly

---

**SpecSentinel v1.0** - IBM Hackathon 2026  
Agentic AI API Health, Compliance & Governance Bot

**Ready to analyze your APIs!** 🚀