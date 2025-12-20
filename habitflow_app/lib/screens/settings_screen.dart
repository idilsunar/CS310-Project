import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/preferences_provider.dart';

class SettingsScreen extends StatefulWidget {
  final bool showAppBar;
  
  const SettingsScreen({super.key, this.showAppBar = true});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Widget buildTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, size: 28),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 48,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'We value your privacy and are committed to protecting your personal information. Your habit data is stored locally on your device and is never shared with third parties without your explicit consent.\n\nWe collect minimal data necessary to provide you with the best experience and continuously improve our services.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'OK',
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, PreferencesProvider>(
      builder: (context, authProvider, prefsProvider, _) {
        final content = Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.currentUser?.email?.split('@')[0] ?? "HabitFlowUser",
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
                      ),
                      Text(
                        authProvider.currentUser?.email ?? "habitflow@app.com",
                        style: const TextStyle(color: Colors.grey, fontSize: 14)
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.dark_mode, size: 28),
                title: const Text("Dark Mode", style: TextStyle(fontSize: 16)),
                trailing: Switch(
                  value: prefsProvider.isDarkMode,
                  onChanged: (value) {
                    prefsProvider.toggleTheme();
                  },
                ),
              ),
              const Divider(),
              buildTile(Icons.lock, "Privacy", onTap: _showPrivacyDialog),
              const Divider(),
              buildTile(Icons.logout, "Logout", onTap: () async {
                await authProvider.logout();
              }),
            ],
          ),
        );

        if (widget.showAppBar) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Settings"),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.settings),
                )
              ],
            ),
            body: content,
          );
        }

        return content;
      },
    );
  }
}
