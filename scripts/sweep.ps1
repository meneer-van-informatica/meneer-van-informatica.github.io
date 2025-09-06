param([switch]$DryRun)

$repos = @(
  'E:\the-101-game',
  'E:\meneer-van-informatica.github.io'
)

foreach ($r in $repos) {
  if (-not (Test-Path $r)) { continue }
  Set-Location $r

  Write-Host "== $r ==" -ForegroundColor Cyan
  git status

  git fetch --all --prune
  git remote prune origin

  if ($DryRun) {
    git clean -ndX
  } else {
    git clean -fdX
  }

  # verwijder lokaal alle volledig in main gemergede branches (behalve main)
  $merged = git branch --merged main | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne 'main' -and -not $_.StartsWith('*') }
  foreach ($b in $merged) { git branch -d $b }

  # compacte en opruim de database
  git gc --prune=now
}
