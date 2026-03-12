# SpecSentinel - Automated Setup Script for Windows PowerShell
# Run this script to set up your development environment

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  SpecSentinel - Development Environment Setup" -ForegroundColor Cyan
Write-Host "  IBM Hackathon 2026" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Python version
Write-Host "[1/6] Checking Python version..." -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
Write-Host "  Found: $pythonVersion" -ForegroundColor Green

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERROR: Python not found. Please install Python 3.9+ first." -ForegroundColor Red
    exit 1
}

# Step 2: Create virtual environment
Write-Host ""
Write-Host "[2/6] Creating virtual environment..." -ForegroundColor Yellow
if (Test-Path "venv") {
    Write-Host "  Virtual environment already exists. Skipping..." -ForegroundColor Green
} else {
    python -m venv venv
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Virtual environment created successfully!" -ForegroundColor Green
    } else {
        Write-Host "  ERROR: Failed to create virtual environment." -ForegroundColor Red
        exit 1
    }
}

# Step 3: Activate virtual environment
Write-Host ""
Write-Host "[3/6] Activating virtual environment..." -ForegroundColor Yellow
& .\venv\Scripts\Activate.ps1
Write-Host "  Virtual environment activated!" -ForegroundColor Green

# Step 4: Install dependencies
Write-Host ""
Write-Host "[4/6] Installing dependencies..." -ForegroundColor Yellow
Write-Host "  This may take a few minutes..." -ForegroundColor Gray
pip install -r requirements.txt --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "  All dependencies installed successfully!" -ForegroundColor Green
} else {
    Write-Host "  ERROR: Failed to install dependencies." -ForegroundColor Red
    exit 1
}

# Step 5: Verify installation
Write-Host ""
Write-Host "[5/6] Verifying installation..." -ForegroundColor Yellow
python -c "import chromadb, fastapi, yaml, requests, bs4; print('  ✅ All packages verified!')"
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERROR: Package verification failed." -ForegroundColor Red
    exit 1
}

# Step 6: Initialize Vector DB
Write-Host ""
Write-Host "[6/6] Initializing Vector Database..." -ForegroundColor Yellow
python -c "from chroma_client import SpecSentinelVectorStore; store = SpecSentinelVectorStore(); store.initialize(); stats = store.get_collection_stats(); print(f'  ✅ Vector DB initialized with {sum(stats.values())} rules')"
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERROR: Vector DB initialization failed." -ForegroundColor Red
    exit 1
}

# Success message
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  ✅ Setup Complete!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Run integration test:" -ForegroundColor White
Write-Host "     python test_pipeline.py" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Start the API server:" -ForegroundColor White
Write-Host "     python app.py" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. Access the API at:" -ForegroundColor White
Write-Host "     http://localhost:8000" -ForegroundColor Gray
Write-Host ""
Write-Host "  4. Read the documentation:" -ForegroundColor White
Write-Host "     README.md and SETUP.md" -ForegroundColor Gray
Write-Host ""
Write-Host "Happy coding! 🚀" -ForegroundColor Cyan

# Made with Bob
