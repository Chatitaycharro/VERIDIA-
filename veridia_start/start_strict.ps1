Param()

$ErrorActionPreference = "Stop"
$BaseDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Glossary = Join-Path $BaseDir "glosario\v1.1.0"
$Detector = Join-Path $BaseDir "detector\veridia_detector_v0.1"
$Corpus = Join-Path $BaseDir "corpus\caso01"
$LogDir = Join-Path $BaseDir "logs"
$AuditDir = Join-Path $BaseDir "auditoria"

$Timestamp = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
$SessionId = "VERIDIA-SESSION-$Timestamp"
$OutLog = Join-Path $LogDir "session_$Timestamp.json"
$DetectorOut = Join-Path $LogDir "detector_output_$Timestamp.json"
$AuditFile = Join-Path $AuditDir "audit_$Timestamp.md"

function Require-Path([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { throw "Falta artefacto requerido: $Path" }
}

function Verify-Manifest([string]$Directory) {
    $manifest = Join-Path $Directory "sha256sums.txt"
    Require-Path $manifest

    foreach ($line in Get-Content -LiteralPath $manifest) {
        $trimmed = $line.Trim()
        if (-not $trimmed -or $trimmed.StartsWith("#")) { continue }
        if ($trimmed -notmatch '^([a-fA-F0-9]{64})\s+\*?(.+)$') {
            throw "Línea inválida en $manifest`: $line"
        }
        $expected = $Matches[1].ToLowerInvariant()
        $relative = $Matches[2]
        $target = Join-Path $Directory $relative
        Require-Path $target
        $actual = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($actual -ne $expected) { throw "Checksum inválido: $target" }
    }
}

function Get-TreeHash([string]$Directory) {
    $lines = Get-ChildItem -LiteralPath $Directory -Recurse -File |
        Where-Object { $_.Name -ne 'sha256sums.txt' } |
        Sort-Object FullName |
        ForEach-Object {
            $hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
            "$hash  $($_.FullName.Substring($Directory.Length).TrimStart('\'))"
        }
    $temp = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllLines($temp, $lines, [System.Text.UTF8Encoding]::new($false))
        return (Get-FileHash -LiteralPath $temp -Algorithm SHA256).Hash.ToLowerInvariant()
    } finally {
        Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue
    }
}

Require-Path $Glossary
Require-Path $Detector
Require-Path $Corpus
$RunDetector = Join-Path $Detector "run_detector.py"
Require-Path $RunDetector
if (-not (Get-Command python -ErrorAction SilentlyContinue)) { throw "Python no está disponible" }

New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
New-Item -ItemType Directory -Path $AuditDir -Force | Out-Null

Write-Output "Verificando integridad de glosario y detector..."
Verify-Manifest $Glossary
Verify-Manifest $Detector

$sessionObj = [ordered]@{
    session_id = $SessionId
    start_time = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    glossary_version = "v1.1.0"
    detector_version = "veridia_detector_v0.1"
    corpus_id = "caso01"
    agents_active = @("detector", "registrador", "auditor")
    mode = "strict"
    hash_glossary = "sha256:$(Get-TreeHash $Glossary)"
    hash_detector = "sha256:$(Get-TreeHash $Detector)"
    notes = ""
}
$sessionObj | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $OutLog -Encoding utf8

Write-Output "Ejecutando detector en modo verify..."
& python $RunDetector --corpus $Corpus --glossary $Glossary --out $DetectorOut --mode verify
if ($LASTEXITCODE -ne 0) { throw "El detector terminó con código $LASTEXITCODE" }
Require-Path $DetectorOut
if ((Get-Item -LiteralPath $DetectorOut).Length -eq 0) { throw "El detector produjo una salida vacía" }
Get-Content -LiteralPath $DetectorOut -Raw | ConvertFrom-Json | Out-Null

@"
# Audit Entry: AUDIT-$Timestamp

**audit_id**: AUDIT-$Timestamp  
**session_id**: $SessionId  
**issue_type**: pendiente  
**evidence_excerpt**:  
**recommended_action**:  
**auditor**:  
**status**: pendiente  
**timestamp**: $((Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ"))

## Detalle

- **detector_output**: $(Split-Path $DetectorOut -Leaf)
- **decisión aplicada**: ninguna; requiere revisión humana.
"@ | Set-Content -LiteralPath $AuditFile -Encoding utf8

Write-Output "Ejecución completada."
Write-Output "Registro: $OutLog"
Write-Output "Detector: $DetectorOut"
Write-Output "Auditoría: $AuditFile"
