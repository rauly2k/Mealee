# Mealee App Finalization Plan

## Overview
This document outlines the complete finalization plan for the Mealee app, focusing on the onboarding and authentication flow to match the designed UI specifications.

**Project Goal:** Finalize the onboarding and authentication user experience with a polished, modern design matching the example UI files.

---

## 1. Onboarding Flow ✅ (In Progress)

### Current Status
- Onboarding screen exists with 3 pages
- Uses PageController with swipe navigation
- Has skip button and Next/Start functionality

### Required Changes

#### 1.1 Update Onboarding Content
**File:** `lib/presentation/screens/onboarding/onboarding_screen.dart` (lines 18-34)

**Current Slides:**
- Page 1: "Welcome to MealMind"
- Page 2: "Discover Recipes"
- Page 3: "Track Your Nutrition"

**New Slides:**
```dart
final List<OnboardingData> _pages = [
  OnboardingData(
    title: 'Welcome to Mealee',
    description: 'Personalized meal plans tailored to your taste & health goals.',
    imagePath: 'assets/images/onboarding_1.png',
  ),
  OnboardingData(
    title: 'AI-Powered Meal Plans',
    description: 'We\'ll create meal plans and grocery lists based on your choices!',
    imagePath: 'assets/images/onboarding_2.png',
  ),
  OnboardingData(
    title: 'Meals That Match You',
    description: 'Get meal suggestions based on your diet and goals.',
    imagePath: 'assets/images/onboarding_3.png',
  ),
];
```

#### 1.2 Update Navigation Flow
**File:** `lib/presentation/screens/onboarding/onboarding_screen.dart` (lines 59-66)

**Change:** Instead of navigating to `LoginScreen`, navigate to new `AuthChoiceScreen`:
```dart
void _completeOnboarding() async {
  await LocalStorageService.instance.setOnboardingCompleted(true);
  if (mounted) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthChoiceScreen()),
    );
  }
}
```

---

## 2. Auth Choice Screen 🆕 (New Implementation)

### Purpose
After onboarding, users should land on a beautiful screen where they choose to either create an account or log in.

### Design Specifications
Based on `docs/example_UI/login_or_register_example.md`:

**Layout:**
- Full-screen background image with gradient overlay
- Centered text: "Personalized meal plans tailored to your taste & health goals."
- Two prominent buttons at the bottom:
  - **Create Account** (filled orange button - #FA7315)
  - **Log In** (outlined orange button)

**Colors:**
- Background: Background image with white gradient overlay
- Primary Button: #FA7315 (Solid fill)
- Secondary Button: Transparent with #FA7315 border
- Text: #101211 for description, white for primary button, #FA7315 for secondary button

**Typography:**
- Description: Poppins, 17px, Regular (400), line height 1.47
- Buttons: Poppins, 18px, SemiBold (600), line height 1.50

**Button Specs:**
- Width: 388px (full width with 20px margins)
- Height: 50px
- Border Radius: 80px (fully rounded)
- Spacing between buttons: 16px

### Implementation File
**New File:** `lib/presentation/screens/auth/auth_choice_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image with gradient overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/auth_background.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to solid color if image missing
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFFA7315).withOpacity(0.1),
                        Colors.white,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Gradient overlay
          Positioned(
            left: 0,
            top: 465,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 461,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(0.50, -0.19),
                  end: const Alignment(0.50, 1.00),
                  colors: [
                    Colors.white,
                    const Color(0x45E8DFDF),
                    Colors.white.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // Description text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Personalized meal plans tailored to your taste & health goals.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF101211),
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      height: 1.47,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons container
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Create Account Button (Primary)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFA7315),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                          ),
                          child: Text(
                            'Create Account',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Log In Button (Secondary/Outlined)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFFA7315),
                            side: const BorderSide(
                              width: 1.50,
                              color: Color(0xFFFA7315),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                          ),
                          child: Text(
                            'Log In',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 64),
              ],
            ),
          ),

          // Status bar at top
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 47,
              // Status bar icons will be rendered by system
            ),
          ),

          // Bottom home indicator
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 34,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 14),
              child: Container(
                width: 134,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFF030401),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Assets Required
- **Image:** `assets/images/auth_background.png` - A beautiful food/meal planning background image
  - Recommended size: 428x926 pixels (iPhone size)
  - Should be appetizing and on-brand

---

## 3. Login Screen 🔄 (Full Redesign)

### Current Status
- Basic Material Design login screen
- Standard text fields with labels
- Simple button styling

### Design Specifications
Based on `docs/example_UI/login_example.md`:

**Layout Structure:**
1. **Header Section** (top)
   - Title: "Log In" - Poppins, 28px, SemiBold (600)
   - Subtitle: "Log in to access your personalized meal plans." - DM Sans, 17px, Regular (400)

2. **Input Fields** (middle)
   - Email field with placeholder text
   - Password field with placeholder text and show/hide toggle
   - "Forgot your password?" link aligned right

3. **Social Login Section**
   - "Or Continue With" divider with lines
   - Two social login buttons (Google and Apple icons)

4. **Primary Action** (bottom)
   - Large orange "Log In" button

5. **Footer Link**
   - "New here? Create an account!" text with navigation

**Colors:**
- Background: #FFFFFF (White)
- Input Background: #F8F8F8 (Light gray)
- Input Border: #D6D6D6 (Gray border)
- Text (Primary): #030401 (Almost black)
- Text (Placeholder): #696969 (Gray)
- Primary Button: #FA7315 (Orange)
- Divider: #D6D6D6 (Gray)

**Typography:**
- Title: Poppins, 28px, SemiBold (600), line height 1.50
- Subtitle: DM Sans, 17px, Regular (400), line height 1.41
- Input Text: Poppins, 17px, Regular (400), line height 1.47
- Button: Poppins, 18px, SemiBold (600), line height 1.50
- Footer: Poppins, 17px (400 for "New here?", 500 for "Create an account!")
- Divider Text: Poppins, 13px, Regular (400), line height 1.46

**Input Field Specs:**
- Width: 388px (full width with margins)
- Height: 50px
- Background: #F8F8F8
- Border: 1px solid #D6D6D6
- Border Radius: 25px
- Padding: 16px horizontal

**Button Specs:**
- Primary Button: 388px × 50px, Border Radius 80px, Background #FA7315
- Social Buttons: 184px × 54px, Border Radius 14px, Background #F8F8F8, Border #D6D6D6

**Spacing:**
- Top section: 67px from top
- Spacing between title and subtitle: 16px
- Spacing after subtitle: 16px
- Spacing between input fields: 10px
- Forgot password: 12px after password field
- Social section: Dynamic based on content
- Bottom button: 515px from top (or responsive)
- Footer text: 847px from top (bottom area)

### Implementation
**File to Update:** `lib/presentation/screens/auth/login_screen.dart`

Key changes:
- Remove Material AppBar
- Implement custom layout matching design specs
- Add custom rounded text fields with proper styling
- Add social login button placeholders (Google & Apple)
- Add "Or Continue With" divider section
- Style the main login button to match orange theme
- Add "Forgot password?" functionality
- Update footer navigation link styling

---

## 4. Register Screen 🔄 (Full Redesign)

### Design Specifications
Should match Login Screen design but with these differences:

**Layout Structure:**
1. **Header Section**
   - Title: "Create Account" - Poppins, 28px, SemiBold (600)
   - Subtitle: "Sign up to start your personalized meal journey." - DM Sans, 17px, Regular (400)

2. **Input Fields**
   - Name field (with person icon placeholder)
   - Email field (with email icon placeholder)
   - Password field (with show/hide toggle)
   - Confirm Password field (with show/hide toggle)

3. **Social Sign-Up Section**
   - "Or Continue With" divider
   - Google and Apple sign-up buttons

4. **Primary Action**
   - Large orange "Create Account" button

5. **Footer Link**
   - "Already have an account? Log in!" text with navigation

**All other design specs same as Login Screen**

### Implementation
**File to Update:** `lib/presentation/screens/auth/register_screen.dart`

Key changes:
- Same redesign approach as Login Screen
- Add Name field at the top
- Add Confirm Password field
- Update button text to "Create Account"
- Update footer to link back to login
- Match all styling specs from login screen

---

## 5. Shared Components 🆕 (New Implementations)

To avoid code duplication and maintain consistency, create reusable components:

### 5.1 Custom Input Field
**New File:** `lib/presentation/widgets/auth/custom_auth_text_field.dart`

Features:
- Rounded corners (25px border radius)
- Light gray background (#F8F8F8)
- Gray border (#D6D6D6)
- Proper padding and sizing
- Support for prefix icons (optional)
- Support for suffix icons (show/hide password toggle)
- Poppins font styling
- Placeholder text styling

### 5.2 Custom Auth Button
**New File:** `lib/presentation/widgets/auth/custom_auth_button.dart`

Features:
- Two variants: Primary (filled orange) and Secondary (outlined orange)
- Fully rounded corners (80px border radius)
- Proper sizing (388px × 50px with margins)
- Loading state support
- Poppins font styling
- Disabled state handling

### 5.3 Social Login Buttons
**New File:** `lib/presentation/widgets/auth/social_login_buttons.dart`

Features:
- Two buttons side by side (Google & Apple)
- Light gray background with border
- Proper icon integration
- Rounded corners (14px border radius)
- Size: 184px × 54px each
- Spacing: 20px between buttons

### 5.4 Or Divider
**New File:** `lib/presentation/widgets/auth/or_divider.dart`

Features:
- "Or Continue With" text centered
- Gray lines on both sides
- Proper spacing (16px around text)
- Poppins font, 13px, Regular

---

## 6. Assets & Resources 📦

### Images Required

1. **Onboarding Images** (3 images)
   - `assets/images/onboarding_1.png` - Welcome/meal planning visual
   - `assets/images/onboarding_2.png` - AI-powered meal plans visual
   - `assets/images/onboarding_3.png` - Personalized meals visual
   - Recommended size: 388px × 786px (or similar 1:2 ratio)
   - Format: PNG with transparency support

2. **Auth Background**
   - `assets/images/auth_background.png` - Beautiful food/meal background
   - Recommended size: 428px × 926px (full screen)
   - Should have good contrast for overlaid text
   - Format: PNG or JPG

### Icons Required

3. **Social Login Icons**
   - Google icon (SVG or PNG)
   - Apple icon (SVG or PNG)
   - Size: 20px × 20px
   - Can use Icon packages: `font_awesome_flutter` or custom assets

### Fonts
Already included via `google_fonts` package:
- **Poppins** - Primary font for buttons, titles, body text
- **DM Sans** - Secondary font for subtitles (need to add if not already included)

### Colors Palette
Update `lib/core/constants/app_colors.dart`:

```dart
class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFFFA7315); // Warm Orange
  static const Color primaryDark = Color(0xFFE65A00); // Darker orange for hover/pressed

  // Background Colors
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color onboardingBackground = Color(0xFFFFF7F2); // Warm cream
  static const Color inputBackground = Color(0xFFF8F8F8); // Light gray

  // Text Colors
  static const Color textPrimary = Color(0xFF030401); // Almost black
  static const Color textSecondary = Color(0xFF696969); // Gray
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White text on orange
  static const Color textDescription = Color(0xFF101211); // Description text

  // Border & Divider Colors
  static const Color border = Color(0xFFD6D6D6); // Gray border
  static const Color divider = Color(0xFFD6D6D6); // Divider lines

  // Status Colors (keep existing error, success, etc.)
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);

  // Page Indicator
  static const Color indicatorActive = Color(0xFFFA7315); // Orange
  static const Color indicatorInactive = Color(0xFFD1D5DB); // Gray
}
```

---

## 7. pubspec.yaml Dependencies ⚙️

Ensure these packages are added:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Existing dependencies...
  provider: ^6.0.0

  # UI & Styling
  google_fonts: ^6.1.0  # For Poppins and DM Sans fonts

  # Optional: Icons for social login
  font_awesome_flutter: ^10.6.0  # For Google/Apple icons (optional)

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/images/onboarding_1.png
    - assets/images/onboarding_2.png
    - assets/images/onboarding_3.png
    - assets/images/auth_background.png
```

---

## 8. Implementation Checklist ✅

### Phase 1: Setup & Assets
- [ ] Create all required image assets (onboarding 1-3, auth background)
- [ ] Update `pubspec.yaml` with all assets
- [ ] Update `app_colors.dart` with new color palette
- [ ] Run `flutter pub get` to ensure dependencies are installed
- [ ] Add DM Sans font support via Google Fonts

### Phase 2: Onboarding Updates
- [ ] Update onboarding screen content (titles & descriptions)
- [ ] Change "MealMind" to "Mealee" throughout
- [ ] Update navigation to point to `AuthChoiceScreen` instead of `LoginScreen`
- [ ] Test onboarding flow end-to-end

### Phase 3: New Auth Choice Screen
- [ ] Create `lib/presentation/screens/auth/auth_choice_screen.dart`
- [ ] Implement background image with gradient overlay
- [ ] Add "Create Account" and "Log In" buttons
- [ ] Test navigation to both register and login screens
- [ ] Verify design matches example UI

### Phase 4: Shared Components
- [ ] Create `custom_auth_text_field.dart` widget
- [ ] Create `custom_auth_button.dart` widget
- [ ] Create `social_login_buttons.dart` widget
- [ ] Create `or_divider.dart` widget
- [ ] Test all components in isolation

### Phase 5: Login Screen Redesign
- [ ] Remove Material AppBar
- [ ] Implement custom header with title and subtitle
- [ ] Replace input fields with `CustomAuthTextField`
- [ ] Add "Forgot password?" link
- [ ] Add `OrDivider` and social login buttons
- [ ] Update primary button with `CustomAuthButton`
- [ ] Update footer navigation link styling
- [ ] Test all interactions (show/hide password, navigation, etc.)
- [ ] Verify design matches example UI pixel-perfect

### Phase 6: Register Screen Redesign
- [ ] Remove Material AppBar
- [ ] Implement custom header with title and subtitle
- [ ] Add Name field using `CustomAuthTextField`
- [ ] Replace all input fields with custom widgets
- [ ] Add Confirm Password field
- [ ] Add `OrDivider` and social login buttons
- [ ] Update primary button with `CustomAuthButton`
- [ ] Update footer navigation link styling
- [ ] Test all interactions and validations
- [ ] Verify design matches example UI

### Phase 7: Testing & Polish
- [ ] Test complete flow: Onboarding → Auth Choice → Register → Login
- [ ] Test all error states (invalid email, password mismatch, etc.)
- [ ] Test loading states during auth operations
- [ ] Verify all fonts render correctly (Poppins & DM Sans)
- [ ] Verify all colors match design specifications
- [ ] Test on different screen sizes (responsiveness)
- [ ] Test status bar styling on iOS and Android
- [ ] Test keyboard behavior (fields scroll into view, etc.)
- [ ] Add haptic feedback where appropriate
- [ ] Verify all navigation transitions are smooth

### Phase 8: Code Quality
- [ ] Remove any unused code or commented-out sections
- [ ] Ensure consistent code formatting (`flutter format .`)
- [ ] Add comments to complex UI sections
- [ ] Verify no linting errors (`flutter analyze`)
- [ ] Update documentation if needed

---

## 9. Navigation Flow Diagram 📊

```
App Launch
    ↓
SplashScreen (2 seconds)
    ↓
Has completed onboarding?
    ├─ No → OnboardingScreen (3 pages)
    │           ↓
    │       AuthChoiceScreen
    │           ↓
    │       ┌──────────┴──────────┐
    │       ↓                     ↓
    │   RegisterScreen      LoginScreen
    │       ↓                     ↓
    │       └──────────┬──────────┘
    │                  ↓
    │          Authentication Success
    │                  ↓
    └─ Yes → Is logged in?
                ├─ Yes → MainNavigation (Home)
                └─ No → AuthChoiceScreen
```

---

## 10. Design System Reference 🎨

### Color Palette
| Color Name | Hex Code | Usage |
|------------|----------|-------|
| Primary Orange | `#FA7315` | Buttons, active states, branding |
| Warm Cream | `#FFF7F2` | Onboarding background |
| White | `#FFFFFF` | Auth screens background |
| Input Background | `#F8F8F8` | Text field backgrounds |
| Border Gray | `#D6D6D6` | Input borders, dividers |
| Text Primary | `#030401` | Headings, body text |
| Text Secondary | `#696969` | Placeholders, hints |
| Text Description | `#101211` | Description text on auth choice |

### Typography Scale
| Style | Font | Size | Weight | Line Height |
|-------|------|------|--------|-------------|
| Display Large | Poppins | 28px | SemiBold (600) | 1.50 |
| Body Large | Poppins | 18px | SemiBold (600) | 1.50 |
| Body Medium | Poppins | 17px | Regular (400) | 1.47 |
| Body Small | DM Sans | 17px | Regular (400) | 1.41 |
| Caption | Poppins | 13px | Regular (400) | 1.46 |

### Spacing System
- **Base Unit:** 4px
- **Common Spacings:** 8px, 16px, 20px, 24px, 32px, 64px
- **Margins:** 20px horizontal for main content
- **Button Height:** 50px or 54px for social buttons

### Border Radius
- **Fully Rounded Buttons:** 80px
- **Input Fields:** 25px
- **Social Buttons:** 14px
- **Cards/Images:** 24px

---

## 11. Future Considerations 🔮

After completing the auth flow, consider these enhancements:

### Immediate Next Steps
- [ ] Implement "Forgot Password" functionality
- [ ] Add actual Google Sign-In integration
- [ ] Add actual Apple Sign-In integration
- [ ] Add email verification flow
- [ ] Add form validation error messages in UI

### Medium-Term Enhancements
- [ ] Add user preferences/onboarding after registration (diet type, allergies, goals)
- [ ] Implement biometric authentication (Face ID / Touch ID)
- [ ] Add "Remember Me" functionality
- [ ] Implement proper loading animations (skeleton screens)
- [ ] Add Lottie animations to onboarding for polish

### Long-Term Features
- [ ] A/B test different onboarding content
- [ ] Analytics tracking for onboarding completion rate
- [ ] Multi-language support for auth screens
- [ ] Social media preview/screenshots for App Store

---

## 12. Success Criteria ✨

The implementation will be considered complete when:

1. ✅ **Visual Fidelity:** All screens match the example UI designs pixel-perfect
2. ✅ **Flow Completeness:** User can navigate from onboarding through auth successfully
3. ✅ **Code Quality:** No linting errors, consistent formatting, reusable components
4. ✅ **Functionality:** All buttons, inputs, and navigation work correctly
5. ✅ **Error Handling:** All error states display appropriate messages
6. ✅ **Responsiveness:** UI adapts properly to different screen sizes
7. ✅ **Performance:** No janky animations, smooth transitions
8. ✅ **Testing:** All manual test scenarios pass
9. ✅ **Brand Consistency:** "Mealee" branding consistent throughout
10. ✅ **Polish:** Status bars, safe areas, keyboard handling all work correctly

---

## 13. Development Timeline Estimate ⏱️

Based on complexity and assuming focused work:

| Phase | Estimated Time | Priority |
|-------|---------------|----------|
| Phase 1: Setup & Assets | 1-2 hours | 🔴 Critical |
| Phase 2: Onboarding Updates | 30 minutes | 🔴 Critical |
| Phase 3: Auth Choice Screen | 2-3 hours | 🔴 Critical |
| Phase 4: Shared Components | 3-4 hours | 🟡 High |
| Phase 5: Login Screen Redesign | 4-5 hours | 🔴 Critical |
| Phase 6: Register Screen Redesign | 4-5 hours | 🔴 Critical |
| Phase 7: Testing & Polish | 2-3 hours | 🟡 High |
| Phase 8: Code Quality | 1 hour | 🟢 Medium |
| **Total** | **18-24 hours** | |

**Note:** Timeline assumes you have design assets ready. Add extra time if creating images/graphics.

---

## 14. Getting Started 🚀

### Immediate First Steps

1. **Review this document** thoroughly to understand the full scope
2. **Gather/create all image assets** listed in Section 6
3. **Set up a git branch** for this work: `git checkout -b feature/auth-flow-redesign`
4. **Start with Phase 1** (Setup & Assets) to get everything in place
5. **Follow the checklist** in Section 8 sequentially
6. **Test frequently** as you complete each phase
7. **Commit regularly** with meaningful commit messages

### Recommended Development Order

1. Assets & Colors → 2. Shared Components → 3. Auth Choice Screen → 4. Login Redesign → 5. Register Redesign → 6. Onboarding Updates → 7. Testing

This order ensures you build from the ground up with reusable components first.

---

## 15. Questions & Clarifications ❓

Before starting implementation, confirm:

- [ ] Do you have all the required image assets or need help creating them?
- [ ] Should social login (Google/Apple) be functional or just UI placeholders for now?
- [ ] Do you want the "Forgot Password" link to be functional or navigate to a placeholder screen?
- [ ] Any specific animations or transitions you want between screens?
- [ ] Do you need the keyboard to have a "Next" button to jump between fields?

---

## Contact & Support 📞

If you encounter issues during implementation:
- Refer to the example UI files in `docs/example_UI/`
- Check this document's design specifications in sections 2-4
- Review the color palette in section 10
- Consult Flutter documentation for specific widget questions

---

**Document Version:** 1.0
**Last Updated:** 2025-11-19
**Status:** Ready for Implementation ✅

---

## Appendix A: File Structure

```
lib/
├── presentation/
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── auth_choice_screen.dart (NEW)
│   │   │   ├── login_screen.dart (UPDATE)
│   │   │   └── register_screen.dart (UPDATE)
│   │   └── onboarding/
│   │       └── onboarding_screen.dart (UPDATE)
│   └── widgets/
│       └── auth/ (NEW FOLDER)
│           ├── custom_auth_text_field.dart
│           ├── custom_auth_button.dart
│           ├── social_login_buttons.dart
│           └── or_divider.dart
├── core/
│   └── constants/
│       └── app_colors.dart (UPDATE)
└── data/
    └── services/
        └── local_storage_service.dart (EXISTING)

assets/
└── images/
    ├── onboarding_1.png (NEW)
    ├── onboarding_2.png (NEW)
    ├── onboarding_3.png (NEW)
    └── auth_background.png (NEW)
```
