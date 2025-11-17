import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/services/local_storage_service.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _localStorage = LocalStorageService.instance;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Load settings from local storage
    setState(() {
      _notificationsEnabled = _localStorage.getBool('notifications') ?? true;
      _darkModeEnabled = _localStorage.getBool('dark_mode') ?? false;
    });
  }

  Future<void> _saveNotificationSetting(bool value) async {
    await _localStorage.setBool('notifications', value);
    setState(() => _notificationsEnabled = value);
  }

  Future<void> _saveDarkModeSetting(bool value) async {
    await _localStorage.setBool('dark_mode', value);
    setState(() => _darkModeEnabled = value);

    // TODO: Implement dark mode toggle in theme
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Modul întunecat va fi implementat în viitoarea versiune'),
        ),
      );
    }
  }

  Future<void> _showLogoutDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deconectare'),
        content: const Text('Ești sigur că vrei să te deconectezi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              AppStrings.logout,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<AuthProvider>().signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _showDeleteAccountDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Șterge contul'),
        content: const Text(
          'Ești sigur că vrei să ștergi contul? Această acțiune este permanentă și nu poate fi anulată.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Șterge',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // TODO: Implement account deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ștergerea contului va fi implementată în curând'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App settings section
          _buildSectionHeader('Setări aplicație'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: _notificationsEnabled,
                  onChanged: _saveNotificationSetting,
                  title: const Text('Notificări'),
                  subtitle: const Text('Primește notificări pentru mese și obiective'),
                  secondary: const Icon(Icons.notifications_outlined),
                  activeColor: AppColors.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _darkModeEnabled,
                  onChanged: _saveDarkModeSetting,
                  title: const Text('Mod întunecat'),
                  subtitle: const Text('Folosește tema întunecată'),
                  secondary: const Icon(Icons.dark_mode_outlined),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Account settings section
          _buildSectionHeader('Cont'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Schimbă email'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcție disponibilă în curând'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Schimbă parola'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcție disponibilă în curând'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Data & Privacy section
          _buildSectionHeader('Date & Confidențialitate'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: const Text('Exportă datele'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcție disponibilă în curând'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Politica de confidențialitate'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to privacy policy
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Termeni și condiții'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to terms and conditions
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About section
          _buildSectionHeader('Despre'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Versiune aplicație'),
                  trailing: const Text(
                    '1.0.0',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.rate_review_outlined),
                  title: const Text('Evaluează aplicația'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mulțumim pentru interes!'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.bug_report_outlined),
                  title: const Text('Raportează o problemă'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcție disponibilă în curând'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Danger zone section
          _buildSectionHeader('Zona periculoasă'),
          const SizedBox(height: 8),
          Card(
            color: AppColors.error.withValues(alpha: 0.05),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: AppColors.error,
                  ),
                  title: const Text(
                    AppStrings.logout,
                    style: TextStyle(color: AppColors.error),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.error,
                  ),
                  onTap: _showLogoutDialog,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.delete_forever,
                    color: AppColors.error,
                  ),
                  title: const Text(
                    'Șterge contul',
                    style: TextStyle(color: AppColors.error),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.error,
                  ),
                  onTap: _showDeleteAccountDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // App info
          Center(
            child: Column(
              children: [
                Text(
                  AppStrings.appName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.appTagline,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
      ),
    );
  }
}
