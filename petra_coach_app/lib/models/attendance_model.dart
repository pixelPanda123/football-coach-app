class AttendanceRecord {
  final String studentId;
  final String batchId;
  final String centerId;
  final DateTime date;
  final bool isPresent;
  final String? notes;
  final String markedBy;
  final DateTime markedAt;
  final Map<String, dynamic>? location;

  AttendanceRecord({
    required this.studentId,
    required this.batchId,
    required this.centerId,
    required this.date,
    required this.isPresent,
    this.notes,
    required this.markedBy,
    required this.markedAt,
    this.location,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      studentId: json['studentId'] as String,
      batchId: json['batchId'] as String,
      centerId: json['centerId'] as String,
      date: DateTime.parse(json['date'] as String),
      isPresent: json['isPresent'] as bool,
      notes: json['notes'] as String?,
      markedBy: json['markedBy'] as String,
      markedAt: DateTime.parse(json['markedAt'] as String),
      location: json['location'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'batchId': batchId,
      'centerId': centerId,
      'date': date.toIso8601String(),
      'isPresent': isPresent,
      'notes': notes,
      'markedBy': markedBy,
      'markedAt': markedAt.toIso8601String(),
      'location': location,
    };
  }
}

class AttendanceStats {
  final String studentId;
  final String batchId;
  final int totalClasses;
  final int presentCount;
  final int absentCount;
  final double attendancePercentage;
  final List<DateTime> absentDates;

  AttendanceStats({
    required this.studentId,
    required this.batchId,
    required this.totalClasses,
    required this.presentCount,
    required this.absentCount,
    required this.attendancePercentage,
    required this.absentDates,
  });

  factory AttendanceStats.fromRecords(List<AttendanceRecord> records) {
    final presentCount = records.where((record) => record.isPresent).length;
    final totalClasses = records.length;
    final absentCount = totalClasses - presentCount;
    final absentDates = records
        .where((record) => !record.isPresent)
        .map((record) => record.date)
        .toList();

    return AttendanceStats(
      studentId: records.first.studentId,
      batchId: records.first.batchId,
      totalClasses: totalClasses,
      presentCount: presentCount,
      absentCount: absentCount,
      attendancePercentage: totalClasses > 0 ? (presentCount / totalClasses) * 100 : 0,
      absentDates: absentDates,
    );
  }

  bool get hasLowAttendance => attendancePercentage < 70;
  bool get hasConsecutiveAbsences {
    if (absentDates.length < 3) return false;
    
    absentDates.sort();
    for (int i = 0; i < absentDates.length - 2; i++) {
      final first = absentDates[i];
      final second = absentDates[i + 1];
      final third = absentDates[i + 2];
      
      if (second.difference(first).inDays == 1 && 
          third.difference(second).inDays == 1) {
        return true;
      }
    }
    return false;
  }
} 