# Top N grootste blobs in de hele git-geschiedenis (PowerShell-native)
param([int]$Top = 30)

# safety voor jouw exFAT pad
git config --global --add safe.directory E:/meneer-van-informatica.github.io | Out-Null

# haal alle objecten + groottes op en parse
$lines = & git rev-list --objects --all | & git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)'

$records = foreach ($ln in $lines) {
    if (-not $ln) { continue }
    $type, $sha, $size, $path = $ln -split '\s+', 4
    if ($type -ne 'blob') { continue }
    [pscustomobject]@{
        SizeBytes = [int64]$size
        SizeMB    = [math]::Round($size/1MB, 2)
        Sha       = $sha
        Path      = $path
    }
}

$records |
  Sort-Object SizeBytes -Descending |
  Select-Object -First $Top Sha, SizeMB, Path |
  Format-Table -AutoSize
