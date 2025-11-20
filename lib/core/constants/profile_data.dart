/// Profile setup data constants
/// This file contains diet types, preferred foods, allergies, and other profile-related data

class ProfileData {
  ProfileData._();

  // ============== DIET TYPES ==============

  static const Map<String, Map<String, String>> dietTypes = {
    'classic': {
      'label': 'Clasic (Totul inclus)',
      'description': 'Fără restricții. O dietă echilibrată cu de toate.',
    },
    'high_protein': {
      'label': 'Hiperproteică',
      'description': 'Accent pe carne, ouă și leguminoase. Ideal pentru mușchi.',
    },
    'mediterranean': {
      'label': 'Mediteraneană',
      'description': 'Multe legume, ulei de măsline, pește și nuci.',
    },
    'keto': {
      'label': 'Keto',
      'description': 'Grăsimi multe, carbohidrați foarte puțini (sub 50g).',
    },
    'low_carb': {
      'label': 'Low-Carb',
      'description': 'Carbohidrați reduși, dar nu la fel de strict ca Keto.',
    },
    'vegetarian': {
      'label': 'Vegetarian',
      'description': 'Fără carne, dar include ouă și lactate.',
    },
    'vegan': {
      'label': 'Vegan (De Post)',
      'description': 'Fără niciun produs de origine animală.',
    },
    'pescatarian': {
      'label': 'Pescatarian',
      'description': 'Vegetarian + pește și fructe de mare.',
    },
    'paleo': {
      'label': 'Paleo',
      'description': 'Fără cereale sau lactate. Doar ce se vâna/culegea.',
    },
    'fasting': {
      'label': 'Mod Fasting',
      'description': 'Dietă cu perioade de post intermitent.',
    },
  };

  // ============== PREFERRED FOODS ==============

  /// Grouped preferred foods for better UI organization
  static const Map<String, Map<String, String>> preferredFoodsGrouped = {
    // A. Proteine (Proteins)
    'proteins': {
      'chicken': 'Pui',
      'pork': 'Porc',
      'beef': 'Vită',
      'fish': 'Pește',
      'eggs': 'Ouă',
      'beans': 'Fasole / Năut',
    },

    // B. Carbohidrați (Carbs)
    'carbs': {
      'potatoes': 'Cartofi',
      'rice': 'Orez',
      'pasta': 'Paste',
      'bread': 'Pâine / Produse panificație',
      'mamaliga': 'Mămăligă',
    },

    // C. Legume & Verdețuri (Veg & Greens)
    'vegetables': {
      'tomatoes': 'Roșii',
      'root_veg': 'Rădăcinoase (Morcov, Țelină)',
      'leafy_greens': 'Salată / Spanac',
      'cabbage': 'Varză',
      'eggplant': 'Vinete',
      'mushrooms': 'Ciuperci',
    },

    // D. Lactate (Dairy)
    'dairy': {
      'cheese': 'Brânzeturi (Telemea, Cașcaval)',
      'yogurt': 'Iaurt / Smântână',
    },
  };

  /// Category labels for preferred foods
  static const Map<String, String> preferredFoodCategories = {
    'proteins': 'Proteine',
    'carbs': 'Carbohidrați',
    'vegetables': 'Legume & Verdețuri',
    'dairy': 'Lactate',
  };

  /// Flat list of all preferred foods (for validation)
  static const Map<String, String> allPreferredFoods = {
    // Proteins
    'chicken': 'Pui',
    'pork': 'Porc',
    'beef': 'Vită',
    'fish': 'Pește',
    'eggs': 'Ouă',
    'beans': 'Fasole / Năut',
    // Carbs
    'potatoes': 'Cartofi',
    'rice': 'Orez',
    'pasta': 'Paste',
    'bread': 'Pâine / Produse panificație',
    'mamaliga': 'Mămăligă',
    // Vegetables
    'tomatoes': 'Roșii',
    'root_veg': 'Rădăcinoase (Morcov, Țelină)',
    'leafy_greens': 'Salată / Spanac',
    'cabbage': 'Varză',
    'eggplant': 'Vinete',
    'mushrooms': 'Ciuperci',
    // Dairy
    'cheese': 'Brânzeturi (Telemea, Cașcaval)',
    'yogurt': 'Iaurt / Smântână',
  };

  // ============== ALLERGIES ==============

  static const Map<String, String> allergies = {
    'nuts': 'Nuci',
    'dairy': 'Lactate',
    'eggs': 'Ouă',
    'fish': 'Pește',
    'shellfish': 'Fructe de mare',
    'soy': 'Soia',
    'wheat': 'Grâu',
  };

  // ============== ACTIVITY LEVELS ==============

  static const Map<String, Map<String, String>> activityLevels = {
    'sedentary': {
      'label': 'Sedentar',
      'description': 'Puțin sau deloc exerciții',
    },
    'lightly_active': {
      'label': 'Ușor activ',
      'description': 'Exerciții ușoare 1-3 zile/săptămână',
    },
    'moderately_active': {
      'label': 'Moderat activ',
      'description': 'Exerciții moderate 3-5 zile/săptămână',
    },
    'very_active': {
      'label': 'Foarte activ',
      'description': 'Exerciții intense 6-7 zile/săptămână',
    },
  };

  // ============== HEALTH GOALS ==============

  static const Map<String, Map<String, String>> healthGoals = {
    'weight_loss': {
      'label': 'Pierdere în greutate',
      'description': 'Scade în greutate într-un mod sănătos',
    },
    'weight_maintenance': {
      'label': 'Menținere greutate',
      'description': 'Menține greutatea actuală',
    },
    'muscle_gain': {
      'label': 'Creștere musculară',
      'description': 'Crește masa musculară',
    },
  };

  // ============== GENDER OPTIONS ==============

  static const Map<String, String> genderOptions = {
    'male': 'Masculin',
    'female': 'Feminin',
    'prefer_not_to_say': 'Prefer să nu spun',
  };

  // ============== VALIDATION ==============

  /// Target weight limits (kg)
  static const double minTargetWeight = 30.0;
  static const double maxTargetWeight = 300.0;
}
