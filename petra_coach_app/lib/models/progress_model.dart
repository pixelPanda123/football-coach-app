class SkillMetric {
  final String name;
  final int score; // 1-10 scale
  final String? notes;

  SkillMetric({
    required this.name,
    required this.score,
    this.notes,
  });

  factory SkillMetric.fromJson(Map<String, dynamic> json) {
    return SkillMetric(
      name: json['name'] as String,
      score: json['score'] as int,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'score': score,
      'notes': notes,
    };
  }
}

class PillarProgress {
  final List<SkillMetric> metrics;
  final DateTime assessmentDate;
  final String assessedBy;

  PillarProgress({
    required this.metrics,
    required this.assessmentDate,
    required this.assessedBy,
  });

  factory PillarProgress.fromJson(Map<String, dynamic> json) {
    return PillarProgress(
      metrics: (json['metrics'] as List<dynamic>)
          .map((e) => SkillMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      assessmentDate: DateTime.parse(json['assessmentDate'] as String),
      assessedBy: json['assessedBy'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metrics': metrics.map((e) => e.toJson()).toList(),
      'assessmentDate': assessmentDate.toIso8601String(),
      'assessedBy': assessedBy,
    };
  }

  double get averageScore {
    if (metrics.isEmpty) return 0;
    return metrics.map((e) => e.score).reduce((a, b) => a + b) / metrics.length;
  }
}

class StudentProgress {
  final String studentId;
  final bool isGoalkeeper;
  final Map<String, PillarProgress> technical;
  final Map<String, PillarProgress> tactical;
  final Map<String, PillarProgress> physical;
  final Map<String, PillarProgress> psychological;

  StudentProgress({
    required this.studentId,
    required this.isGoalkeeper,
    required this.technical,
    required this.tactical,
    required this.physical,
    required this.psychological,
  });

  factory StudentProgress.fromJson(Map<String, dynamic> json) {
    Map<String, PillarProgress> _convertToPillarProgress(Map<String, dynamic> data) {
      return data.map(
        (key, value) => MapEntry(
          key,
          PillarProgress.fromJson(value as Map<String, dynamic>),
        ),
      );
    }

    return StudentProgress(
      studentId: json['studentId'] as String,
      isGoalkeeper: json['isGoalkeeper'] as bool,
      technical: _convertToPillarProgress(json['technical'] as Map<String, dynamic>),
      tactical: _convertToPillarProgress(json['tactical'] as Map<String, dynamic>),
      physical: _convertToPillarProgress(json['physical'] as Map<String, dynamic>),
      psychological: _convertToPillarProgress(json['psychological'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'isGoalkeeper': isGoalkeeper,
      'technical': technical.map((key, value) => MapEntry(key, value.toJson())),
      'tactical': tactical.map((key, value) => MapEntry(key, value.toJson())),
      'physical': physical.map((key, value) => MapEntry(key, value.toJson())),
      'psychological': psychological.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  Map<String, double> getLatestScores() {
    String getLatestDate(Map<String, PillarProgress> pillar) {
      return pillar.keys.reduce((a, b) => a.compareTo(b) > 0 ? a : b);
    }

    return {
      'technical': technical[getLatestDate(technical)]?.averageScore ?? 0,
      'tactical': tactical[getLatestDate(tactical)]?.averageScore ?? 0,
      'physical': physical[getLatestDate(physical)]?.averageScore ?? 0,
      'psychological': psychological[getLatestDate(psychological)]?.averageScore ?? 0,
    };
  }
} 