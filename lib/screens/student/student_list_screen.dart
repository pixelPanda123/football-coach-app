import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student_model.dart';
import '../../services/student_service.dart';
import 'student_detail_screen.dart';

class StudentListScreen extends StatefulWidget {
  final bool isCoach;

  const StudentListScreen({Key? key, this.isCoach = false}) : super(key: key);

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  String _searchQuery = '';
  bool _showInactive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          if (widget.isCoach)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // TODO: Navigate to add student screen
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search students...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                if (widget.isCoach) ...[
                  const SizedBox(width: 8),
                  ToggleButtons(
                    isSelected: [!_showInactive, _showInactive],
                    onPressed: (index) {
                      setState(() {
                        _showInactive = index == 1;
                      });
                    },
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Active'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Inactive'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Student list
          Expanded(
            child: Consumer<StudentService>(
              builder: (context, studentService, child) {
                List<Student> students;
                if (_searchQuery.isEmpty) {
                  students = _showInactive
                      ? studentService.getInactiveStudents()
                      : studentService.getActiveStudents();
                } else {
                  students = studentService.searchStudents(_searchQuery);
                  if (!_showInactive) {
                    students = students.where((s) => s.isActive).toList();
                  }
                }

                if (students.isEmpty) {
                  return const Center(
                    child: Text('No students found'),
                  );
                }

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: student.photoUrl != null
                              ? NetworkImage(student.photoUrl!)
                              : null,
                          child: student.photoUrl == null
                              ? Text(student.name[0])
                              : null,
                        ),
                        title: Text(student.name),
                        subtitle: Text(
                          'Age: ${student.age} | Batch: ${student.batchId}',
                        ),
                        trailing: widget.isCoach
                            ? PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  PopupMenuItem(
                                    value: 'status',
                                    child: Text(
                                      student.isActive
                                          ? 'Mark Inactive'
                                          : 'Mark Active',
                                    ),
                                  ),
                                ],
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    // TODO: Navigate to edit screen
                                  } else if (value == 'status') {
                                    final updatedStudent = student.copyWith(
                                      isActive: !student.isActive,
                                    );
                                    await studentService
                                        .updateStudent(updatedStudent);
                                  }
                                },
                              )
                            : null,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentDetailScreen(
                                studentId: student.id,
                                isCoach: widget.isCoach,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 