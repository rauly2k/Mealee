# Code Fixes Required

This document lists all linter errors, warnings, and info messages that need to be fixed.

## ✅ Fixed Issues

### Configuration & Constants
- ✅ Added `library;` declaration to `app_config.dart`
- ✅ Added `library;` declaration to `app_constants.dart`
- ✅ Replaced all `print()` with `debugPrint()` in `app_config.dart`
- ✅ Fixed unnecessary string interpolation in `error_handler.dart` line 74
- ✅ Fixed ErrorBoundary build method return type error
- ✅ Removed dead code after ErrorBoundary fix
- ✅ Fixed string concatenation in `sanitizers.dart` to use interpolation
- ✅ Fixed roundTo multiplier calculation in `sanitizers.dart`
- ✅ Fixed SQL injection regex pattern in `sanitizers.dart`
- ✅ Created missing asset directories (assets/images/, assets/icons/)

## ⚠️  Remaining Issues

### Deprecated API Usage
**Issue**: Multiple uses of deprecated `withOpacity()` method
**Files Affected**: 25+ files
**Fix**: Replace `.withOpacity(value)` with `.withValues(alpha: value)`
**Priority**: Medium (will work but shows warnings)

**Issue**: Deprecated `background` and `onBackground` in theme
**File**: `lib/core/theme/app_theme.dart:19,24`
**Fix**: Replace with `surface` and `onSurface`
**Priority**: Medium

### Type Mismatches
**Issue**: `CardTheme` can't be assigned to `CardThemeData?`
**File**: `lib/core/theme/app_theme.dart:236`
**Fix**: Use `CardThemeData` instead of `CardTheme`
**Priority**: High

**Issue**: `DialogTheme` can't be assigned to `DialogThemeData?`
**File**: `lib/core/theme/app_theme.dart:295`
**Fix**: Use `DialogThemeData` instead of `DialogTheme`
**Priority**: High

### Model Structure Issues

#### PantryItemModel
**Missing/Incorrect Properties**:
- Expected: `itemId`, `name`, `addedAt`
- Actual: `pantryItemId`, `ingredientName`, `addedDate`

**Fix**: Update all usages to match actual model structure or update model

**Files Affected**:
- `lib/presentation/screens/pantry/add_pantry_item_screen.dart:82-90`
- `lib/presentation/screens/pantry/pantry_screen.dart:464`
- `lib/presentation/providers/pantry_provider.dart:123,130,131`

#### ShoppingItem & ShoppingListModel
**Missing Properties**:
- ShoppingItem missing: `id`, `isCompleted`
- Actual properties: Unknown - needs model review

**Files Affected**:
- `lib/presentation/providers/shopping_list_provider.dart:109,114,125,141,154,174,192,207`
- `lib/presentation/screens/shopping_list/add_shopping_item_screen.dart:69-75`
- `lib/presentation/screens/shopping_list/shopping_list_screen.dart:74,394`

**Fix**: Review actual model structure and update all usages

#### MealPlanModel & DayMealPlan
**Missing Properties**:
- MealPlanModel missing: `name`, `startDate`, `endDate`
- DayMealPlan missing: `dayName`, `meals`, `notes`
- MealInfo missing: `mealType`, `time`, `imageUrl`, `servings`, `notes`

**Files Affected**:
- `lib/presentation/providers/meal_plan_provider.dart:138,139,152,168`
- `lib/presentation/screens/meal_plans/meal_plan_detail_screen.dart`: Multiple lines

**Fix**: Review actual model structure or update models to match usage

#### ManualEntry
**Missing/Incorrect Properties**:
- Expected: `portionSize` (property)
- Actual: Needs to be a direct property, not nested

**Files Affected**:
- `lib/presentation/screens/food_log/food_log_screen.dart:284`
- `lib/presentation/screens/food_log/manual_food_entry_screen.dart:75-81`

**Fix**: Update ManualEntry model to include all nutrition data as direct properties

### Repository Method Issues

#### PantryRepository
**Missing Methods**:
- `getPantryItemsByUserId()` - called but doesn't exist
- `createPantryItem()` - called but doesn't exist

**File**: `lib/presentation/providers/pantry_provider.dart:23,41`
**Fix**: Add these methods to PantryRepository or rename to match existing methods

#### ShoppingListRepository
**Missing Method**:
- `getShoppingListsByUserId()` - called but doesn't exist

**File**: `lib/presentation/providers/shopping_list_provider.dart:25`
**Fix**: Add this method or use existing method name

#### MealPlanRepository
**Missing Method**:
- `getMealPlansByUserId()` - called but doesn't exist

**File**: `lib/presentation/providers/meal_plan_provider.dart:25`
**Fix**: Add this method or use existing method name

### UserProvider Missing Methods

**Issue**: `updateDisplayName()` method doesn't exist
**File**: `lib/presentation/screens/profile/edit_profile_screen.dart:76`
**Fix**: Add method to UserProvider or use existing update method

### LocalStorageService Missing Methods

**Missing Methods**: `getBool()`, `setBool()`
**File**: `lib/presentation/screens/settings/settings_screen.dart:30,31,36,41`
**Fix**: Add these methods to LocalStorageService

### CustomTextField Parameter Issues

**Issue**: Named parameters `label` and `hint` are not defined
**Files Affected**: Multiple manual_food_entry_screen, edit_profile_screen, add_pantry_item_screen, add_shopping_item_screen

**Fix**: Review CustomTextField widget and add these parameters or use correct parameter names

### Unused Imports
**Files with unused imports**:
- `lib/data/repositories/pantry_repository.dart` - cloud_firestore
- `lib/data/repositories/shopping_list_repository.dart` - cloud_firestore
- `lib/data/services/gemini_service.dart` - recipe_model, meal_plan_model
- `lib/presentation/screens/food_log/manual_food_entry_screen.dart` - app_strings, validators
- `lib/presentation/screens/meal_plans/meal_plan_detail_screen.dart` - recipe_detail_screen
- `lib/presentation/screens/progress/progress_screen.dart` - intl
- `lib/presentation/screens/recipes/recipe_detail_screen.dart` - loading_indicator
- `lib/presentation/screens/shopping_list/shopping_list_screen.dart` - app_strings
- `lib/presentation/widgets/common/custom_text_field.dart` - app_colors

**Fix**: Remove unused imports

### Unnecessary Code
**Issues**:
- Unnecessary casts in `lib/core/utils/extensions.dart:148`
- Unnecessary null comparisons in multiple files
- Unnecessary non-null assertions
- Unnecessary `toList()` in spreads

**Fix**: Remove unnecessary code as indicated by linter

### AppColors Missing Property

**Issue**: `backgroundLight` getter doesn't exist
**Files Affected**: Multiple files use `AppColors.backgroundLight`

**Fix**: Add `backgroundLight` to AppColors class

### Test File Issue

**Issue**: `MyApp` class doesn't exist
**File**: `test/widget_test.dart:16`
**Fix**: Update test to use actual app class or create MyApp class for testing

## Priority Order

### High Priority (Breaking Errors)
1. Fix model structure mismatches (PantryItemModel, ShoppingItem, MealPlanModel, etc.)
2. Fix repository missing methods
3. Fix theme type mismatches (CardTheme, DialogTheme)
4. Add missing AppColors.backgroundLight
5. Fix CustomTextField parameter issues
6. Add missing LocalStorageService methods
7. Add missing UserProvider methods

### Medium Priority (Warnings)
1. Replace deprecated withOpacity() calls
2. Remove unused imports
3. Fix unnecessary code

### Low Priority (Info)
1. Code style improvements
2. Optimization suggestions

## Recommended Approach

1. **First**: Review all data models to understand actual structure
2. **Second**: Update all model usages to match actual structure OR update models
3. **Third**: Add missing repository methods
4. **Fourth**: Fix theme and UI component issues
5. **Fifth**: Clean up warnings and info messages

## Notes

- Many errors stem from inconsistencies between expected and actual model structures
- A comprehensive model review and documentation would prevent future issues
- Consider creating model documentation with all properties and their types
- Consider adding integration tests to catch these issues earlier
