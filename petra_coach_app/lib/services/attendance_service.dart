import 'package:flutter/material.dart';
import '../models/attendance_model.dart';

class AttendanceService extends ChangeNotifier {
  final Map<String, List<AttendanceRecord>> _attendanceRecords = {};
  final List<Batch> _batches = Batch.getDemoBatches();
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Batch> get batches => _batches;

  // Get attendance records for a specific batch and date
  List<AttendanceRecord> getAttendanceForBatchAndDate(String batchId, DateTime date) {
    final key = '${batchId}_${date.toIso8601String().split('T')[0]}';
    return _attendanceRecords[key] ?? [];
  }

  // Mark attendance for multiple students
  Future<bool> markBatchAttendance(
    String batchId,
    DateTime date,
    Map<String, bool> studentAttendance,
    String markedById,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final key = '${batchId}_${date.toIso8601String().split('T')[0]}';
      final records = studentAttendance.entries.map((entry) {
        return AttendanceRecord(
          id: '${entry.key}_${date.toIso8601String().split('T')[0]}',
          studentId: entry.key,
          studentName: 'Student ${entry.key}', // In real app, get from student service
          batchId: batchId,
          date: date,
          isPresent: entry.value,
          markedById: markedById,
        );
      }).toList();

      _attendanceRecords[key] = records;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get attendance percentage for a student
  double getStudentAttendancePercentage(String studentId, {DateTime? startDate, DateTime? endDate}) {
    final allRecords = _attendanceRecords.values
        .expand((records) => records)
        .where((record) => record.studentId == studentId)
        .where((record) {
          if (startDate == null || endDate == null) return true;
          return record.date.isAfter(startDate) && record.date.isBefore(endDate);
        })
        .toList();

    return AttendanceRecord.calculateAttendancePercentage(allRecords);
  }

  // Get batch attendance percentage
  double getBatchAttendancePercentage(String batchId, {DateTime? startDate, DateTime? endDate}) {
    final allRecords = _attendanceRecords.values
        .expand((records) => records)
        .where((record) => record.batchId == batchId)
        .where((record) {
          if (startDate == null || endDate == null) return true;
          return record.date.isAfter(startDate) && record.date.isBefore(endDate);
        })
        .toList();

    return AttendanceRecord.calculateAttendancePercentage(allRecords);
  }

  // Get batches for a coach
  List<Batch> getBatchesForCoach(String coachId) {
    return _batches.where((batch) => batch.coachId == coachId).toList();
  }

  // Get student attendance history
  List<AttendanceRecord> getStudentAttendanceHistory(String studentId) {
    return _attendanceRecords.values
        .expand((records) => records)
        .where((record) => record.studentId == studentId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort by date descending
  }
} 