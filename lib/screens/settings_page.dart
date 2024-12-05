import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'help_support_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'हिंदी',
    'mr': 'मराठी',
    'gu': 'ગુજરાતી',
    'hr': 'हरियाणवी'
  };

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              leading: Radio<String>(
                value: 'en',
                groupValue: context.locale.languageCode,
                onChanged: (value) {
                  context.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('हिंदी (Hindi)'),
              leading: Radio<String>(
                value: 'hi',
                groupValue: context.locale.languageCode,
                onChanged: (value) {
                  context.setLocale(const Locale('hi'));
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('मराठी (Marathi)'),
              leading: Radio<String>(
                value: 'mr',
                groupValue: context.locale.languageCode,
                onChanged: (value) {
                  context.setLocale(const Locale('mr'));
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('ગુજરાતી (Gujarati)'),
              leading: Radio<String>(
                value: 'gu',
                groupValue: context.locale.languageCode,
                onChanged: (value) {
                  context.setLocale(const Locale('gu'));
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('settings'.tr(), style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryGreen,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kPrimaryGreen.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Account Section
             Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                'accountSettings'.tr(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),

            // Dark Mode Toggle
            SwitchListTile(
              title:  Text('darkMode'.tr()),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
              secondary: Icon(Icons.dark_mode),
            ),
            const Divider(),

            // Version
             ListTile(
              leading: Icon(Icons.info),
              title: Text('version'.tr()),
              subtitle: Text('1.0.0'),
            ),
            const Divider(),

            // Privacy Policy
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title:  Text('privacyPolicy'.tr()),
              onTap: () {
                // Navigate to Privacy Policy page
              },
            ),
            const Divider(),

            // Terms and Conditions
            ListTile(
              leading: const Icon(Icons.description),
              title:  Text('termsConditions'.tr()),
              onTap: () {
                // Navigate to Terms page
              },
            ),
            const Divider(),

            // Language Selection
            ListTile(
              leading: const Icon(Icons.language),
              title: Text('language'.tr()),
              subtitle:
                  Text(languageNames[context.locale.languageCode] ?? 'English'),
              onTap: _showLanguageDialog,
            ),
            const Divider(),

            // Delete Account
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title:  Text(
                'deleteAccount'.tr(),
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('deleteAccount'.tr()),
                    content: Text(
                        'deleteAccountConfirm'.tr()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child:  Text('cancel'.tr()),
                      ),
                      TextButton(
                        onPressed: () {
                          // Implement account deletion
                          Navigator.pop(context);
                        },
                        child: Text('delete'.tr(),
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(),

            // Help & Support
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.help_outline, color: kPrimaryGreen),
                title: Text('helpAndSupport'.tr(),
                    style: TextStyle(fontWeight: FontWeight.w500)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpSupportPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
