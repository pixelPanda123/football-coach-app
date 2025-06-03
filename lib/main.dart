import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'constants/theme.dart';
import 'screens/auth/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/attendance_service.dart';
import 'services/student_service.dart';
import 'services/fee_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        ChangeNotifierProvider(create: (_) => StudentService()),
        Provider(create: (_) => FeeService()),
      ],
      child: MaterialApp(
        title: 'Petra Coach App',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
} 