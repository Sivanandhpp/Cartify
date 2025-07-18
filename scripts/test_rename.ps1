# Test Rename Functionality Script
# This script tests the rename process without making permanent changes

param(
    [string]$TestPackageName = "testapp",
    [string]$TestDisplayName = "Test App",
    [string]$CompanyDomain = "testdomain"
)

Write-Host "Testing Project Rename Functionality..." -ForegroundColor Green
Write-Host "This is a DRY RUN - no files will be changed" -ForegroundColor Yellow

# Test 1: Check if AppIdentity file exists
Write-Host "`nTesting AppIdentity file..." -ForegroundColor Cyan
$appIdentityPath = "lib\app\core\config\app_identity.dart"
if (Test-Path $appIdentityPath) {
    Write-Host "  AppIdentity file exists" -ForegroundColor Green
    $content = Get-Content $appIdentityPath -Raw
    if ($content -match "static const String packageName = '([^']*)'") {
        $currentPackage = $matches[1]
        Write-Host "  Current package name: $currentPackage" -ForegroundColor White
    }
    if ($content -match "static const String displayName = '([^']*)'") {
        $currentDisplay = $matches[1]
        Write-Host "  Current display name: $currentDisplay" -ForegroundColor White
    }
} else {
    Write-Host "  AppIdentity file missing" -ForegroundColor Red
    exit 1
}

# Test 2: Check pubspec.yaml
Write-Host "`nTesting pubspec.yaml..." -ForegroundColor Cyan
$pubspecPath = "pubspec.yaml"
if (Test-Path $pubspecPath) {
    $pubspecContent = Get-Content $pubspecPath
    $nameLine = $pubspecContent | Where-Object { $_ -match "^name:" }
    Write-Host "  Pubspec exists: $nameLine" -ForegroundColor Green
} else {
    Write-Host "  pubspec.yaml missing" -ForegroundColor Red
    exit 1
}

# Test 3: Count package imports
Write-Host "`nTesting package imports..." -ForegroundColor Cyan
$dartFiles = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse
$importCount = 0
foreach ($file in $dartFiles) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match "package:$currentPackage") {
        $importCount++
    }
}
Write-Host "  Found $importCount files with package imports" -ForegroundColor White

# Test 4: Simulate rename operations
Write-Host "`nSimulating rename operations..." -ForegroundColor Cyan
Write-Host "  Would change package name: $currentPackage -> $TestPackageName" -ForegroundColor Yellow
Write-Host "  Would change display name: $currentDisplay -> $TestDisplayName" -ForegroundColor Yellow
Write-Host "  Would update $importCount dart files" -ForegroundColor Yellow
Write-Host "  Would update pubspec.yaml" -ForegroundColor Yellow

# Test 5: Check platform files (guidance)
Write-Host "`nPlatform files that would need manual updates:" -ForegroundColor Cyan
$androidGradle = "android\app\build.gradle.kts"
$iosProject = "ios\Runner.xcodeproj\project.pbxproj"
$webManifest = "web\manifest.json"

if (Test-Path $androidGradle) { Write-Host "  Android: $androidGradle" -ForegroundColor White }
if (Test-Path $iosProject) { Write-Host "  iOS: $iosProject" -ForegroundColor White }
if (Test-Path $webManifest) { Write-Host "  Web: $webManifest" -ForegroundColor White }

Write-Host "`nRename functionality test completed!" -ForegroundColor Green
Write-Host "System is ready for project renaming" -ForegroundColor Cyan
Write-Host "`nTo perform actual rename, run:" -ForegroundColor Yellow
Write-Host ".\scripts\quick_rename.ps1 -NewPackageName 'myapp' -NewDisplayName 'My App'" -ForegroundColor White
