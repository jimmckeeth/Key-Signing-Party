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

$python = Get-Command py -ErrorAction SilentlyContinue
$useLauncher = $null -ne $python

if (-not $python) {
    $python = Get-Command python -ErrorAction SilentlyContinue
}

if (-not $python) {
    throw "Python 3 is required to run validation."
}

$validator = Join-Path $scriptDir "validate_submissions.py"
$validatorArgs = @($validator, "--input", $InputPath, "--output-dir", $OutputDir)

if ($SkipKeyserverLookup) {
    $validatorArgs += "--skip-keyserver-lookup"
}

$versionArgs = @("--version")
if ($useLauncher) {
    $versionArgs = @("-3", "--version")
}

$versionOutput = & $python.Source @versionArgs 2>&1
if ($LASTEXITCODE -ne 0 -or ($versionOutput -notmatch "Python 3\.")) {
    throw "Python 3 is required to run validation. Found: $versionOutput"
}

if ($useLauncher) {
    & $python.Source -3 @validatorArgs
}
else {
    & $python.Source @validatorArgs
}

exit $LASTEXITCODE
