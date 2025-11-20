# Onboarding Screen Setup Guide

## Overview
The onboarding screen has been implemented with a beautiful UI matching your design specifications. The screen features:

- Warm cream background (#FFF7F2)
- Orange accent color (#FA7315)
- Poppins font family (via Google Fonts)
- Multiple pages with swipe navigation
- Page indicator dots
- Skip button in the top right
- Next/Start button at the bottom

## Files Modified/Created

### Created Files
- `lib/presentation/screens/onboarding/onboarding_screen.dart` - New onboarding screen with page navigation

### Modified Files
- `lib/core/constants/app_colors.dart` - Updated primary color to warm orange (#FA7315) and added onboarding-specific colors
- `lib/presentation/screens/splash/splash_screen.dart` - Updated to navigate to new onboarding screen
- `pubspec.yaml` - Added `google_fonts` package for Poppins font

## Adding Your Own Images

To add your own onboarding images, follow these steps:

### Step 1: Prepare Your Images
1. Create 3 high-quality images for each onboarding page
2. Recommended size: 388x786 pixels (or similar aspect ratio ~1:2)
3. Supported formats: PNG, JPG, WebP
4. Images should showcase:
   - Page 1: Welcome/meal planning concept
   - Page 2: Recipe discovery
   - Page 3: Nutrition tracking

### Step 2: Add Images to Assets
1. Place your images in the `assets/images/` folder with these names:
   ```
   assets/images/onboarding_1.png
   assets/images/onboarding_2.png
   assets/images/onboarding_3.png
   ```

2. If your images are already named differently, you can either:
   - Rename them to match the above names, OR
   - Update the image paths in `lib/presentation/screens/onboarding/onboarding_screen.dart` (lines 17-19)

### Step 3: Test the Images
Run the app:
```bash
flutter run
```

The onboarding screen will automatically load your images. If images are missing, it will show a placeholder with a food icon.

## Customizing the Onboarding Content

### Changing Text Content
Edit the `_pages` list in `lib/presentation/screens/onboarding/onboarding_screen.dart` (lines 16-28):

```dart
final List<OnboardingData> _pages = [
  OnboardingData(
    title: 'Your Custom Title',
    description: 'Your custom description here.',
    imagePath: 'assets/images/your_image.png',
  ),
  // Add more pages as needed
];
```

### Changing Colors
Edit `lib/core/constants/app_colors.dart`:

```dart
static const Color primary = Color(0xFFFA7315); // Button color
static const Color onboardingBackground = Color(0xFFFFF7F2); // Background
static const Color onboardingText = Color(0xFF030401); // Text color
```

### Changing Font
The app uses Poppins font via Google Fonts. To change:

1. Update the font in `lib/presentation/screens/onboarding/onboarding_screen.dart`
2. Replace `GoogleFonts.poppins()` with your preferred font (e.g., `GoogleFonts.roboto()`)

## Design Specifications

### Colors
- Background: #FFF7F2 (Warm cream)
- Primary Button: #FA7315 (Warm orange)
- Text: #030401 (Almost black)
- Page Indicator (active): #FA7315 (Orange)
- Page Indicator (inactive): #D1D5DB (Gray)

### Typography
- **Skip Button**: Poppins, 13px, Regular (400)
- **Title**: Poppins, 28px, SemiBold (600), line height 1.5
- **Description**: Poppins, 17px, Regular (400), line height 1.47
- **Next Button**: Poppins, 18px, SemiBold (600), line height 1.5

### Layout
- Safe area with system UI overlays
- 20px horizontal padding
- 16px vertical padding for top bar
- 32px spacing between elements
- Rounded corners: 24px for images, 80px for button

## Navigation Flow

```
SplashScreen (2 seconds)
    ↓
First time user? → OnboardingScreen (3 pages)
                      ↓
                   LoginScreen
    ↓
Returning user not logged in → LoginScreen
    ↓
Logged in user → MainNavigation (Home)
```

## Testing Checklist

- [ ] Images load correctly on all pages
- [ ] Swipe left/right navigation works
- [ ] Skip button navigates to login
- [ ] Next button advances to next page
- [ ] Start button (on last page) navigates to login
- [ ] Page indicator dots update correctly
- [ ] Onboarding only shows once (check local storage)
- [ ] Fonts render correctly (Poppins)
- [ ] Colors match design specifications

## Troubleshooting

### Images Not Showing
1. Verify image files exist in `assets/images/`
2. Check image names match exactly (case-sensitive)
3. Run `flutter clean` and `flutter pub get`
4. Rebuild the app

### Fonts Not Loading
1. Ensure `google_fonts` package is installed: `flutter pub get`
2. Check internet connection (fonts are downloaded on first use)
3. Clear app cache and rebuild

### Navigation Issues
1. Check local storage is working: `LocalStorageService.instance.isOnboardingCompleted`
2. Reset onboarding: Delete app and reinstall OR clear app data
3. Debug navigation by adding print statements in `splash_screen.dart`

## Future Enhancements

Consider adding:
- [ ] Animated page transitions
- [ ] Lottie animations instead of static images
- [ ] Video backgrounds
- [ ] Interactive elements (buttons, gestures)
- [ ] Multiple language support
- [ ] Analytics tracking for onboarding completion rate

## Resources

- [Google Fonts Package](https://pub.dev/packages/google_fonts)
- [Flutter PageView Documentation](https://api.flutter.dev/flutter/widgets/PageView-class.html)
- [Material Design Onboarding](https://material.io/design/communication/onboarding.html)
