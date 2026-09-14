import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final LocalStorageService _storageService =
      LocalStorageService();

  bool _isLoggedIn = false;
  String? _currentUser;

  bool get isLoggedIn => _isLoggedIn;

  String? get currentUser => _currentUser;

  Future<void> checkSession() async {
    final prefs = await SharedPreferences.getInstance();

    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _currentUser = prefs.getString('currentUser');

    notifyListeners();
  }

  Future<bool> createAccount(
    String email,
    String password,
  ) async {
    final created = await _storageService.createUser(
      email,
      password,
    );

    return created;
  }

  Future<bool> login(
    String email,
    String password,
  ) async {
    final isValid = await _storageService.validateUser(
      email,
      password,
    );

    if (!isValid) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('currentUser', email);

    _isLoggedIn = true;
    _currentUser = email;

    notifyListeners();

    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('currentUser');

    _isLoggedIn = false;
    _currentUser = null;

    notifyListeners();
  }
}