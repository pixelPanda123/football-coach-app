class AppConstants {
  // Training Centers
  static const Map<String, String> centers = {
    'khanapur': 'Stadium of Hope, Khanapur',
    'tellapur': 'Petra Sports Academy, Tellapur',
    'aziz_nagar': 'Petra Sports Academy, Aziz Nagar',
  };

  // Age Groups
  static const Map<String, String> ageGroups = {
    'u10': 'Under-10',
    'u13': 'Under-13',
    'u15': 'Under-15',
    'u17': 'Under-17',
    'mixed': 'Mixed Morning',
  };

  // Skill Metrics for Field Players
  static const Map<String, List<String>> fieldPlayerMetrics = {
    'technical': [
      'Dribbling',
      'Receiving',
      'Passing',
      'Ball Control',
      'Turning',
      '1v1 Attacking',
      '1v1 Defending',
      'Crossing',
      'Finishing',
      'Heading',
    ],
    'tactical': [
      'Positioning',
      'Offensive Behavior',
      'Defensive Behavior',
      'Decision Making',
      'Transition AD & DA',
      'Off-ball Movement',
    ],
    'physical': [
      'Agility',
      'Reaction Time',
      'Endurance',
      'Footwork',
      'Balance & Coordination',
      'Strength',
    ],
    'psychological': [
      'Confidence',
      'Discipline',
      'Concentration',
      'Competitiveness',
      'Communication',
      'Leadership',
      'Creativity',
      'Resilience',
    ],
  };

  // Skill Metrics for Goalkeepers
  static const Map<String, List<String>> goalkeeperMetrics = {
    'technical': [
      'Shot Stopping',
      'Diving',
      'Ball Handling',
      'Distribution',
      'Breakaway 1v1',
      'Dealing with Crosses',
    ],
    'tactical': [
      'Decision Making',
      'Off-ball Movement',
      'Positioning & Angles',
      'Transition',
      'Set Pieces',
    ],
    'physical': [
      'Agility',
      'Reaction Time',
      'Footwork',
      'Strength',
      'Endurance',
      'Balance & Coordination',
    ],
    'psychological': [
      'Confidence',
      'Discipline',
      'Concentration',
      'Competitiveness',
      'Communication',
      'Leadership',
      'Creativity',
      'Resilience',
    ],
  };

  // Coach Assignments
  static const Map<String, List<String>> coachAssignments = {
    'nova': ['mixed_khanapur', 'u13_khanapur', 'mixed_aziz_nagar'],
    'barwin': ['u10_khanapur', 'mixed_tellapur', 'mixed_aziz_nagar'],
    'srinu': ['u15_khanapur', 'u17_khanapur'],
    'matthew': ['all'], // Performance analysis access
  };

  // Attendance Settings
  static const double lowAttendanceThreshold = 70.0;
  static const int consecutiveAbsenceThreshold = 3;

  // Progress Assessment
  static const int progressAssessmentInterval = 30; // days
  static const int minScoreValue = 1;
  static const int maxScoreValue = 10;

  // Fee Settings
  static const int paymentReminderDays = 5; // days before due date
  static const double latePaymentFeePercentage = 5.0;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
} 