# 🍽️ Mealee - AI-Powered Romanian Meal Planning App

<p align="center">
  <img src="assets/images/logo.png" alt="Mealee Logo" width="200"/>
</p>

<p align="center">
  <strong>Planifică-ți mesele, urmărește nutriția și gestionează-ți cămara cu ajutorul inteligenței artificiale</strong>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#getting-started">Getting Started</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#development">Development</a>
</p>

---

## 📱 About

Mealee este o aplicație mobilă cross-platform pentru planificarea meselor, urmărirea nutriției și gestionarea alimentelor din cămară. Aplicația folosește Google Gemini AI pentru analiză nutrițională avansată și generare de planuri de mese personalizate.

### ✨ Features

#### 🔐 Authentication & Onboarding
- Email/Password authentication
- Google Sign-In integration
- Complete onboarding flow with profile setup
- Goal-based calorie and macro calculation
- Dietary preferences and restrictions

#### 🏠 Dashboard & Nutrition Tracking
- Daily nutrition summary with progress bars
- Real-time calorie and macro tracking
- Meal logging (manual and recipe-based)
- Daily food log with meal type grouping
- Nutrition goals with BMR/TDEE calculations

#### 🍳 Recipe Management
- Browse recipes with beautiful cards
- Detailed recipe view with ingredients and instructions
- Portion adjustment with real-time nutrition recalculation
- Log recipes as meals with meal type selection
- Favorite recipes
- Search and filter functionality

#### 📅 Meal Planning
- Weekly meal plan viewing
- Day-by-day meal breakdown
- Meal cards grouped by type
- Total calories and meal count statistics
- AI-powered meal plan generation (coming soon)

#### 🏺 Pantry Management
- Complete inventory management
- Expiry date tracking with warnings
- Color-coded status indicators (expired/expiring/fresh)
- Filter by status (all, expired, expiring, fresh)
- Search functionality
- Category organization with icons

#### 🛒 Shopping Lists
- Active shopping list with progress tracking
- Item checkbox for completion tracking
- Category-based organization
- Quick add suggestions for common items
- Shopping list history
- Automatic list creation

#### 📊 Progress & Analytics
- Weight and BMI tracking
- Nutrition trends with period filtering
- Achievement tracking (streaks, goals, meals logged)
- Goal completion rate indicators
- Progress visualization with charts

#### ⚙️ Settings & Profile
- Edit profile (age, gender, height, weight, activity level)
- Automatic goal recalculation on profile changes
- App preferences (notifications, dark mode)
- Account management
- Privacy settings

#### 🤖 AI Integration
- Food image analysis with Gemini Vision
- Meal plan generation based on goals
- Recipe suggestions from pantry ingredients
- Nutritional analysis from text descriptions
- Personalized meal suggestions
- AI chat assistant for nutrition questions

---

## 🏗️ Architecture

Mealee follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                   # Core utilities and constants
│   ├── config/            # App configuration
│   ├── constants/         # Colors, strings, routes, constants
│   ├── error/             # Error handling and boundaries
│   ├── theme/             # Material Design theme
│   └── utils/             # Helpers, validators, extensions
├── data/                   # Data layer
│   ├── models/            # Data models (6 models)
│   ├── repositories/      # Repository implementations (7 repos)
│   └── services/          # External services (Firebase, Gemini, Analytics)
└── presentation/          # Presentation layer
    ├── providers/         # State management (7 providers)
    ├── screens/           # UI screens (24 screens)
    └── widgets/           # Reusable widgets
```

### Design Patterns

- **Provider Pattern**: State management with ChangeNotifier
- **Repository Pattern**: Data access abstraction
- **Service Pattern**: External API and service integration
- **Clean Architecture**: Separation of business logic from UI

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode for mobile development
- Firebase project setup
- Google Gemini API key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/mealee.git
   cd mealee
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password and Google)
   - Enable Cloud Firestore
   - Enable Firebase Storage
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place config files in appropriate directories

4. **Environment Configuration**

   Create a `.env` file in the project root:
   ```env
   GEMINI_API_KEY=your_gemini_api_key_here
   FIREBASE_PROJECT_ID=your_firebase_project_id
   ENV=development
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 🎨 Design System

### Romanian-Inspired Color Palette

- **Primary**: Romanian Red (#E63946)
- **Secondary**: Golden Yellow (#F4A261)
- **Accent**: Fresh Green (#2A9D8F)
- **Nutrition Colors**:
  - Purple: Calories
  - Red: Protein
  - Yellow: Carbohydrates
  - Green: Fats

### Typography

- Material Design 3 type scale
- Romanian language support with diacritics
- Clear hierarchy for readability

### Components

- Rounded corners (8-16px)
- Elevated cards with shadows
- Bottom navigation for main tabs
- Progress bars for nutrition tracking
- Chips for filters and categories
- Floating Action Button for quick actions

---

## 💻 Development

### State Management

The app uses **Provider** for state management with 7 specialized providers:

1. **AuthProvider** - Authentication state
2. **UserProvider** - User profile and goals
3. **RecipeProvider** - Recipe browsing and favorites
4. **FoodLogProvider** - Daily nutrition tracking
5. **MealPlanProvider** - Meal plan management
6. **PantryProvider** - Pantry inventory
7. **ShoppingListProvider** - Shopping lists

### Data Models

6 comprehensive data models with Firestore serialization:

- `UserModel` - User data with profile, goals, and preferences
- `RecipeModel` - Recipe with ingredients, instructions, and nutrition
- `FoodLogModel` - Food log entries with nutrition tracking
- `MealPlanModel` - Weekly meal plans with daily breakdown
- `PantryItemModel` - Pantry items with expiry tracking
- `ShoppingListModel` - Shopping lists with items and completion

### Services

3 core services for external integrations:

- **FirebaseService** - Firebase initialization and configuration
- **GeminiService** - AI integration (vision, chat, analysis)
- **AnalyticsService** - Event tracking and user analytics
- **ConnectivityService** - Network status monitoring

### Code Quality

- ✅ Null safety enabled
- ✅ Type-safe code throughout
- ✅ Comprehensive error handling
- ✅ Input validation and sanitization
- ✅ Security checks (SQL injection, XSS prevention)
- ✅ Clean code principles
- ✅ Consistent naming conventions
- ✅ Well-documented code

---

## 📊 Project Stats

| Metric | Count |
|--------|-------|
| Total Files | 71+ |
| Lines of Code | ~15,300+ |
| Screens | 24 |
| Widgets | 10+ |
| Data Models | 6 |
| Repositories | 7 |
| Providers | 7 |
| Services | 3 |
| Language | 100% Romanian |

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test
```

---

## 📱 Screenshots

<!-- Add screenshots here -->

---

## 🗺️ Roadmap

### Phase 1: MVP ✅ COMPLETE
- Authentication and onboarding
- Basic navigation
- Recipe browsing
- Profile management

### Phase 2: Advanced Features ✅ COMPLETE
- Recipe detail with portion control
- Food logging system
- Meal planning
- Progress tracking
- Settings management
- Google Gemini AI integration

### Phase 3: Pantry & Shopping ✅ COMPLETE
- Pantry inventory management
- Expiry tracking
- Shopping list system
- Category organization

### Phase 4: Polish & Scale ✅ COMPLETE
- Error handling improvements
- Offline mode detection
- Configuration management
- Code quality enhancements
- Analytics structure
- Documentation

### Phase 5: Premium Features (Planned)
- AI meal plan generation UI
- Photo-based food logging UI
- Social features
- Recipe sharing
- Meal prep planning
- Grocery delivery integration

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

- **Your Name** - Initial work

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - UI framework
- [Firebase](https://firebase.google.com/) - Backend services
- [Google Gemini](https://ai.google.dev/) - AI capabilities
- [Provider](https://pub.dev/packages/provider) - State management
- Material Design 3 - Design system

---

## 📞 Support

For support, email support@mealee.app or open an issue on GitHub.

---

## 🌟 Show Your Support

Give a ⭐️ if you like this project!

---

<p align="center">Made with ❤️ and 🇷🇴 Romanian pride</p>
