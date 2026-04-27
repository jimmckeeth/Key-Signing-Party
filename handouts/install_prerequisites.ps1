$ErrorActionPreference = "Stop"

function Test-Command {
    param([Parameter(Mandatory = $true)][string]$Name)
    return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

function Test-Typst {
    try {
        typst --version | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

if (-not (Test-Command "winget")) {
    throw "winget is required. Install App Installer from the Microsoft Store, then rerun this script."
}

if (-not (Test-Typst)) {
    winget install --id Typst.Typst --exact --source winget --accept-package-agreements --accept-source-agreements
}

if (-not (Test-Typst)) {
    Write-Warning "Typst was installed, but this shell cannot see it yet. Open a new PowerShell window and run: typst --version"
}
else {
    typst --version
}
