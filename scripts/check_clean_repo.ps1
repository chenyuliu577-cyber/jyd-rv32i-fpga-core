$ErrorActionPreference = "Stop"

$repo = Resolve-Path (Join-Path $PSScriptRoot "..")
$failed = $false
$issues = New-Object System.Collections.Generic.List[string]

function Add-Issue([string]$message) {
    $script:failed = $true
    $script:issues.Add($message) | Out-Null
}

function Relative-Path([string]$path) {
    $full = [System.IO.Path]::GetFullPath($path)
    $base = [System.IO.Path]::GetFullPath($repo.Path)
    if ($full.StartsWith($base, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $full.Substring($base.Length).TrimStart('\', '/')
    }
    return $full
}

$forbiddenDirs = @(
    ".Xil",
    "digital_twin.cache",
    "digital_twin.gen",
    "digital_twin.hw",
    "digital_twin.ip_user_files",
    "digital_twin.runs",
    "digital_twin.sim"
)

foreach ($dir in $forbiddenDirs) {
    $path = Join-Path $repo.Path $dir
    if (Test-Path -LiteralPath $path) {
        Add-Issue "Forbidden generated directory found: $dir"
    }
}

$forbiddenFilePatterns = @(
    "*.log", "*.jou", "*.dmp", "*.dcp", "*.bit", "*.rpt", "*.wdb",
    "*.str", "*.pb", "*.rpx", "*.wcfg", "*.vcd", "*.fst", "hs_err_pid*"
)

foreach ($pattern in $forbiddenFilePatterns) {
    Get-ChildItem -Path $repo.Path -Recurse -File -Force -Filter $pattern |
        Where-Object { $_.FullName -notmatch "\\.git(\x5c|/|$)" } |
        ForEach-Object { Add-Issue "Forbidden file found: $(Relative-Path $_.FullName)" }
}

$allowlistedMemoryFiles = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::OrdinalIgnoreCase)
@(
    "tests/public-memory/irom.coe",
    "tests/public-memory/dram.coe",
    "tests/public-memory/IROM.mif",
    "tests/public-memory/DRAM.mif",
    "tests/branch-memory/irom.coe",
    "tests/branch-memory/dram.coe",
    "tests/load-store-memory/irom.coe",
    "tests/load-store-memory/dram.coe"
) | ForEach-Object { $allowlistedMemoryFiles.Add($_) | Out-Null }

Get-ChildItem -Path $repo.Path -Recurse -File -Force |
    Where-Object {
        $_.FullName -notmatch "\\.git(\x5c|/|$)" -and
        ($_.Extension -ieq ".coe" -or $_.Extension -ieq ".mif")
    } |
    ForEach-Object {
        $relative = (Relative-Path $_.FullName).Replace('\', '/')
        if ($allowlistedMemoryFiles.Contains($relative)) {
            Write-Host "NOTE: Allowlisted public test memory file: $relative"
        } else {
            Add-Issue "Forbidden memory initialization file found: $relative"
        }
    }

$tooLarge = Get-ChildItem -Path $repo.Path -Recurse -File -Force |
    Where-Object { $_.FullName -notmatch "\\.git(\x5c|/|$)" -and $_.Length -gt 10MB }

foreach ($file in $tooLarge) {
    Add-Issue ("File exceeds 10MB: {0} ({1:N2} MB)" -f (Relative-Path $file.FullName), ($file.Length / 1MB))
}

$sensitivePatterns = @(
    ("C:" + "/Users"),
    ("C:" + "\Users"),
    ("liu" + "385630"),
    ("LAPTOP" + "-TNKPRGBT")
)

$textFiles = Get-ChildItem -Path $repo.Path -Recurse -File -Force |
    Where-Object {
        $_.FullName -notmatch "\\.git(\x5c|/|$)" -and
        $_.Length -lt 10MB
    }

foreach ($file in $textFiles) {
    try {
        $matches = Select-String -Path $file.FullName -Pattern $sensitivePatterns -SimpleMatch -ErrorAction Stop
        foreach ($match in $matches) {
            Add-Issue "Sensitive path or machine identifier found: $(Relative-Path $file.FullName):$($match.LineNumber)"
        }
    } catch {
        # Binary or unreadable files are ignored here; size and extension checks still apply.
    }
}

if ($failed) {
    Write-Host "FAIL: repository contains unsafe files"
    foreach ($issue in $issues) {
        Write-Host " - $issue"
    }
    exit 1
}

Write-Host "PASS: repository is clean"
exit 0
