import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';
import 'firebase_service.dart';

/// Service for migrating existing recipe data to include new fields
/// Use this to add dietFlags and ingredientKeywords to existing recipes
class RecipeMigrationService {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Migrate all recipes to compute and add dietFlags and ingredientKeywords
  ///
  /// This should be run once after deploying the new recipe model with dietFlags
  /// and ingredientKeywords fields.
  ///
  /// Parameters:
  /// - batchSize: Number of recipes to process per batch (default: 50)
  /// - dryRun: If true, only logs what would be updated without saving (default: false)
  ///
  /// Returns: Number of recipes successfully migrated
  Future<int> migrateAllRecipes({
    int batchSize = 50,
    bool dryRun = false,
  }) async {
    try {
      print('Starting recipe migration...');
      print('Dry run: $dryRun');

      int totalMigrated = 0;
      int totalFailed = 0;

      // Fetch all recipes in batches
      QuerySnapshot? lastBatch;
      bool hasMore = true;

      while (hasMore) {
        Query query = _firebaseService.recipesCollection.limit(batchSize);

        // If we have a last document, start after it
        if (lastBatch != null && lastBatch.docs.isNotEmpty) {
          query = query.startAfterDocument(lastBatch.docs.last);
        }

        final snapshot = await query.get();

        if (snapshot.docs.isEmpty) {
          hasMore = false;
          break;
        }

        print('\nProcessing batch of ${snapshot.docs.length} recipes...');

        // Process each recipe in the batch
        for (final doc in snapshot.docs) {
          try {
            final recipe = RecipeModel.fromFirestore(doc);

            // Check if recipe already has dietFlags (skip if already migrated)
            if (recipe.dietFlags.isNotEmpty &&
                recipe.ingredientKeywords.isNotEmpty) {
              print('  ✓ Skipping ${recipe.title} (already migrated)');
              continue;
            }

            // Compute flags and keywords
            final migratedRecipe = recipe.computeFlags();

            if (dryRun) {
              print('  [DRY RUN] Would update ${recipe.title}:');
              print('    - Diet flags: ${migratedRecipe.dietFlags}');
              print(
                '    - Keywords (${migratedRecipe.ingredientKeywords.length}): ${migratedRecipe.ingredientKeywords.take(5).join(", ")}...',
              );
            } else {
              // Update the recipe in Firestore
              await _firebaseService.recipesCollection
                  .doc(recipe.recipeId)
                  .update({
                'dietFlags': migratedRecipe.dietFlags,
                'ingredientKeywords': migratedRecipe.ingredientKeywords,
              });

              print('  ✓ Migrated ${recipe.title}');
              print('    - Diet flags: ${migratedRecipe.dietFlags}');
            }

            totalMigrated++;
          } catch (e) {
            print('  ✗ Failed to migrate recipe ${doc.id}: $e');
            totalFailed++;
          }
        }

        lastBatch = snapshot;
      }

      print('\n=== Migration Complete ===');
      print('Total migrated: $totalMigrated');
      print('Total failed: $totalFailed');

      return totalMigrated;
    } catch (e) {
      print('Error during migration: $e');
      rethrow;
    }
  }

  /// Migrate a single recipe by ID
  ///
  /// Useful for testing or fixing individual recipes
  Future<bool> migrateSingleRecipe(String recipeId) async {
    try {
      print('Migrating recipe $recipeId...');

      final doc =
          await _firebaseService.recipesCollection.doc(recipeId).get();

      if (!doc.exists) {
        print('Recipe not found: $recipeId');
        return false;
      }

      final recipe = RecipeModel.fromFirestore(doc);
      final migratedRecipe = recipe.computeFlags();

      await _firebaseService.recipesCollection.doc(recipeId).update({
        'dietFlags': migratedRecipe.dietFlags,
        'ingredientKeywords': migratedRecipe.ingredientKeywords,
      });

      print('✓ Successfully migrated ${recipe.title}');
      print('  - Diet flags: ${migratedRecipe.dietFlags}');
      print('  - Keywords: ${migratedRecipe.ingredientKeywords.take(5).join(", ")}...');

      return true;
    } catch (e) {
      print('Error migrating recipe $recipeId: $e');
      return false;
    }
  }

  /// Get migration statistics (how many recipes need migration)
  Future<Map<String, int>> getMigrationStats() async {
    try {
      final snapshot = await _firebaseService.recipesCollection.get();

      int total = snapshot.docs.length;
      int migrated = 0;
      int needMigration = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        if (data['dietFlags'] != null && data['ingredientKeywords'] != null) {
          final dietFlags = List<String>.from(data['dietFlags'] ?? []);
          final keywords = List<String>.from(data['ingredientKeywords'] ?? []);

          if (dietFlags.isNotEmpty && keywords.isNotEmpty) {
            migrated++;
          } else {
            needMigration++;
          }
        } else {
          needMigration++;
        }
      }

      return {
        'total': total,
        'migrated': migrated,
        'needMigration': needMigration,
      };
    } catch (e) {
      print('Error getting migration stats: $e');
      return {
        'total': 0,
        'migrated': 0,
        'needMigration': 0,
      };
    }
  }

  /// Verify migration results
  ///
  /// Checks that all recipes have valid dietFlags and ingredientKeywords
  Future<Map<String, dynamic>> verifyMigration() async {
    try {
      print('Verifying migration...');

      final snapshot = await _firebaseService.recipesCollection.get();
      final results = {
        'total': snapshot.docs.length,
        'valid': 0,
        'invalid': 0,
        'invalidRecipes': <String>[],
      };

      for (final doc in snapshot.docs) {
        final recipe = RecipeModel.fromFirestore(doc);

        if (recipe.dietFlags.isEmpty || recipe.ingredientKeywords.isEmpty) {
          results['invalid'] = (results['invalid'] as int) + 1;
          (results['invalidRecipes'] as List<String>).add(recipe.title);
        } else {
          results['valid'] = (results['valid'] as int) + 1;
        }
      }

      print('\n=== Migration Verification ===');
      print('Total recipes: ${results['total']}');
      print('Valid (migrated): ${results['valid']}');
      print('Invalid (need migration): ${results['invalid']}');

      if (results['invalid'] as int > 0) {
        print('\nRecipes needing migration:');
        for (final title in results['invalidRecipes'] as List<String>) {
          print('  - $title');
        }
      }

      return results;
    } catch (e) {
      print('Error verifying migration: $e');
      rethrow;
    }
  }
}
