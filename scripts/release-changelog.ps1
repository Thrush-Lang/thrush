Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Set-Location (Join-Path $PSScriptRoot "..")
New-Item -ItemType Directory -Force -Path "changelogs" | Out-Null

Write-Host "Available tags:"
git tag --sort=-version:refname
Write-Host ""

$prev_tag = Read-Host "Enter previous tag"
if ([string]::IsNullOrWhiteSpace($prev_tag)) {
    Write-Error "Error: Previous tag is required."
    exit 1
}

$null = git rev-parse --verify --quiet "refs/tags/$prev_tag" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "Error: Tag '$prev_tag' does not exist."
    exit 1
}

$tag_name = Read-Host "Enter new tag name"
if ([string]::IsNullOrWhiteSpace($tag_name)) {
    Write-Error "Error: New tag name is required."
    exit 1
}

$range = "$prev_tag..HEAD"
$release_dir = "changelogs/$tag_name"
New-Item -ItemType Directory -Force -Path $release_dir | Out-Null

Write-Host "Generating changelog for: $range"
git-cliff $range --output "$release_dir/README.md"

cargo run --quiet 2>$null
$help_output = & "./target/debug/thrustc.exe" --help 2>&1

if (-not [string]::IsNullOrWhiteSpace($help_output)) {
    Add-Content "$release_dir/README.md" ""
    Add-Content "$release_dir/README.md" "## Command Line"
    Add-Content "$release_dir/README.md" '```console'
    Add-Content "$release_dir/README.md" $help_output
    Add-Content "$release_dir/README.md" '```'
}

$versionMatch = [regex]::Match($tag_name, '\d+\.\d+\.\d+')
if (-not $versionMatch.Success) {
    Write-Error "Error: Could not extract a version number (x.y.z) from tag '$tag_name'."
    exit 1
}
$version = $versionMatch.Value
$inPkg = $false
$cargoContent = Get-Content "Cargo.toml" | ForEach-Object {
    if ($_ -match '^\[workspace\.package\]') { $inPkg = $true }
    elseif ($_ -match '^\[') { $inPkg = $false }
    if ($inPkg -and $_ -match '^version\s*=') {
        "version = `"$version`""
    } else {
        $_
    }
}
Set-Content "Cargo.toml" $cargoContent

git add "$release_dir/README.md" "Cargo.toml"
git commit -m "Bumping '$tag_name'"

git tag $tag_name
if ($LASTEXITCODE -ne 0) {
    Write-Error "Error: Failed to create tag '$tag_name'."
    exit 1
}
git push origin HEAD $tag_name
if ($LASTEXITCODE -ne 0) {
    Write-Error "Error: Failed to push to remote."
    exit 1
}

Write-Host "Changelog generated at $release_dir/README.md"
Write-Host "Done."
