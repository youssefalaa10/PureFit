
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  final bool _isNotificationEnabled = false;
  bool _isDarkMode = false;
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('locale') ?? 'en'; // Default to 'en'
      _isDarkMode =
          prefs.getBool('isDarkMode') ?? false; // Default to light mode
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', languageCode);
    if (!mounted) return;
    setState(() {
      _selectedLanguage = languageCode;
    });

    // Reload the app with the new locale
    // MyApp.setLocale(context, Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      // backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        // title: Text(AppString.setting(context), style: textTheme.bodyLarge),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomSettingsSection(
              title: 'General',
              // title: AppString.general(context),
              options: [
                CustomSettingsOption(
                  icon: Icons.language,
                  label: 'Language',
                  // label: AppString.language(context),
                  trailing: _buildLanguageDropdown(theme),
                ),
                CustomSettingsOption(
                  icon: Icons.notifications,
                  label: 'Notifications',
                  // label: AppString.notification(context),
                  trailing: Switch(
                    inactiveTrackColor: Colors.transparent,
                    activeColor: theme.colorScheme.primary,
                    value: _isNotificationEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        // _isNotificationEnabled = value;
                      });
                    },
                  ),
                ),
                CustomSettingsOption(
                  icon: Icons.dark_mode,
                  label: 'Dark Mode',
                  // label: AppString.darkMode(context),
                  trailing: Switch(
                    inactiveTrackColor: Colors.transparent,
                    activeColor: theme.colorScheme.primary,
                    value: _isDarkMode,
                    onChanged: (bool value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                      // MyApp.toggleTheme(context, _isDarkMode);
                    },
                  ),
                ),
              ],
            ),
            CustomSettingsSection(
              title: 'About',
              // title: AppString.aboutApp(context),
              options: [
                CustomSettingsOption(
                  icon: Icons.info,
                  label: 'About App',
                  // label: AppString.aboutApp(context),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    // Handle About App tap
                  
                  },
                ),
                CustomSettingsOption(
                  icon: Icons.support_agent,
                  label: 'Help & Support',
                  // label: AppString.helpAndSupport(context),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    // Handle help & support option tap
                    
                  },
                ),
                CustomSettingsOption(
                  icon: Icons.description,
                  label: 'Terms & Conditions',
                  // label: AppString.termsAndConditions(context),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    // Handle Terms & Conditions tap
                   
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(ThemeData theme) {
    final textTheme = theme.textTheme;

    return DropdownButton<String>(
      value: _selectedLanguage,
      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      underline: Container(),
      dropdownColor: theme.cardColor,
      items: [
        DropdownMenuItem(
          value: 'en',
          child: Text(
            'English',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        DropdownMenuItem(
          value: 'ar',
          child: Text(
            'Arabic',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      onChanged: (String? newValue) {
        if (newValue != null) {
          _changeLanguage(newValue);
        }
      },
      icon: const Icon(Icons.arrow_drop_down),
      borderRadius: BorderRadius.circular(8.0),
      elevation: 16,
    );
  }
}

class TitleSection extends StatelessWidget {
  final String text;

  const TitleSection({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CustomSettingsSection extends StatelessWidget {
  final String title;
  final List<CustomSettingsOption> options;

  const CustomSettingsSection({
    super.key,
    required this.title,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSection(
          text: title,
        ),
        Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.dividerColor,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: options.map((option) {
              return ListTile(
                leading: BuildOptionIcon(icon: option.icon),
                title: Text(option.label, style: theme.textTheme.bodyMedium),
                trailing: option.trailing,
                onTap: option.onTap,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class CustomSettingsOption {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  CustomSettingsOption({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });
}

class BuildOptionIcon extends StatelessWidget {
  final IconData icon;

  const BuildOptionIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Icon(icon, color: theme.iconTheme.color);
  }
}