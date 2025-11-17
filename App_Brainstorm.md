  Romanian Recipe & Meal Planning App - Complete Design Specification

  App name - Mealee

  1. Project Overview

  Vision

  A mobile application for the Romanian market that combines curated recipes, AI-powered meal planning, ingredient-based recipe suggestions, and comprehensive food tracking. The app helps users       
  achieve their nutritional goals through intelligent meal planning and pantry management.

  Target Market

  - Primary: Romanian users (Romanian language only initially)
  - Future: English language expansion for international markets

  Platform

  - Mobile app: iOS and Android
  - Technology: Flutter (cross-platform development)
  - Backend: Firebase (authentication, database, storage, hosting)

  ---
  2. Core Features

  2.1 Recipe Database

  Content Strategy:
  - Traditional Romanian recipes: Authentic dishes (sarmale, mici, cozonac, mămăligă, etc.)
  - International adapted recipes: Global cuisine with Romanian ingredient alternatives
  - Healthy/dietary options: Categorized by diet types (keto, vegan, vegetarian, low-carb, gluten-free, etc.)

  Recipe Structure:
  - Title, description, and featured image
  - Preparation time, cooking time, total time
  - Serving size (adjustable portions)
  - Difficulty level (beginner, intermediate, advanced)
  - Ingredient list with quantities
  - Step-by-step instructions with optional images
  - Nutritional information per serving:
    - Calories
    - Protein, carbohydrates, fats (macros)
    - Health score/rating
  - Tags and categories (cuisine type, dietary preferences, meal type)
  - Admin-curated database (you control quality)

  Additional Recipe Features:
  - Recipe sharing functionality (share with friends or publicly)
  - Search and filter by:
    - Ingredients
    - Dietary restrictions
    - Cooking time
    - Difficulty
    - Meal type (breakfast, lunch, dinner, snack, dessert)

  ---
  2.2 AI-Powered Recipe Suggestions

  Technology: Google Gemini API (multimodal AI for text and vision)

  Feature A: Ingredient-Based Suggestions
  - Text input: Users type available ingredients
  - Photo input: Multi-photo compilation approach
    - Users take multiple photos of ingredients
    - AI identifies ingredients across all photos
    - Compiled list of detected ingredients
  - Output: AI suggests recipes that can be made with available ingredients
  - Users can manually edit detected ingredients

  Feature B: Goal-Based Meal Planning
  - User inputs:
    - Daily calorie target
    - Daily protein target
    - Dietary restrictions (allergies, intolerances, religious requirements)
    - Cooking time preferences (quick meals, no time limit, etc.)
  - AI generates:
    - Weekly meal plans (7 days)
    - Optimized to meet calorie and protein goals
    - Respects dietary restrictions
    - Considers cooking time filters
  - Interaction method: Quick preference cards (swipe/select interface for easy refinement)

  ---
  2.3 Pantry Inventory Management

  Features:
  - Manual entry: Users add/remove ingredients they have at home
  - Receipt scanning: Scan grocery receipts to auto-populate pantry
  - Integration with recipes:
    - See which recipes can be made with current pantry items
    - Identify missing ingredients for desired recipes

  User Flow:
  1. User scans grocery receipt OR manually adds ingredients
  2. App maintains current pantry inventory
  3. When browsing recipes, app shows:
    - Green check: All ingredients available
    - Partial match: Some ingredients available
    - Red X: Missing too many ingredients

  ---
  2.4 Shopping List

  Auto-Generation Features:
  - Auto-generate from meal plans: Select a weekly meal plan → automatic shopping list
  - Auto-generate from selected recipes: Add recipes to shopping cart → compiled list
  - Smart ingredient merging:
    - Combines same ingredients across multiple recipes
    - Shows total quantities needed (e.g., "500g chicken breast" from 3 recipes = "1.5kg chicken breast")
  - Pantry integration:
    - Compares shopping list with pantry inventory
    - Only shows items not already in pantry
    - Highlights what you already have

  Shopping List Management:
  - Check off items as you shop
  - Manual additions to list
  - Organize by categories (produce, dairy, meat, pantry staples)
  - Save lists for future use
  - Share lists with family members

  ---
  2.5 Food Tracking (Hybrid Approach)

  Tracking Methods:

  1. Recipe-based logging:
    - Log complete recipes cooked from the app
    - Automatically tracks nutrition for the entire recipe
    - Adjust portions consumed
  2. Individual ingredient logging:
    - Manual entry of individual foods
    - Database of common Romanian and international foods
    - Portion size selection (grams, pieces, cups, etc.)
  3. AI photo-based detection:
    - Take photo of meal
    - Google Gemini Vision analyzes photo
    - Estimates calories and macros
    - User can confirm or adjust detection

  Daily Tracking Dashboard:
  - Calories consumed vs. target
  - Macro breakdown (protein, carbs, fats) vs. targets
  - Meal breakdown (breakfast, lunch, dinner, snacks)
  - Progress bar visualization
  - Quick add button for frequent foods

  ---
  2.6 User Profiles & Goal Setting

  User Profile Information:
  - Personal details: Name, age, gender, height, weight
  - Activity level (sedentary, lightly active, moderately active, very active)
  - Goal selection:
    - Weight loss
    - Weight maintenance
    - Weight gain (muscle building)
    - General health

  Goal Tracking:
  - Calorie targets: Auto-calculated or manually set daily calorie goals
  - Macro tracking:
    - Protein, carbs, fats with customizable ratios
    - Default ratios based on goal type
    - Custom ratio builder
  - Progress analytics:
    - Weight tracking over time
    - Charts showing calorie/macro trends
    - Weekly/monthly summaries
    - Goal achievement insights
    - Streak tracking (consecutive days logged)

  ---
  2.7 Offline Functionality

  Offline Capabilities:
  - Cached recipes: Previously viewed recipes available offline
  - Downloaded meal plans: Save weekly meal plans for offline access
  - Offline food logging: Log meals offline, sync when internet available
  - Sync indicator: Clear UI showing what's synced vs. pending sync

  ---
  3. Technical Architecture

  3.1 Technology Stack

  Frontend:
  - Framework: Flutter (Dart)
  - UI Design: Material Design 3 with Romanian cultural color schemes
  - State Management: Provider or Riverpod (recommended for Flutter)
  - Local Storage: SQLite (for offline data)

  Backend:
  - BaaS: Firebase
    - Firestore: Recipe database, user data, meal plans
    - Firebase Authentication: User auth
    - Firebase Storage: Recipe images, user uploads
    - Cloud Functions: Server-side logic (AI API calls, batch processing)
    - Firebase Hosting: Admin dashboard (optional)

  AI Integration:
  - Google Gemini API:
    - Gemini Pro: Text-based recipe suggestions and meal planning
    - Gemini Vision: Image recognition for ingredients and food logging

  Third-party Integrations:
  - Receipt scanning: OCR library (Firebase ML Kit or Tesseract)
  - Barcode scanning: For packaged foods (ML Kit Barcode Scanning)

  ---
  3.2 Authentication

  Methods:
  - Email/password authentication
  - Social login:
    - Google Sign-In
    - Facebook Login
    - Apple Sign-In (required for iOS)

  User Flow:
  - Onboarding: Account creation → profile setup → goal setting
  - Optional tutorial/walkthrough

  ---
  3.3 Data Models

  Key Collections (Firestore):

  1. Users
    - userId, email, displayName
    - profile: age, gender, height, weight, activityLevel
    - goals: calorieTarget, proteinTarget, carbsTarget, fatsTarget
    - preferences: dietaryRestrictions[], allergies[]
    - createdAt, updatedAt
  2. Recipes
    - recipeId, title, description, imageUrl
    - prepTime, cookTime, totalTime, servings, difficulty
    - ingredients: [{name, quantity, unit}]
    - instructions: [steps]
    - nutrition: {calories, protein, carbs, fats, healthScore}
    - tags[], category, cuisine
    - createdBy (admin), createdAt
  3. MealPlans
    - mealPlanId, userId
    - weekStartDate
    - days: [{dayOfWeek, breakfast, lunch, dinner, snacks}]
    - totalNutrition: {dailyAvgCalories, protein, etc.}
    - generatedBy: "AI" or "manual"
    - createdAt
  4. PantryItems
    - pantryItemId, userId
    - ingredientName, quantity, unit
    - addedDate, source: "manual" or "receipt"
  5. FoodLogs
    - logId, userId, date, mealType
    - source: "recipe", "manual", "photo"
    - recipeId (if applicable)
    - manualEntry: {foodName, quantity, nutrition}
    - photoUrl (if applicable)
    - nutrition: {calories, protein, carbs, fats}
    - createdAt
  6. ShoppingLists
    - listId, userId
    - items: [{ingredient, quantity, unit, checked, inPantry}]
    - createdFrom: "mealPlan" or "manual"
    - createdAt

  ---
  4. User Experience Flow

  4.1 Onboarding

  1. Welcome screen
  2. Authentication (sign up/login)
  3. Profile setup (age, gender, height, weight, activity level)
  4. Goal selection (weight loss/gain/maintenance)
  5. Dietary preferences and restrictions
  6. Brief tutorial (optional)

  4.2 Main App Navigation

  Bottom Navigation Tabs:
  1. Home/Dashboard:
    - Daily nutrition summary
    - Quick actions (log meal, add recipe, scan ingredient)
    - Today's meal plan
    - Progress overview
  2. Recipes:
    - Browse all recipes
    - Search and filter
    - Saved/favorited recipes
    - AI suggestion button
  3. Meal Plans:
    - Current weekly plan
    - Generate new plan
    - Calendar view
  4. Pantry:
    - Current inventory
    - Add ingredients (manual/scan)
    - Shopping list
  5. Profile:
    - User stats and progress
    - Settings
    - Goals adjustment

  ---
  5. Monetization Strategy

  Freemium Model

  Free Tier:
  - Browse recipe database (limited to X recipes per day/week)
  - Basic manual food logging
  - Basic pantry management
  - Limited AI suggestions (e.g., 3 per week)

  Premium Subscription (Monthly/Yearly):
  - Unlimited recipe access
  - Unlimited AI recipe suggestions
  - AI meal plan generation (unlimited weekly plans)
  - Photo-based ingredient recognition
  - Photo-based food logging
  - Receipt scanning for pantry
  - Advanced analytics and progress tracking
  - Export data (PDF meal plans, shopping lists)
  - Ad-free experience
  - Priority customer support

  Pricing Considerations (Romanian Market):
  - Competitive pricing aligned with Romanian purchasing power
  - Suggested: ~20-30 RON/month or ~200-250 RON/year

  ---
  6. Additional Feature Enhancements

  6.1 Nutritional Database

  - Comprehensive Romanian food database
  - Common ingredients with accurate nutrition data
  - Branded product database (Romanian supermarket products)
  - Community contributions (moderated)

  6.2 Recipe Sharing

  - Share recipes via link
  - Export recipe as PDF
  - Social sharing integration (WhatsApp, Facebook, Instagram)

  6.3 Notifications

  - Meal reminders
  - Weekly meal plan ready notification
  - Pantry items low/expiring (future feature)
  - Achievement/milestone notifications
  - Motivational messages

  6.4 Cooking Mode

  - Hands-free recipe viewing
  - Step-by-step guidance with timer
  - Voice commands (future consideration)

  ---
  7. Development Phases (Fast Launch Strategy)

  Phase 1: MVP (Months 1-2)

  Core Features Only:
  - User authentication (email/password, Google)
  - Recipe database (50-100 curated Romanian recipes)
  - Basic recipe browsing and search
  - Manual food logging
  - Basic daily tracking dashboard
  - User profile and goal setting
  - Romanian language only

  Goal: Launch to small beta group, gather feedback

  ---
  Phase 2: AI Integration (Month 3)

  Add AI Features:
  - Google Gemini integration
  - Text-based ingredient suggestions
  - Basic AI meal plan generation
  - Multi-photo ingredient recognition

  Goal: Public launch of free tier

  ---
  Phase 3: Advanced Features (Months 4-5)

  Complete Feature Set:
  - Pantry inventory management
  - Receipt scanning
  - Shopping list with smart merging
  - Photo-based food logging
  - Offline mode implementation
  - Progress analytics and charts
  - Premium subscription launch

  Goal: Full-featured app with monetization

  ---
  Phase 4: Polish & Scale (Month 6+)

  Optimization:
  - Performance improvements
  - UI/UX refinements based on user feedback
  - Expand recipe database (500+ recipes)
  - Marketing and user acquisition
  - English language support preparation

  ---
  8. Success Metrics

  User Engagement:
  - Daily Active Users (DAU)
  - Weekly food logging frequency
  - Recipes viewed per session
  - Meal plans generated
  - AI features usage rate

  Monetization:
  - Free-to-paid conversion rate
  - Monthly Recurring Revenue (MRR)
  - Churn rate
  - Average Revenue Per User (ARPU)

  Quality:
  - App store ratings
  - User retention (Day 1, Day 7, Day 30)
  - Feature completion rate (users finishing onboarding, creating meal plans, etc.)

  ---
  9. Risks & Mitigation

  Risk 1: AI API Costs
  - Mitigation: Rate limiting for free users, optimize prompts, cache common responses

  Risk 2: Recipe Database Quality
  - Mitigation: Curated admin-only recipes initially, strict quality control

  Risk 3: User Retention
  - Mitigation: Gamification elements, notifications, regular content updates

  Risk 4: Competition
  - Mitigation: Focus on Romanian market specificity, traditional recipes, local food database

  ---
  10. Future Expansion Ideas

  - Cooking video tutorials
  - Meal prep guidance
  - Restaurant mode (eating out nutrition tracking)
  - Family sharing (multiple profiles under one subscription)
  - Grocery delivery integration (partnerships with Romanian supermarkets)
  - Fitness tracker integrations (Google Fit, Apple Health)
  - Community features (recipe ratings, comments)
  - Seasonal/holiday recipe collections
  - Nutrition education content

  ---
  Implementation Readiness Checklist

  This design is now ready for implementation planning. A developer can use this document to:

  ✅ Understand the complete product vision
  ✅ Identify all required technical components
  ✅ Estimate development timeline
  ✅ Create detailed user stories and tasks
  ✅ Design database schema
  ✅ Plan API integrations
  ✅ Create UI/UX wireframes and mockups
  ✅ Set up development environment
  ✅ Begin sprint planning for MVP

  ---
  Next Steps: This comprehensive design document is ready to be handed to another Claude instance (or development team) to create a detailed implementation plan with specific technical tasks, file    
   structures, and step-by-step development instructions.

  Would you like me to refine any specific section, or are you ready to proceed with creating the implementation plan?
