# Recipe Tags Documentation

This document defines the standardized list of tags that can be applied to recipes in the Mealee app. Tags help users find recipes that match their preferences, dietary restrictions, and cooking goals.

## Categories of Tags

### 1. Dietary Preferences & Restrictions

#### Vegetarian & Vegan
- **vegetarian** - Does not contain meat or fish
- **vegan** - No animal products whatsoever
- **lacto-vegetarian** - Vegetarian that includes dairy
- **ovo-vegetarian** - Vegetarian that includes eggs

#### Allergen-Free
- **fără gluten** - Gluten-free
- **fără lactate** - Dairy-free / Lactose-free
- **fără nuci** - Nut-free
- **fără soia** - Soy-free
- **fără ou** - Egg-free

### 2. Nutritional Goals

#### Low/High Macros
- **low-carb** - Low in carbohydrates (< 30g per serving)
- **high-protein** - High in protein (> 20g per serving)
- **low-fat** - Low in fat (< 10g per serving)
- **high-fiber** - High in fiber (> 5g per serving)

#### Calorie-Based
- **low-calorie** - Under 300 calories per serving
- **moderate-calorie** - 300-500 calories per serving
- **high-calorie** - Over 500 calories per serving

### 3. Health & Wellness

- **sănătos** - Healthy, nutritious option
- **detox** - Detoxifying ingredients
- **energizant** - Energy-boosting
- **imunitate** - Immune system support
- **antiinflamator** - Anti-inflammatory ingredients
- **pentru diabetici** - Suitable for diabetics (low glycemic index)
- **pentru gravide** - Pregnancy-safe

### 4. Preparation & Difficulty

#### Time-Based
- **rapid** - Quick to prepare (< 15 minutes)
- **moderat** - Moderate preparation time (15-45 minutes)
- **îndelungat** - Lengthy preparation (> 45 minutes)

#### Skill Level
- **începător** - Beginner-friendly
- **intermediar** - Intermediate cooking skills required
- **avansat** - Advanced techniques required

#### Method
- **fără gătit** - No cooking required
- **la cuptor** - Baked in oven
- **la grătar** - Grilled
- **la aragaz** - Stovetop cooking
- **slow cooker** - Slow cooker / Crockpot
- **instant pot** - Pressure cooker
- **air fryer** - Air fryer

### 5. Cost & Accessibility

- **economic** - Budget-friendly
- **ingrediente simple** - Common, easy-to-find ingredients
- **premium** - Requires special/expensive ingredients
- **sezonier** - Uses seasonal ingredients

### 6. Meal Type & Occasion

#### Time of Day
- **mic dejun** - Breakfast
- **prânz** - Lunch
- **cină** - Dinner
- **gustare** - Snack
- **desert** - Dessert

#### Occasion
- **festiv** - Festive, special occasions
- **party** - Party food
- **picnic** - Picnic-friendly
- **sărbători** - Holiday recipes
- **romantic** - Romantic dinner
- **pentru copii** - Kid-friendly
- **pentru bebeluși** - Baby food

### 7. Cultural & Regional

- **tradițional** - Traditional Romanian
- **regional** - Specific Romanian region (Moldova, Transilvania, etc.)
- **mediteranean** - Mediterranean diet
- **asian** - Asian cuisine
- **italian** - Italian cuisine
- **mexican** - Mexican cuisine
- **american** - American cuisine

### 8. Special Diets

- **keto** - Ketogenic diet compatible
- **paleo** - Paleo diet compatible
- **mediteranean** - Mediterranean diet
- **whole30** - Whole30 program compatible
- **raw** - Raw food diet
- **DASH** - DASH diet (for blood pressure)

### 9. Texture & Presentation

- **crocant** - Crispy/crunchy
- **cremos** - Creamy
- **proaspăt** - Fresh
- **instagramabil** - Visually appealing, photogenic

### 10. Special Properties

- **batch cooking** - Good for meal prep/batch cooking
- **congelabil** - Freezer-friendly
- **rămășițe** - Good for using leftovers
- **un singur vas** - One-pot/one-pan meal
- **fără ulei** - Oil-free

## Usage Guidelines

### Tagging Best Practices

1. **Use 3-7 tags per recipe** - Don't over-tag
2. **Be accurate** - Only use tags that truly apply
3. **Consider the user** - Think about what someone would search for
4. **Keep updated** - Review and update tags as needed

### Required Tags

Every recipe must have at least:
1. One meal type tag (mic dejun, prânz, cină, etc.)
2. One difficulty tag (începător, intermediar, avansat)
3. One time tag (rapid, moderat, îndelungat)

### Tag Combinations

Some useful tag combinations:
- `rapid + sănătos + low-carb` = Quick healthy low-carb meal
- `vegetarian + high-protein + pentru copii` = Kid-friendly vegetarian protein
- `economic + batch cooking + congelabil` = Budget meal prep

## Implementation

### In Firebase/Firestore

Tags should be stored as an array of strings:

```json
{
  "recipeId": "recipe_123",
  "title": "Supă de legume",
  "tags": [
    "sănătos",
    "vegetarian",
    "low-calorie",
    "rapid",
    "economic"
  ]
}
```

### In the App

Tags can be used for:
- **Filtering** - Users can filter recipes by multiple tags
- **Search** - Tag-based search alongside text search
- **Recommendations** - Suggest recipes based on user's favorite tags
- **Discovery** - "Browse by tag" feature

## Future Enhancements

Potential additions:
- User-generated tags (with moderation)
- Tag popularity metrics
- Personalized tag weights based on user preferences
- Seasonal tag highlighting
