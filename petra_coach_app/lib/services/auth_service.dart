import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

      // Mock login - replace with actual authentication
      if (email == 'student@petra.com') {
        _currentUser = UserModel(
          id: '1',
          name: 'John Student',
          email: email,
          role: UserRole.student,
          centerId: 'center1',
        );
      } else if (email == 'coach@petra.com') {
        _currentUser = UserModel(
          id: '2',
          name: 'Jane Coach',
          email: email,
          role: UserRole.coach,
          centerId: 'center1',
        );
      } else if (email == 'headcoach@petra.com') {
        _currentUser = UserModel(
          id: '3',
          name: 'Kevin Head Coach',
          email: email,
          role: UserRole.headCoach,
          centerId: 'all',
        );
      } else {
        throw Exception('Invalid credentials');
      }

      // Save auth state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      await prefs.setString('user_role', _currentUser!.role.toString());

      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future<bool> checkAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('user_email');
    
    if (userEmail != null) {
      return login(userEmail, ''); // Re-authenticate with saved email
    }
    return false;
  }

  Future<bool> updateProfile(UserModel updatedUser) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, this would send a reset link to the user's email
      // For demo, we'll just check if it's a valid demo email
      if (email == 'student@petra.com' || 
          email == 'coach@petra.com' || 
          email == 'headcoach@petra.com') {
        return true;
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 