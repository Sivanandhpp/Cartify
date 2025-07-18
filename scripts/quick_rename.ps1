# Quick Project Rename Script
# Usage: .\scripts\quick_rename.ps1 -NewPackageName "myapp" -NewDisplayName "My App"

param(
    [Parameter(Mandatory=$true)]
    [string]$NewPackageName,
    
    [Parameter(Mandatory=$true)]
    [string]$NewDisplayName,
    
    [string]$CompanyDomain = "example"
)

Write-Host "🚀 Starting Quick Rename Process..." -ForegroundColor Green
Write-Host "📦 Package Name: $NewPackageName" -ForegroundColor Cyan
Write-Host "📱 Display Name: $NewDisplayName" -ForegroundColor Cyan
Write-Host "🏢 Company Domain: $CompanyDomain" -ForegroundColor Cyan

# Step 1: Update AppIdentity.dart
Write-Host "`n1️⃣ Updating AppIdentity configuration..." -ForegroundColor Yellow
$appIdentityPath = "lib\app\core\config\app_identity.dart"
$content = Get-Content $appIdentityPath -Raw
$content = $content -replace "static const String packageName = '[^']*';", "static const String packageName = '$NewPackageName';"
$content = $content -replace "static const String displayName = '[^']*';", "static const String displayName = '$NewDisplayName';"
$content = $content -replace "static const String companyDomain = '[^']*';", "static const String companyDomain = '$CompanyDomain';"
Set-Content $appIdentityPath -Value $content

# Step 2: Update pubspec.yaml
Write-Host "2️⃣ Updating pubspec.yaml..." -ForegroundColor Yellow
$pubspecPath = "pubspec.yaml"
(Get-Content $pubspecPath) -replace "^name: .*", "name: $NewPackageName" | Set-Content $pubspecPath

# Step 3: Update all package imports
Write-Host "3️⃣ Updating package imports..." -ForegroundColor Yellow
$dartFiles = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse
foreach ($file in $dartFiles) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match "package:cartify") {
        $newContent = $content -replace "package:cartify", "package:$NewPackageName"
        Set-Content $file.FullName -Value $newContent
        Write-Host "  📄 Updated: $($file.Name)" -ForegroundColor Gray
    }
}

# Step 4: Platform files (guidance)
Write-Host "`n4️⃣ Platform files need manual update:" -ForegroundColor Yellow
Write-Host "  📱 Android: Update applicationId in android\app\build.gradle.kts" -ForegroundColor Gray
Write-Host "  🍎 iOS: Update bundle identifiers in ios\Runner.xcodeproj\project.pbxproj" -ForegroundColor Gray
Write-Host "  🌐 Web: Update names in web\manifest.json and web\index.html" -ForegroundColor Gray

Write-Host "`n✅ Quick rename completed! 🎉" -ForegroundColor Green
Write-Host "⚡ Run 'flutter pub get' to refresh dependencies" -ForegroundColor Cyan
Write-Host "🔍 Run 'flutter analyze' to verify everything works" -ForegroundColor Cyan
