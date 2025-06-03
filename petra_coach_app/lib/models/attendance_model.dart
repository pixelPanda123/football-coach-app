class AttendanceRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String batchId;
  final DateTime date;
  final bool isPresent;
  final String markedById; // Coach or Head Coach ID who marked attendance

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.batchId,
    required this.date,
    required this.isPresent,
    required this.markedById,
  });

  // Calculate attendance percentage for a list of records
  static double calculateAttendancePercentage(List<AttendanceRecord> records) {
    if (records.isEmpty) return 0;
    final presentDays = records.where((record) => record.isPresent).length;
    return (presentDays / records.length) * 100;
  }

  // Create a copy of the record with some fields updated
  AttendanceRecord copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? batchId,
    DateTime? date,
    bool? isPresent,
    String? markedById,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      batchId: batchId ?? this.batchId,
      date: date ?? this.date,
      isPresent: isPresent ?? this.isPresent,
      markedById: markedById ?? this.markedById,
    );
  }
}

// Model to represent a batch for attendance
class Batch {
  final String id;
  final String name;
  final String center;
  final List<String> studentIds;
  final String coachId;

  const Batch({
    required this.id,
    required this.name,
    required this.center,
    required this.studentIds,
    required this.coachId,
  });

  // Demo batches for testing
  static List<Batch> getDemoBatches() {
    return [
      Batch(
        id: 'batch1',
        name: 'Under-10',
        center: 'Stadium of Hope, Khanapur',
        studentIds: List.generate(20, (index) => 'student_${index + 1}'),
        coachId: 'coach1',
      ),
      Batch(
        id: 'batch2',
        name: 'Under-13',
        center: 'Stadium of Hope, Khanapur',
        studentIds: List.generate(18, (index) => 'student_${index + 21}'),
        coachId: 'coach1',
      ),
      Batch(
        id: 'batch3',
        name: 'Morning Batch',
        center: 'Petra Sports Academy, Tellapur',
        studentIds: List.generate(15, (index) => 'student_${index + 39}'),
        coachId: 'coach2',
      ),
    ];
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