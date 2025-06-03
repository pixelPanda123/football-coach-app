import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/theme.dart';
import 'models/user_model.dart';
import 'screens/student/student_dashboard.dart';
import 'screens/coach/coach_dashboard.dart';
import 'screens/head_coach/head_coach_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petra Sports Academy',
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}

// TODO: Replace this with actual authentication
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulating a logged-in user for demonstration
    // In reality, this would come from your authentication service
    final user = UserModel(
      id: '1',
      name: 'Kevin',
      email: 'kevin@petrasports.com',
      role: UserRole.headCoach,
      centerId: 'khanapur',
    );

    return _buildDashboardForRole(user);
  }

  Widget _buildDashboardForRole(UserModel user) {
    switch (user.role) {
      case UserRole.student:
        return StudentDashboard(user: user);
      case UserRole.coach:
        return CoachDashboard(user: user);
      case UserRole.headCoach:
        return HeadCoachDashboard(user: user);
    }
  }
}
