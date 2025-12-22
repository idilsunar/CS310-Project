import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/preferences_provider.dart';
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
      leading: Icon(icon, size: 28),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Privacy Policy"),
        content: const Text(
          "Your data is stored securely and synchronized with Firebase.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, PreferencesProvider>(
      builder: (context, auth, prefs, _) {
        final content = Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        auth.currentUser?.email?.split('@')[0] ??
                            "HabitFlowUser",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        auth.currentUser?.email ?? "",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),

              /// 🔔 Reminder Settings → ileri geçiş
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

              const Divider(),

              /// 🌙 Dark Mode
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text("Dark Mode"),
                trailing: Switch(
                  value: prefs.isDarkMode,
                  onChanged: (_) => prefs.toggleTheme(),
                ),
              ),

              const Divider(),

              /// 🔐 Privacy
              buildTile(
                context,
                Icons.lock,
                "Privacy",
                onTap: () => _showPrivacyDialog(context),
              ),

              const Divider(),

              /// 🚪 Logout
              buildTile(
                context,
                Icons.logout,
                "Logout",
                onTap: () async {
                  await auth.logout();
                },
              ),
            ],
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
