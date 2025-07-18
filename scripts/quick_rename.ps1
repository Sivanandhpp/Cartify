# Quick Project Rename Script
# Usage: .\scripts\quick_rename.ps1 -NewPackageName "myapp" -NewDisplayName "My App"

param(
    [Parameter(Mandatory=$true)]
    [string]$NewPackageName,
    
    [Parameter(Mandatory=$true)]
    [string]$NewDisplayName,
    
    [string]$CompanyDomain = "example"
)

Write-Host "Starting Quick Rename Process..." -ForegroundColor Green
Write-Host "Package Name: $NewPackageName" -ForegroundColor Cyan
Write-Host "Display Name: $NewDisplayName" -ForegroundColor Cyan
Write-Host "Company Domain: $CompanyDomain" -ForegroundColor Cyan

# Step 0: Get current package name from pubspec.yaml
Write-Host "`nDetecting current package name..." -ForegroundColor Yellow
$pubspecPath = "pubspec.yaml"
$pubspecContent = Get-Content $pubspecPath
$currentNameLine = $pubspecContent | Where-Object { $_ -match "^name:\s*(.+)" }
if ($currentNameLine -match "^name:\s*(.+)") {
    $currentPackageName = $matches[1].Trim()
    Write-Host "  Current package: $currentPackageName" -ForegroundColor White
} else {
    Write-Host "  Could not detect current package name!" -ForegroundColor Red
    exit 1
}

# Step 1: Update AppIdentity.dart
Write-Host "`nUpdating AppIdentity configuration..." -ForegroundColor Yellow
$appIdentityPath = "lib\app\core\config\app_identity.dart"
if (Test-Path $appIdentityPath) {
    $content = Get-Content $appIdentityPath -Raw
    $content = $content -replace "static const String packageName = '[^']*';", "static const String packageName = '$NewPackageName';"
    $content = $content -replace "static const String displayName = '[^']*';", "static const String displayName = '$NewDisplayName';"
    $content = $content -replace "static const String companyDomain = '[^']*';", "static const String companyDomain = '$CompanyDomain';"
    Set-Content $appIdentityPath -Value $content
    Write-Host "  AppIdentity updated" -ForegroundColor Green
} else {
    Write-Host "  AppIdentity file not found - skipping" -ForegroundColor Yellow
}

# Step 2: Update pubspec.yaml
Write-Host "Updating pubspec.yaml..." -ForegroundColor Yellow
(Get-Content $pubspecPath) -replace "^name: .*", "name: $NewPackageName" | Set-Content $pubspecPath

# Step 3: Update all package imports
Write-Host "Updating package imports..." -ForegroundColor Yellow
$dartFiles = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse
$testFiles = Get-ChildItem -Path "test" -Filter "*.dart" -Recurse -ErrorAction SilentlyContinue
$allFiles = $dartFiles + $testFiles
$updateCount = 0
foreach ($file in $allFiles) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match "package:$currentPackageName") {
        $newContent = $content -replace "package:$currentPackageName", "package:$NewPackageName"
        Set-Content $file.FullName -Value $newContent
        Write-Host "  Updated: $($file.Name)" -ForegroundColor Gray
        $updateCount++
    }
}
Write-Host "  Total files updated: $updateCount" -ForegroundColor White

# Step 4: Platform files (guidance)
Write-Host "`nPlatform files need manual update:" -ForegroundColor Yellow
Write-Host "  Android: Update applicationId in android\app\build.gradle.kts" -ForegroundColor Gray
Write-Host "  iOS: Update bundle identifiers in ios\Runner.xcodeproj\project.pbxproj" -ForegroundColor Gray
Write-Host "  Web: Update names in web\manifest.json and web\index.html" -ForegroundColor Gray

Write-Host "`nQuick rename completed!" -ForegroundColor Green
Write-Host "Run 'flutter pub get' to refresh dependencies" -ForegroundColor Cyan
Write-Host "Run 'flutter analyze' to verify everything works" -ForegroundColor Cyan
