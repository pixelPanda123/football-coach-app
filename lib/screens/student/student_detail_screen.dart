import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student_model.dart';
import '../../services/student_service.dart';
import '../attendance/attendance_history_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  final String studentId;
  final bool isCoach;

  const StudentDetailScreen({
    Key? key,
    required this.studentId,
    this.isCoach = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentService>(
      builder: (context, studentService, child) {
        final student = studentService.getStudentById(studentId);

        if (student == null) {
          return const Scaffold(
            body: Center(
              child: Text('Student not found'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(student.name),
            actions: [
              if (isCoach)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Navigate to edit screen
                  },
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student photo and basic info
                Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: student.photoUrl != null
                            ? NetworkImage(student.photoUrl!)
                            : null,
                        child: student.photoUrl == null
                            ? Text(
                                student.name[0],
                                style: const TextStyle(fontSize: 36),
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        student.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        'Age: ${student.age}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Student details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailSection(
                        context,
                        'Personal Information',
                        [
                          _buildDetailRow('Date of Birth',
                              '${student.dateOfBirth.day}/${student.dateOfBirth.month}/${student.dateOfBirth.year}'),
                          _buildDetailRow('Batch', student.batchId),
                          _buildDetailRow('Center', student.center),
                          _buildDetailRow('Phone', student.phoneNumber),
                          _buildDetailRow('Address', student.address),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildDetailSection(
                        context,
                        'Parent/Guardian Information',
                        [
                          _buildDetailRow('Name', student.parentName),
                          _buildDetailRow('Phone', student.parentPhone),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildDetailSection(
                        context,
                        'Academy Information',
                        [
                          _buildDetailRow('Joining Date',
                              '${student.joiningDate.day}/${student.joiningDate.month}/${student.joiningDate.year}'),
                          _buildDetailRow('Status',
                              student.isActive ? 'Active' : 'Inactive'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Quick actions
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AttendanceHistoryScreen(
                                  studentId: student.id,
                                  isCoach: isCoach,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('View Attendance'),
                        ),
                      ),
                      if (isCoach) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Navigate to progress screen
                            },
                            icon: const Icon(Icons.trending_up),
                            label: const Text('View Progress'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
} 