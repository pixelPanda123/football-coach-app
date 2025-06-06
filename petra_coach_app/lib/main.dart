import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/theme.dart';
import 'screens/auth/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/attendance_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => AttendanceService()),
      ],
      child: MaterialApp(
        title: 'Petra Coach App',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
