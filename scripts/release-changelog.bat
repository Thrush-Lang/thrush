@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0\.."
if not exist changelogs mkdir changelogs

echo Available tags:
git tag --sort=-version:refname
echo.

set /p prev_tag="Enter previous tag: "
if "%prev_tag%"=="" (
    echo Error: Previous tag is required.
    exit /b 1
)

git rev-parse --verify --quiet "refs/tags/%prev_tag%" >nul 2>&1
if errorlevel 1 (
    echo Error: Tag '%prev_tag%' does not exist.
    exit /b 1
)

set /p tag_name="Enter new tag name: "
if "%tag_name%"=="" (
    echo Error: New tag name is required.
    exit /b 1
)

set range=%prev_tag%..HEAD
set release_dir=changelogs\%tag_name%
if not exist "%release_dir%" mkdir "%release_dir%"

echo Generating changelog for: %range%
git-cliff "%range%" --output "%release_dir%\README.md"

cargo run --quiet >nul 2>&1
if errorlevel 1 (echo Warning: cargo run failed, continuing...)

set help_output=
for /f "delims=" %%i in ('.\target\debug\thrustc.exe --help 2^>^&1') do (
    set help_output=!help_output!%%i
)

if not "!help_output!"=="" (
    echo.>> "%release_dir%\README.md"
    echo ## Command Line>> "%release_dir%\README.md"
    echo ```console>> "%release_dir%\README.md"
    .\target\debug\thrustc.exe --help >> "%release_dir%\README.md" 2>&1
    echo ```>> "%release_dir%\README.md"
)

set "version="
for /f "delims=" %%v in ('powershell -NoProfile -Command "$m = [regex]::Match('%tag_name%', '\d+\.\d+\.\d+'); if ($m.Success) { $m.Value }"') do set "version=%%v"

if "%version%"=="" (
    echo Error: Could not extract a version number ^(x.y.z^) from tag '%tag_name%'.
    exit /b 1
)

powershell -NoProfile -Command "$version = $env:version; $inPkg=$false; $c = Get-Content 'Cargo.toml' | ForEach-Object { if ($_ -match '^\[workspace\.package\]') {$inPkg=$true} elseif ($_ -match '^\[') {$inPkg=$false}; if ($inPkg -and $_ -match '^version\s*=') { 'version = \"' + $version + '\"' } else { $_ } }; Set-Content 'Cargo.toml' $c"

git add "%release_dir%\README.md" "Cargo.toml"
git commit -m "Bumping '%tag_name%'"

git tag "%tag_name%"
if errorlevel 1 (
    echo Error: Failed to create tag '%tag_name%'.
    exit /b 1
)
git push origin HEAD "%tag_name%"
if errorlevel 1 (
    echo Error: Failed to push to remote.
    exit /b 1
)

echo Changelog generated at %release_dir%\README.md
echo Done.
