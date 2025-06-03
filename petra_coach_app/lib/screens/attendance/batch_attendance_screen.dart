import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/attendance_model.dart';
import '../../services/attendance_service.dart';
import 'attendance_history_screen.dart';

class BatchAttendanceScreen extends StatefulWidget {
  final String coachId;

  const BatchAttendanceScreen({Key? key, required this.coachId}) : super(key: key);

  @override
  State<BatchAttendanceScreen> createState() => _BatchAttendanceScreenState();
}

class _BatchAttendanceScreenState extends State<BatchAttendanceScreen> {
  String? selectedBatchId;
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batch Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showDateFilterDialog(context),
          ),
        ],
      ),
      body: Consumer<AttendanceService>(
        builder: (context, attendanceService, child) {
          final batches = attendanceService.getBatchesForCoach(widget.coachId);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    });
                  },
                ),
                const SizedBox(height: 16),

                if (selectedBatchId != null) ...[
                  // Batch attendance percentage card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Batch Attendance Percentage',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${attendanceService.getBatchAttendancePercentage(
                              selectedBatchId!,
                              startDate: startDate,
                              endDate: endDate,
                            ).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (startDate != null && endDate != null)
                            Text(
                              'From ${_formatDate(startDate!)} to ${_formatDate(endDate!)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Student list with attendance percentages
                  Expanded(
                    child: ListView.builder(
                      itemCount: batches
                          .firstWhere((b) => b.id == selectedBatchId)
                          .studentIds
                          .length,
                      itemBuilder: (context, index) {
                        final studentId = batches
                            .firstWhere((b) => b.id == selectedBatchId)
                            .studentIds[index];
                        final percentage = attendanceService.getStudentAttendancePercentage(
                          studentId,
                          startDate: startDate,
                          endDate: endDate,
                        );

                        return Card(
                          child: ListTile(
                            title: Text('Student $studentId'),
                            subtitle: Text('Attendance: ${percentage.toStringAsFixed(1)}%'),
                            trailing: Icon(
                              percentage >= 70
                                  ? Icons.check_circle
                                  : Icons.warning,
                              color: percentage >= 70 ? Colors.green : Colors.orange,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AttendanceHistoryScreen(
                                    studentId: studentId,
                                    isCoach: true,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _showDateFilterDialog(BuildContext context) async {
    final initialStartDate = startDate ?? DateTime.now().subtract(const Duration(days: 30));
    final initialEndDate = endDate ?? DateTime.now();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Date'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Start Date'),
              subtitle: Text(startDate != null ? _formatDate(startDate!) : 'Not set'),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: initialStartDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => startDate = picked);
                }
              },
            ),
            ListTile(
              title: const Text('End Date'),
              subtitle: Text(endDate != null ? _formatDate(endDate!) : 'Not set'),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: initialEndDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => endDate = picked);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                startDate = null;
                endDate = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
} 