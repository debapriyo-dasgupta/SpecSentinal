# SpecSentinel - Project Structure

## 📁 Directory Organization

```
SpecSentinel_IBM_Hackathon/
│
├── 📄 README.md                          # Main project documentation
├── 📄 setup.py                           # Package installation configuration
├── 📄 requirements.txt                   # Python dependencies
├── 📄 .gitignore                         # Git ignore rules
├── 📄 report_output.json                 # Generated test output
├── 📄 SpecSentinal_IBM_Hackathon.code-workspace  # VS Code workspace
│
├── 📂 src/                               # SOURCE CODE
│   ├── 📄 __init__.py
│   │
│   ├── 📂 engine/                        # Core Analysis Engine
│   │   ├── 📄 __init__.py
│   │   ├── 📄 signal_extractor.py       # Parses OpenAPI specs → signals
│   │   ├── 📄 rule_matcher.py           # Semantic search in vector DB
│   │   ├── 📄 scorer.py                 # Computes 0-100 health score
│   │   └── 📄 reporter.py               # Generates JSON/text reports
│   │
│   ├── 📂 vectordb/                      # Vector Database Layer
│   │   ├── 📄 __init__.py
│   │   │
│   │   ├── 📂 store/                     # Database Management
│   │   │   ├── 📄 __init__.py
│   │   │   └── 📄 chroma_client.py      # ChromaDB wrapper & operations
│   │   │
│   │   └── 📂 ingest/                    # Rule Ingestion
│   │       ├── 📄 __init__.py
│   │       ├── 📄 scraper.py            # Web scraper for external rules
│   │       └── 📄 scheduler.py          # APScheduler for auto-refresh
│   │
│   └── 📂 api/                           # REST API
│       ├── 📄 __init__.py
│       └── 📄 app.py                    # FastAPI application server
│
├── 📂 data/                              # DATA FILES
│   └── 📂 rules/                         # Seed Rule Files
│       ├── 📄 owasp_rules.json          # 10 OWASP API Security rules
│       ├── 📄 openapi_rules.json        # 8 OpenAPI design rules
│       └── 📄 governance_rules.json     # 11 error/doc/governance rules
│
├── 📂 tests/                             # TESTS
│   ├── 📄 __init__.py
│   ├── 📄 test_pipeline.py              # Integration test
│   └── 📄 sample_bad_spec.yaml          # Test OpenAPI specification
│
├── 📂 docs/                              # DOCUMENTATION
│   ├── 📄 README.md                     # Detailed project documentation
│   ├── 📄 SETUP.md                      # Setup instructions
│   └── 📄 PROJECT_SUMMARY.md            # Technical architecture summary
│
└── 📂 config/                            # CONFIGURATION
    └── 📄 setup.ps1                     # Automated setup script (PowerShell)
```

## 🏗️ Architecture Layers

### 1. **Engine Layer** (`src/engine/`)
Core business logic for API analysis:
- **Signal Extraction**: Parses OpenAPI specs and identifies potential issues
- **Rule Matching**: Semantic search against vector database
- **Scoring**: Weighted health score calculation
- **Reporting**: Structured output generation

### 2. **Vector Database Layer** (`src/vectordb/`)
Manages the rule knowledge base:
- **Store**: ChromaDB operations and queries
- **Ingest**: Automated rule updates from external sources

### 3. **API Layer** (`src/api/`)
REST API interface:
- FastAPI server with multiple endpoints
- File upload support
- Background task scheduling

### 4. **Data Layer** (`data/`)
Static data files:
- Seed rules for initial database population
- Organized by category (security, design, governance)

### 5. **Test Layer** (`tests/`)
Testing infrastructure:
- Integration tests
- Sample specifications
- Test utilities

## 📦 Package Structure

The project follows Python best practices:

```python
# Import examples after installation:
from src.engine.signal_extractor import OpenAPISignalExtractor
from src.engine.rule_matcher import RuleMatcher
from src.engine.scorer import compute_health_score
from src.engine.reporter import build_report

from src.vectordb.store.chroma_client import SpecSentinelVectorStore
from src.vectordb.ingest.scheduler import start_scheduler
```

## 🔄 Data Flow

```
1. OpenAPI Spec (YAML/JSON)
   ↓
2. Signal Extractor (src/engine/signal_extractor.py)
   ↓
3. Rule Matcher (src/engine/rule_matcher.py)
   ↓
4. Vector DB Query (src/vectordb/store/chroma_client.py)
   ↓
5. Health Scorer (src/engine/scorer.py)
   ↓
6. Report Generator (src/engine/reporter.py)
   ↓
7. JSON/Text Output
```

## 🎯 Key Design Principles

1. **Separation of Concerns**: Each module has a single responsibility
2. **Modularity**: Components can be used independently
3. **Testability**: Clear interfaces for unit and integration testing
4. **Scalability**: Vector DB can handle thousands of rules
5. **Maintainability**: Well-organized structure with clear naming

## 📊 File Statistics

- **Total Python Files**: 11
- **Total Lines of Code**: ~2,300
- **Rule Files**: 3 (29 total rules)
- **Test Files**: 2
- **Documentation Files**: 4

## 🚀 Getting Started

1. Install the package: `pip install -e .`
2. Run tests: `python tests/test_pipeline.py`
3. Start API: `python src/api/app.py`
4. Access docs: See `docs/` directory

---

**Last Updated**: 2026-03-11  
**Version**: 1.0.0