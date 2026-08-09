Param()

$ErrorActionPreference = "Stop"

$BaseDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Glossary = Join-Path $BaseDir "glosario\v1.1.0"
$Detector = Join-Path $BaseDir "detector\veridia_detector_v0.1"
$Corpus = Join-Path $BaseDir "corpus\caso01"
$LogDir = Join-Path $BaseDir "logs"
$AuditDir = Join-Path $BaseDir "auditoria"
$RunDetector = Join-Path $Detector "run_detector.py"

$Timestamp = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
$IsoTime = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$SessionId = "VERIDIA-SESSION-$Timestamp"
$OutLog = Join-Path $LogDir "session_$Timestamp.json"
$DetectorOut = Join-Path $LogDir "detector_output_$Timestamp.json"
$AuditFile = Join-Path $AuditDir "audit_$Timestamp.md"

function Assert-Path([string]$Path, [string]$Description, [string]$Type = "Any") {
    $ok = if ($Type -eq "Leaf") { Test-Path -LiteralPath $Path -PathType Leaf } elseif ($Type -eq "Container") { Test-Path -LiteralPath $Path -PathType Container } else { Test-Path -LiteralPath $Path }
    if (-not $ok) { throw "Falta $Description`: $Path" }
}

function Get-DirectoryHash([string]$Directory) {
    $lines = Get-ChildItem -LiteralPath $Directory -File -Recurse |
        Where-Object { $_.Name -ne "sha256sums.txt" } |
        Sort-Object FullName |
        ForEach-Object {
            $relative = [System.IO.Path]::GetRelativePath($Directory, $_.FullName).Replace('\','/')
            $hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
            "$hash  $relative"
        }
    $payload = [System.Text.Encoding]::UTF8.GetBytes(($lines -join "`n") + "`n")
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($sha.ComputeHash($payload))).Replace("-", "").ToLowerInvariant() }
    finally { $sha.Dispose() }
}

function Test-HashManifest([string]$Directory) {
    $manifest = Join-Path $Directory "sha256sums.txt"
    if (-not (Test-Path -LiteralPath $manifest -PathType Leaf)) { return }
    foreach ($line in Get-Content -LiteralPath $manifest) {
        if ([string]::IsNullOrWhiteSpace($line) -or $line.TrimStart().StartsWith('#')) { continue }
        if ($line -notmatch '^([A-Fa-f0-9]{64})\s+\*?(.+)$') { throw "Línea inválida en $manifest`: $line" }
        $expected = $Matches[1].ToLowerInvariant()
        $relative = $Matches[2].Trim()
        $file = Join-Path $Directory $relative
        Assert-Path $file "archivo listado en manifiesto" "Leaf"
        $actual = (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($actual -ne $expected) { throw "Checksum inválido: $file" }
    }
}

Assert-Path $Glossary "glosario" "Container"
Assert-Path $Detector "detector" "Container"
Assert-Path $Corpus "corpus" "Container"
Assert-Path $RunDetector "run_detector.py" "Leaf"

$Python = Get-Command python -ErrorAction SilentlyContinue
if (-not $Python) { $Python = Get-Command py -ErrorAction SilentlyContinue }
if (-not $Python) { throw "Python no está disponible" }

New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
New-Item -ItemType Directory -Path $AuditDir -Force | Out-Null

Write-Output "Verificando integridad de artefactos..."
Test-HashManifest $Glossary
Test-HashManifest $Detector

$hashGlossary = Get-DirectoryHash $Glossary
$hashDetector = Get-DirectoryHash $Detector

$sessionObj = [ordered]@{
    session_id = $SessionId
    start_time = $IsoTime
    glossary_version = "v1.1.0"
    detector_version = "veridia_detector_v0.1"
    corpus_id = "caso01"
    agents_active = @("detector", "registrador", "auditor")
    mode = "strict"
    hash_glossary = "sha256:$hashGlossary"
    hash_detector = "sha256:$hashDetector"
    notes = ""
}
$sessionObj | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $OutLog -Encoding utf8

Write-Output "Ejecutando detector en modo verify..."
if ($Python.Name -eq "py.exe" -or $Python.Name -eq "py") {
    & $Python.Source -3 $RunDetector --corpus $Corpus --glossary $Glossary --out $DetectorOut --mode verify
} else {
    & $Python.Source $RunDetector --corpus $Corpus --glossary $Glossary --out $DetectorOut --mode verify
}
if ($LASTEXITCODE -ne 0) { throw "El detector terminó con código $LASTEXITCODE" }
Assert-Path $DetectorOut "salida del detector" "Leaf"
if ((Get-Item -LiteralPath $DetectorOut).Length -eq 0) { throw "El detector produjo un archivo vacío" }

$DetectorOutputHash = (Get-FileHash -LiteralPath $DetectorOut -Algorithm SHA256).Hash.ToLowerInvariant()
@"
# Audit Entry: AUDIT-$Timestamp

**audit_id**: AUDIT-$Timestamp  
**session_id**: $SessionId  
**issue_type**: pendiente  
**evidence_excerpt**:  
**recommended_action**:  
**auditor**:  
**status**: pendiente  
**timestamp**: $IsoTime

## Detalle

- **detector_output**: $(Split-Path $DetectorOut -Leaf)
- **detector_output_sha256**: $DetectorOutputHash
"@ | Set-Content -LiteralPath $AuditFile -Encoding utf8

Write-Output "Ejecución completada."
Write-Output "Registro: $OutLog"
Write-Output "Detector: $DetectorOut"
Write-Output "Auditoría: $AuditFile"
