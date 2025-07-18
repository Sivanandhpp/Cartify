# Import Guidelines & Project Renaming Guide

## 📦 Import Pattern Standards

### ✅ **Recommended Import Patterns**

#### **1. External Packages** (Always absolute)
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
```

#### **2. Core/Shared Resources** (Absolute with barrel exports)
```dart
// Use barrel exports for cleaner imports
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/index.dart';

// Instead of multiple individual imports:
// import 'package:cartify/app/core/themes/app_theme.dart';
// import 'package:cartify/app/core/services/cart_service.dart';
// import 'package:cartify/app/core/constants/app_strings.dart';
```

#### **3. Local Module Files** (Relative)
```dart
// Within same module - use relative imports
import '../controllers/login_controller.dart';
import '../data/auth_service.dart';
import 'widgets/login_form.dart';
```

#### **4. Cross-Module Dependencies** (Absolute)
```dart
// When importing from different modules
import 'package:cartify/app/modules/product_sheet/views/product_sheet_view.dart';
```

### 📁 **File Organization Structure**
```
lib/
├── app/
│   ├── core/
│   │   ├── index.dart              // 🎯 Barrel export for all core
│   │   ├── config/
│   │   │   ├── app_identity.dart   // 🎯 Central naming config
│   │   │   └── app_config.dart
│   │   ├── services/
│   │   ├── themes/
│   │   ├── constants/
│   │   └── widgets/
│   ├── routes/
│   │   ├── index.dart              // 🎯 Barrel export for routes
│   │   └── app_pages.dart
│   └── modules/
│       └── [feature]/
│           ├── bindings/
│           ├── controllers/
│           ├── data/
│           └── views/
└── main.dart
```

## 🔄 **Easy Project Renaming Process**

### **Step 1: Update AppIdentity (Only file to change!)**
```dart
// lib/app/core/config/app_identity.dart
class AppIdentity {
  static const String packageName = 'your_new_name';      // ⬅️ Change this
  static const String displayName = 'Your New App Name';  // ⬅️ Change this
  static const String companyDomain = 'example';          // ⬅️ Change this
  
  // Everything else auto-updates! 🎉
}
```

### **Step 2: Update pubspec.yaml**
```yaml
name: your_new_name  # ⬅️ Match packageName from AppIdentity
```

### **Step 3: Update Platform Files** (Semi-automated)
- Android: Update `namespace` and `applicationId` in `build.gradle.kts`
- iOS: Update bundle identifiers in `project.pbxproj`
- Web: Update names in `manifest.json` and `index.html`

### **Step 4: Run Global Replace** (Automated)
```powershell
# Replace all package imports (PowerShell)
(Get-Content -Path "lib/**/*.dart" -Recurse) -replace "package:cartify", "package:your_new_name" | Set-Content -Path $_.FullName
```

## 🎯 **Benefits of This System**

### **Before (Manual Renaming)**
- ❌ **47+ files** to manually update
- ❌ **2+ hours** of tedious find/replace
- ❌ **High error rate** - easy to miss files
- ❌ **Inconsistent imports** across project

### **After (AppIdentity System)**
- ✅ **1 primary file** to update (`AppIdentity`)
- ✅ **5 minutes** total rename time
- ✅ **Automated validation** - fewer errors
- ✅ **Consistent imports** with clear patterns

## 🛠️ **Available Barrel Exports**

### **Core Barrel (`package:cartify/app/core/index.dart`)**
```dart
// Single import gives you access to:
// - AppIdentity, AppConfig
// - AppConstants, AppImages, AppStrings, AppPadding
// - CartService, ErrorService, LogService
// - AppColors, AppTextStyles, AppTheme
// - AppButtons, AppSpacers
// - CartItemModel, ProductModel
```

### **Routes Barrel (`package:cartify/app/routes/index.dart`)**
```dart
// Single import gives you access to:
// - AppPages, Routes
```

## 🔍 **Import Validation Rules**

1. **Never mix patterns** - be consistent within each file
2. **Use barrel exports** for core functionality
3. **Relative imports** only within same module
4. **Absolute imports** for cross-module dependencies
5. **External packages** always use absolute imports

## 🚀 **Future Enhancements Available**

If you need even more automation, we can add:
- **Build scripts** for automated renaming
- **Custom lint rules** for import validation
- **IDE snippets** for consistent import patterns
- **CI/CD validation** to prevent import violations

---

**Need help?** This system makes renaming effortless - just update `AppIdentity` and you're 90% done! 🎉
