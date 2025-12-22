import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/preferences_provider.dart';
import '../utils/app_colors.dart';
import 'reminder_setting_screen.dart';

class SettingsScreen extends StatelessWidget {
  final bool showAppBar;

  const SettingsScreen({super.key, this.showAppBar = true});

  Widget buildTile(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      leading: Icon(icon, size: 28, color: AppColors.navyBlue),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textLight),
      onTap: onTap,
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.turquoise.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.privacy_tip,
                  size: 48,
                  color: AppColors.turquoise,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Privacy Policy",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildPrivacyItem(
                      Icons.lock,
                      "Secure Storage",
                      "Your data is encrypted and stored securely",
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildPrivacyItem(
                      Icons.cloud_sync,
                      "Cloud Sync",
                      "Synchronized with Firebase for seamless access",
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildPrivacyItem(
                      Icons.shield,
                      "Protected",
                      "We never share your personal information",
                      isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navyBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Got it",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyItem(IconData icon, String title, String description, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.turquoise.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.turquoise,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, PreferencesProvider>(
      builder: (context, auth, prefs, _) {
        final content = Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.turquoise.withOpacity(0.2),
                        child: const Icon(Icons.person, size: 32, color: AppColors.turquoise),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth.currentUser?.email?.split('@')[0] ??
                                "HabitFlowUser",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            auth.currentUser?.email ?? "",
                            style:
                                const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 8),
                buildTile(
                  context,
                  Icons.notifications,
                  "Reminder Settings",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReminderSettingScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: const Icon(Icons.dark_mode, size: 28),
                  title: const Text("Dark Mode", style: TextStyle(fontSize: 16)),
                  trailing: Switch(
                    value: prefs.isDarkMode,
                    onChanged: (_) => prefs.toggleTheme(),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                buildTile(
                  context,
                  Icons.lock,
                  "Privacy",
                  onTap: () => _showPrivacyDialog(context),
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                buildTile(
                  context,
                  Icons.logout,
                  "Logout",
                  onTap: () async {
                    await auth.logout();
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );

        if (!showAppBar) return content;

        return Scaffold(
          appBar: AppBar(title: const Text("Settings")),
          body: content,
        );
      },
    );
  }
}
