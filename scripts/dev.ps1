param([switch]$Init)

if ($Init) {
  if (-not (Test-Path '.\.venv\Scripts\Activate.ps1')) { py -3.12 -m venv .venv }
}

. .\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r .\requirements.txt
ruff check . --fix
pytest
if (Test-Path '.\main.py') { python .\main.py }
