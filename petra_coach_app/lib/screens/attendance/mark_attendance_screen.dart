import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/attendance_model.dart';
import '../../services/attendance_service.dart';

class MarkAttendanceScreen extends StatefulWidget {
  final String coachId;

  const MarkAttendanceScreen({Key? key, required this.coachId}) : super(key: key);

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  late DateTime selectedDate;
  String? selectedBatchId;
  final Map<String, bool> studentAttendance = {};

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
      ),
      body: Consumer<AttendanceService>(
        builder: (context, attendanceService, child) {
          final batches = attendanceService.getBatchesForCoach(widget.coachId);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date selector
                Row(
                  children: [
                    const Text('Date: ', style: TextStyle(fontSize: 16)),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Batch selector
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Batch',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedBatchId,
                  items: batches.map((batch) {
                    return DropdownMenuItem(
                      value: batch.id,
                      child: Text('${batch.name} - ${batch.center}'),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedBatchId = value;
                      // Reset attendance when batch changes
                      studentAttendance.clear();
                      if (value != null) {
                        final batch = batches.firstWhere((b) => b.id == value);
                        for (final studentId in batch.studentIds) {
                          studentAttendance[studentId] = true; // Default to present
                        }
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Student list with attendance toggles
                if (selectedBatchId != null) ...[
                  const Text(
                    'Mark Attendance:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: studentAttendance.length,
                      itemBuilder: (context, index) {
                        final studentId = studentAttendance.keys.elementAt(index);
                        return Card(
                          child: ListTile(
                            title: Text('Student $studentId'),
                            trailing: Switch(
                              value: studentAttendance[studentId] ?? true,
                              onChanged: (bool value) {
                                setState(() {
                                  studentAttendance[studentId] = value;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: attendanceService.isLoading
                          ? null
                          : () async {
                              if (selectedBatchId == null) return;

                              final success = await attendanceService.markBatchAttendance(
                                selectedBatchId!,
                                selectedDate,
                                studentAttendance,
                                widget.coachId,
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? 'Attendance marked successfully!'
                                          : 'Failed to mark attendance',
                                    ),
                                    backgroundColor:
                                        success ? Colors.green : Colors.red,
                                  ),
                                );
                              }
                            },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: attendanceService.isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Submit Attendance',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
} 