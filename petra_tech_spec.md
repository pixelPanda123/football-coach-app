
# Petra Sports Academy Coaching App
## Technical Specification Document

### 1. Project Overview

**Application**: iPad-first coaching management system  
**Target Users**: 127 students, 5 coaches, 1 head coach  
**Development Team**: 3 interns with limited experience  
**Timeline**: 6 months (3 phases)  
**Primary Platform**: iPadOS (iOS 14+)  
**Secondary Platform**: Android (future release)

---

### 2. Architecture Overview

#### 2.1 System Architecture
- **Pattern**: Client-Server with Offline-First Design
- **Architecture**: Single Page Application (SPA) with Progressive Web App (PWA) capabilities
- **Data Flow**: Real-time synchronization with offline fallback
- **Deployment**: Cloud-based backend with client-side caching

#### 2.2 High-Level Components
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Mobile App    │◄──►│  Backend API    │◄──►│    Database     │
│   (Flutter)     │    │ (Firebase/Dart) │    │   (Firebase)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Local Storage   │    │  Authentication │    │   File Storage  │
│ (Hive/SQLite)   │    │   (Firebase)    │    │  (Cloud Storage)│
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

### 3. Frontend Technology Stack

#### 3.1 Primary Framework
**Flutter (v3.13+)**
- **Justification**: Single codebase for iOS/Android, excellent performance, rich UI widgets
- **Language**: Dart (easy to learn for beginners)
- **Key Advantages**: Hot reload, Material Design built-in, strong documentation
- **Flutter SDK**: Latest stable version with null safety

#### 3.2 State Management
**Provider Pattern + ChangeNotifier**
- **Justification**: Simple, official Flutter recommendation, easy for beginners
- **Package**: `provider: ^6.0.5`
- **Alternative**: Riverpod (if team wants more advanced features)
- **Local State**: StatefulWidget + setState for simple cases

#### 3.3 Core Flutter Packages
```yaml
# pubspec.yaml dependencies
dependencies:
  flutter:
    sdk: flutter
  
  # UI and Design
  material_color_utilities: ^0.5.0    # Material Design 3
  cupertino_icons: ^1.0.6             # iOS-style icons
  google_fonts: ^6.1.0                # Custom fonts
  flutter_svg: ^2.0.7                 # SVG support
  
  # Navigation
  go_router: ^12.1.1                  # Declarative routing
  
  # State Management
  provider: ^6.0.5                    # State management
  
  # Forms and Input
  flutter_form_builder: ^9.1.1        # Form building
  form_builder_validators: ^9.1.0     # Form validation
  
  # Date and Time
  calendar_date_picker2: ^0.5.3       # Date picker
  time_picker_spinner: ^2.0.1         # Time picker
```

#### 3.4 Charts and Visualization
```yaml
# Data Visualization packages
dependencies:
  # Charts
  fl_chart: ^0.64.0                   # Beautiful, customizable charts
  syncfusion_flutter_charts: ^23.1.36 # Professional charts (free)
  
  # Progress Indicators
  percent_indicator: ^4.2.3           # Progress bars and circles
  circular_chart_flutter: ^0.1.0     # Circular progress charts
```

#### 3.5 Offline Capabilities
```yaml
# Offline and Storage
dependencies:
  # Local Database
  sqflite: ^2.3.0                    # SQLite for Flutter
  path: ^1.8.3                       # File path utilities
  
  # Local Storage
  shared_preferences: ^2.2.2         # Simple key-value storage
  hive: ^2.2.3                       # Fast local database
  hive_flutter: ^1.1.0               # Hive Flutter integration
  
  # Network and Connectivity
  connectivity_plus: ^5.0.1          # Network status
  dio: ^5.3.2                        # HTTP client with caching
  dio_cache_interceptor: ^3.4.4      # HTTP caching
```

---

### 4. Backend Technology Stack

#### 4.1 Backend-as-a-Service (Recommended for Interns)
**Firebase (Google)**
```yaml
# pubspec.yaml - Firebase dependencies
dependencies:
  # Core Firebase
  firebase_core: ^2.17.0
  firebase_auth: ^4.10.1
  cloud_firestore: ^4.9.3
  firebase_storage: ^11.2.8
  firebase_analytics: ^10.5.1
  
  # Optional Firebase services
  firebase_messaging: ^14.6.9        # Push notifications
  firebase_crashlytics: ^3.3.7       # Crash reporting
  firebase_performance: ^0.9.2+8     # Performance monitoring
  firebase_remote_config: ^4.2.8     # Remote configuration
```

**Firebase Configuration**:
- **Firestore**: NoSQL document database with offline support
- **Firebase Auth**: User authentication with custom claims
- **Cloud Functions**: Server-side logic (Node.js or Dart)
- **Cloud Storage**: File uploads (receipts, images)

#### 4.2 Alternative Backend Stack (If Custom Backend Needed)
**Dart Backend (Shelf/Dart Frog)**
```yaml
# For custom Dart backend (if needed)
dependencies:
  shelf: ^1.4.1                      # Web server framework
  shelf_router: ^1.1.4               # HTTP routing
  shelf_cors_headers: ^0.1.3         # CORS handling
  
  # Database
  postgres: ^2.6.2                   # PostgreSQL client
  # OR
  mongo_dart: ^0.9.3                 # MongoDB client
  
  # Authentication & Security
  dart_jsonwebtoken: ^2.12.1         # JWT tokens
  crypto: ^3.0.3                     # Hashing and encryption
  
  # Utilities
  dotenv: ^4.2.0                     # Environment variables
  mailer: ^6.0.1                     # Email notifications
```

**Alternative: Node.js Backend**
```javascript
// If team prefers Node.js backend
"express": "^4.18.0"                    // Web framework
"firebase-admin": "^11.10.1"            // Firebase Admin SDK
"cors": "^2.8.5"                        // CORS handling
"helmet": "^7.0.0"                      // Security middleware
"jsonwebtoken": "^9.0.0"                // JWT tokens
"bcrypt": "^5.1.0"                      // Password hashing
"dotenv": "^16.3.0"                     // Environment variables
```

---

### 5. Database Design

#### 5.1 Firestore Collections Structure
```javascript
// Collections Structure
users/                          // User authentication data
├── {userId}/
    ├── role: string           // 'student', 'coach', 'head_coach'
    ├── email: string
    ├── name: string
    ├── centreId: string
    └── createdAt: timestamp

students/                       // Student profiles
├── {studentId}/
    ├── personalInfo: object
    ├── batchId: string
    ├── centreId: string
    ├── feeStatus: object
    └── metrics: object

attendance/                     // Daily attendance records
├── {date-centreId-batchId}/
    ├── date: timestamp
    ├── centreId: string
    ├── batchId: string
    ├── presentStudents: array
    └── markedBy: string

progress/                       // Student progress tracking
├── {studentId-month-year}/
    ├── studentId: string
    ├── month: number
    ├── year: number
    ├── technical: object
    ├── tactical: object
    ├── physical: object
    └── psychological: object

payments/                       // Fee management
├── {paymentId}/
    ├── studentId: string
    ├── amount: number
    ├── method: string
    ├── status: string
    └── timestamp: timestamp
```

#### 5.2 Local Database (SQLite/Hive for Offline)
**SQLite Structure**:
```sql
-- Key tables for offline functionality
CREATE TABLE offline_attendance (
    id INTEGER PRIMARY KEY,
    date TEXT,
    student_id TEXT,
    batch_id TEXT,
    centre_id TEXT,
    synced INTEGER DEFAULT 0,
    created_at TEXT
);

CREATE TABLE offline_progress (
    id INTEGER PRIMARY KEY,
    student_id TEXT,
    metrics TEXT, -- JSON string
    month INTEGER,
    year INTEGER,
    synced INTEGER DEFAULT 0,
    created_at TEXT
);
```

**Hive Box Structure (Alternative)**:
```dart
// Hive models for offline storage
@HiveType(typeId: 0)
class AttendanceRecord extends HiveObject {
  @HiveField(0)
  String date;
  
  @HiveField(1)
  String studentId;
  
  @HiveField(2)
  String batchId;
  
  @HiveField(3)
  String centreId;
  
  @HiveField(4)
  bool synced;
  
  AttendanceRecord({
    required this.date,
    required this.studentId,
    required this.batchId,
    required this.centreId,
    this.synced = false,
  });
}

@HiveType(typeId: 1)
class ProgressRecord extends HiveObject {
  @HiveField(0)
  String studentId;
  
  @HiveField(1)
  Map<String, dynamic> metrics;
  
  @HiveField(2)
  int month;
  
  @HiveField(3)
  int year;
  
  @HiveField(4)
  bool synced;
}
```

---

### 6. Authentication & Security

#### 6.1 Authentication Flow
**Firebase Auth with Flutter**
```dart
// Firebase Auth Configuration
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Email/Password for coaches and head coach
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }
  
  // Custom tokens for students (generated by head coach)
  Future<UserCredential?> signInWithCustomToken(String token) async {
    try {
      return await _auth.signInWithCustomToken(token);
    } catch (e) {
      print('Custom token error: $e');
      return null;
    }
  }
  
  // Role-based access using custom claims
  Future<Map<String, dynamic>?> getUserClaims() async {
    final user = _auth.currentUser;
    if (user != null) {
      final idTokenResult = await user.getIdTokenResult();
      return idTokenResult.claims;
    }
    return null;
  }
}
```

#### 6.2 Security Rules (Firestore)
```javascript
// Firestore Security Rules (same as before)
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Students can only read their own data
    match /students/{studentId} {
      allow read: if request.auth != null && 
        (request.auth.uid == studentId || 
         request.auth.token.role in ['coach', 'head_coach']);
    }
    
    // Coaches can modify assigned students only
    match /progress/{progressId} {
      allow write: if request.auth.token.role in ['coach', 'head_coach'];
    }
    
    // Head coach has full access
    match /{document=**} {
      allow read, write: if request.auth.token.role == 'head_coach';
    }
  }
}
```

#### 6.3 Security Packages
```yaml
# Security packages for Flutter
dependencies:
  # Secure storage
  flutter_secure_storage: ^9.0.0      # Encrypted key-value storage
  
  # Biometric authentication
  local_auth: ^2.1.6                  # Fingerprint/Face ID
  
  # Encryption
  crypto: ^3.0.3                      # Hashing and encryption
  encrypt: ^5.0.1                     # AES encryption
  
  # Device security
  device_info_plus: ^9.1.0            # Device information
  package_info_plus: ^4.2.0           # App information
```

---

### 7. Development Tools & Environment

#### 7.1 Development Environment
**Flutter Development Setup**
```yaml
# pubspec.yaml - dev dependencies
dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code quality
  flutter_lints: ^3.0.0               # Official Flutter linting rules
  very_good_analysis: ^5.1.0          # Additional strict linting
  
  # Testing
  mockito: ^5.4.2                     # Mocking for tests
  build_runner: ^2.4.7                # Code generation
  
  # Code generation
  json_annotation: ^4.8.1             # JSON serialization
  hive_generator: ^2.0.1              # Hive model generation (if using Hive)
  
  # Development tools
  flutter_launcher_icons: ^0.13.1     # App icon generation
  flutter_native_splash: ^2.3.2       # Splash screen generation
```

**Flutter SDK Requirements**:
- Flutter SDK 3.13.0 or higher
- Dart SDK 3.1.0 or higher
- Android SDK (API level 21+)
- Xcode 14+ (for iOS development)

#### 7.2 Code Quality Tools
**Analysis Options**
```yaml
# analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

linter:
  rules:
    # Custom rules for the project
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    avoid_redundant_argument_values: true
    prefer_final_locals: true
    
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
```

**VS Code Extensions (Recommended)**:
- Dart
- Flutter
- Flutter Widget Snippets
- Error Lens
- GitLens

#### 7.3 Testing Framework
```yaml
# Testing dependencies
dev_dependencies:
  # Unit and Widget Testing
  flutter_test:
    sdk: flutter
  mockito: ^5.4.2
  build_runner: ^2.4.7
  
  # Integration Testing
  integration_test:
    sdk: flutter
  
  # Additional testing utilities
  patrol: ^2.6.0                      # Advanced integration testing
  golden_toolkit: ^0.15.0             # Golden file testing
```

**Test Structure**:
```dart
// Example test structure
test/
├── unit/
│   ├── models/
│   ├── services/
│   └── utils/
├── widget/
│   ├── screens/
│   └── widgets/
└── integration/
    ├── auth_test.dart
    ├── attendance_test.dart
    └── progress_test.dart
```

---

### 8. Third-Party Services

#### 8.1 Analytics & Monitoring
```yaml
# Analytics and monitoring packages
dependencies:
  # Firebase Analytics
  firebase_analytics: ^10.5.1
  firebase_crashlytics: ^3.3.7
  firebase_performance: ^0.9.2+8
  
  # Additional monitoring
  sentry_flutter: ^7.9.0              # Error tracking (alternative)
```

**Implementation Example**:
```dart
// Analytics service
class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  
  static Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }
  
  static Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }
  
  static Future<void> recordError(dynamic exception, StackTrace? stack) async {
    await _crashlytics.recordError(exception, stack);
  }
}
```

#### 8.2 Notifications
```yaml
# Push and local notifications
dependencies:
  # Firebase messaging
  firebase_messaging: ^14.6.9
  
  # Local notifications
  flutter_local_notifications: ^16.1.0
  
  # Notification permissions
  permission_handler: ^11.0.1
```

**Notification Setup**:
```dart
// Notification service
class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  
  static Future<void> initialize() async {
    // Request permission
    await _messaging.requestPermission();
    
    // Initialize local notifications
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    
    await _localNotifications.initialize(initializationSettings);
  }
}
```

#### 8.3 Payment Integration (Future Phase)
```yaml
# Payment gateways (India-specific)
dependencies:
  # Razorpay
  razorpay_flutter: ^1.3.5
  
  # UPI payments
  upi_india: ^3.4.0
  
  # In-app purchases (if needed)
  in_app_purchase: ^3.1.11
  
  # QR code scanning (for payment verification)
  mobile_scanner: ^3.4.1
```

---

### 9. Performance & Optimization

#### 9.1 Build Optimization
**Flutter Build Configuration**
```yaml
# pubspec.yaml - Build optimization
flutter:
  uses-material-design: true
  
  # Asset optimization
  assets:
    - assets/images/
    - assets/icons/
  
  # Font optimization
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
        - asset: assets/fonts/Roboto-Bold.ttf
          weight: 700

# Build commands for optimization
# flutter build apk --release --split-per-abi    # Smaller APKs
# flutter build ios --release                    # iOS release build
# flutter build web --release                    # Web build (if needed)
```

**Build Configuration Files**:
```dart
// android/app/build.gradle optimizations
android {
    compileSdkVersion 34
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            useProguard true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
    
    // Enable R8 code shrinking
    buildFeatures {
        shrinkResources true
    }
}
```

#### 9.2 Image and Asset Optimization
```yaml
# Image handling packages
dependencies:
  # Optimized image loading
  cached_network_image: ^3.3.0        # Image caching
  image: ^4.1.3                       # Image processing
  
  # Image compression
  flutter_image_compress: ^2.0.4      # Compress images
  
  # SVG support
  flutter_svg: ^2.0.7                 # SVG rendering
```

**Image Optimization Example**:
```dart
// Optimized image widget
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  
  const OptimizedImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
    );
  }
}
```

#### 9.3 Performance Monitoring
```yaml
# Performance utilities
dependencies:
  # Performance monitoring
  firebase_performance: ^0.9.2+8
  
  # Memory and CPU profiling (dev only)
dev_dependencies:
  # Development profiling
  flutter_driver:
    sdk: flutter
```

**Performance Monitoring Setup**:
```dart
// Performance service
class PerformanceService {
  static final FirebasePerformance _performance = FirebasePerformance.instance;
  
  static Future<Trace> startTrace(String name) async {
    final trace = _performance.newTrace(name);
    await trace.start();
    return trace;
  }
  
  static Future<void> stopTrace(Trace trace) async {
    await trace.stop();
  }
  
  // Custom metrics
  static Future<void> recordMetric(String name, int value) async {
    final trace = _performance.newTrace('custom_metrics');
    await trace.start();
    trace.setMetric(name, value);
    await trace.stop();
  }
}
```
```javascript
// Performance utilities
"@react-native-community/hooks": "^3.0.0"
"react-native-performance": "^5.1.0"
"why-did-you-render": "^7.0.0"  // Development only
```

---

### 10. Deployment & Distribution

#### 10.1 Build Configuration
```json
// package.json scripts
{
  "scripts": {
    "build:ios": "react-native bundle --platform ios --dev false",
    "build:android": "react-native bundle --platform android --dev false",
    "ios:release": "react-native run-ios --configuration Release",
    "android:release": "react-native run-android --variant release"
  }
}
```

#### 10.2 Distribution Platforms
- **iOS**: TestFlight (internal testing) → App Store (if needed)
- **Android**: Internal APK distribution → Google Play (future)
- **Updates**: CodePush (Microsoft) for over-the-air updates

#### 10.3 CI/CD (Simplified for Interns)
```yaml
# GitHub Actions (basic)
name: Build and Test
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm install
      - run: npm test
      - run: npm run build
```

---

### 11. Development Phases & Technology Priorities

#### Phase 1 (Months 1-2) - MVP
**Focus**: Core functionality with minimal complexity
```javascript
// Essential packages only
- React Native + basic navigation
- Firebase Auth + Firestore
- Simple forms and local storage
- Basic UI components
```

#### Phase 2 (Months 3-4) - Enhanced Features
**Focus**: Visual improvements and better UX
```javascript
// Add visualization and better UX
- Chart libraries for progress tracking
- Enhanced UI components
- Offline synchronization
- Push notifications
```

#### Phase 3 (Months 5-6) - Advanced Features
**Focus**: Polish and advanced functionality
```javascript
// Advanced features
- Payment integration
- Advanced analytics
- Performance optimization
- Comprehensive testing
```

---

### 12. Resource Requirements

#### 12.1 Development Environment
- **Hardware**: Mac (for iOS development) + Android device/emulator
- **Software**: Xcode, Android Studio, VS Code
- **Accounts**: Apple Developer Account, Google Play Console, Firebase project

#### 12.2 Cloud Services Budget (Monthly)
- **Firebase**: Free tier initially, ~$25-50/month at scale
- **Cloud Storage**: ~$5-10/month
- **Push Notifications**: Free (Firebase)
- **Analytics**: Free (Firebase Analytics)

#### 12.3 Third-Party Services
- **Payment Gateway**: Transaction-based fees (2-3%)
- **Domain & SSL**: ~$10-15/year
- **Additional Services**: Minimal for MVP

---

### 13. Risk Mitigation & Alternatives

#### 13.1 Technical Risks & Solutions
| Risk | Impact | Mitigation |
|------|--------|------------|
| Limited React Native experience | High | Use Expo CLI, extensive documentation |
| Firebase complexity | Medium | Start with basic features, gradual adoption |
| Offline sync issues | High | Simple sync strategy, conflict resolution |
| iPad compatibility | Medium | Test on actual devices early |

#### 13.2 Alternative Technology Choices
- **Frontend**: Flutter (if team familiar), Progressive Web App
- **Backend**: Supabase (Firebase alternative), AWS Amplify
- **Database**: MongoDB Atlas, PostgreSQL (Supabase)
- **Authentication**: Auth0, AWS Cognito

---

### 14. Success Metrics & Monitoring

#### 14.1 Technical Metrics
- App crash rate < 1%
- App launch time < 3 seconds
- Data sync success rate > 95%
- Offline functionality uptime > 99%

#### 14.2 Monitoring Tools
```javascript
// Monitoring stack
"@react-native-firebase/crashlytics": "^18.3.0"  // Crash reporting
"@react-native-firebase/analytics": "^18.3.0"    // User analytics
"@react-native-firebase/perf": "^18.3.0"         // Performance monitoring
```

---

This technical specification provides a comprehensive roadmap for the Petra Sports Academy coaching app, balancing functionality requirements with the constraints of intern-level development resources. The stack emphasizes proven, well-documented technologies with strong community support to maximize the chances of successful implementation.
