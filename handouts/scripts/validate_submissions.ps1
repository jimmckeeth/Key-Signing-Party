param(
    [string]$InputPath,
    [string]$OutputDir,
    [switch]$SkipKeyserverLookup
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptDir "..\..")

if (-not $InputPath) {
    $InputPath = Join-Path $repoRoot "handouts\data\form_submissions.csv"
}

if (-not $OutputDir) {
    $OutputDir = Join-Path $repoRoot "handouts\build"
}

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    $python = Get-Command py -ErrorAction SilentlyContinue
}

if (-not $python) {
    throw "Python 3 is required to run validation."
}

$validator = Join-Path $scriptDir "validate_submissions.py"
$validatorArgs = @($validator, "--input", $InputPath, "--output-dir", $OutputDir)

if ($SkipKeyserverLookup) {
    $validatorArgs += "--skip-keyserver-lookup"
}

if ($python.Name -eq "py.exe") {
    & $python.Source -3 @validatorArgs
}
else {
    & $python.Source @validatorArgs
}

exit $LASTEXITCODE
