import 'package:flutter/material.dart';
import '../models/student_model.dart';

class StudentService extends ChangeNotifier {
  final List<Student> _students = Student.getDemoStudents();
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Student> get students => _students;

  // Get all students
  List<Student> getAllStudents() {
    return _students;
  }

  // Get students by batch
  List<Student> getStudentsByBatch(String batchId) {
    return _students.where((student) => student.batchId == batchId).toList();
  }

  // Get students by center
  List<Student> getStudentsByCenter(String center) {
    return _students.where((student) => student.center == center).toList();
  }

  // Get student by ID
  Student? getStudentById(String id) {
    try {
      return _students.firstWhere((student) => student.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new student
  Future<bool> addStudent(Student student) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _students.add(student);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update student
  Future<bool> updateStudent(Student updatedStudent) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final index = _students.indexWhere((s) => s.id == updatedStudent.id);
      if (index != -1) {
        _students[index] = updatedStudent;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete student (soft delete by setting isActive to false)
  Future<bool> deleteStudent(String studentId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final student = getStudentById(studentId);
      if (student != null) {
        final updatedStudent = student.copyWith(isActive: false);
        return await updateStudent(updatedStudent);
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search students by name
  List<Student> searchStudents(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _students.where((student) {
      return student.name.toLowerCase().contains(lowercaseQuery) ||
          student.id.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get active students
  List<Student> getActiveStudents() {
    return _students.where((student) => student.isActive).toList();
  }

  // Get inactive students
  List<Student> getInactiveStudents() {
    return _students.where((student) => !student.isActive).toList();
  }

  // Get students by age range
  List<Student> getStudentsByAgeRange(int minAge, int maxAge) {
    return _students.where((student) {
      final age = student.age;
      return age >= minAge && age <= maxAge;
    }).toList();
  }
} 