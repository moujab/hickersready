import 'dart:async';

import 'package:flutter/material.dart';

import '../data/auth_session.dart';
import '../data/local_store.dart';
import '../data/weather_client.dart';
import '../l10n/app_localizations.dart';
import '../models/user_profile.dart';
import '../widgets/options_background.dart';

/// Menu item 7: "Settings" — lets the app user edit their own profile
/// (name, father's name, family name, email, phone number).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _fatherController;
  late final TextEditingController _familyController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _weatherCityController;
  late final Future<void> _loaded;

  double? _weatherLat;
  double? _weatherLon;
  List<GeoCity> _citySuggestions = [];
  Timer? _citySearchDebounce;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _fatherController = TextEditingController();
    _familyController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _weatherCityController = TextEditingController();
    _loaded = _loadProfile();
  }

  Future<void> _loadProfile() async {
    final accountEmail = AuthSession.instance.currentEmail!;
    final profile = await LocalStore.getUserProfile(accountEmail);
    _nameController.text = profile.name;
    _fatherController.text = profile.father;
    _familyController.text = profile.family;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _weatherCityController.text = profile.weatherCity ?? '';
    _weatherLat = profile.weatherLat;
    _weatherLon = profile.weatherLon;
  }

  void _onWeatherCityChanged(String query) {
    _weatherLat = null;
    _weatherLon = null;
    _citySearchDebounce?.cancel();
    _citySearchDebounce = Timer(const Duration(milliseconds: 400), () async {
      final results = await WeatherClient.searchCity(query);
      if (mounted) setState(() => _citySuggestions = results);
    });
  }

  void _selectCity(GeoCity city) {
    setState(() {
      _weatherCityController.text = city.displayName;
      _weatherLat = city.latitude;
      _weatherLon = city.longitude;
      _citySuggestions = [];
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherController.dispose();
    _familyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _weatherCityController.dispose();
    _citySearchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final profile = UserProfile(
      name: _nameController.text.trim(),
      father: _fatherController.text.trim(),
      family: _familyController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      weatherCity: _weatherCityController.text.trim().isEmpty ? null : _weatherCityController.text.trim(),
      weatherLat: _weatherLat,
      weatherLon: _weatherLon,
    );
    await LocalStore.putUserProfile(AuthSession.instance.currentEmail!, profile);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuSettings)),
      body: OptionsBackground(
        child: FutureBuilder<void>(
          future: _loaded,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: l10n.settingsFirstName),
                    validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _fatherController,
                    decoration: InputDecoration(labelText: l10n.settingsFatherName),
                    validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _familyController,
                    decoration: InputDecoration(labelText: l10n.settingsFamilyName),
                    validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: l10n.settingsEmail),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return l10n.fieldRequired;
                      if (!_emailPattern.hasMatch(value.trim())) return l10n.invalidEmail;
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: l10n.settingsPhone),
                    keyboardType: TextInputType.phone,
                    validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _weatherCityController,
                    decoration: InputDecoration(
                      labelText: l10n.settingsWeatherCity,
                      helperText: l10n.settingsWeatherCityHint,
                      helperMaxLines: 2,
                      prefixIcon: const Icon(Icons.wb_sunny_outlined),
                    ),
                    onChanged: _onWeatherCityChanged,
                  ),
                  if (_citySuggestions.isNotEmpty)
                    Card(
                      margin: const EdgeInsets.only(top: 4),
                      child: Column(
                        children: _citySuggestions
                            .map(
                              (city) => ListTile(
                                dense: true,
                                leading: const Icon(Icons.location_on_outlined),
                                title: Text(city.displayName),
                                onTap: () => _selectCity(city),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 24),
                  FilledButton(onPressed: _save, child: Text(l10n.save)),
                  const SizedBox(height: 12),
                  OutlinedButton(onPressed: AuthSession.instance.logout, child: Text(l10n.logout)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
