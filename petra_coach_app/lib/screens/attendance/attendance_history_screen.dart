import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/attendance_model.dart';
import '../../services/attendance_service.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  final String studentId;
  final bool isCoach;

  const AttendanceHistoryScreen({
    Key? key,
    required this.studentId,
    this.isCoach = false,
  }) : super(key: key);

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showDateFilterDialog(context),
          ),
        ],
      ),
      body: Consumer<AttendanceService>(
        builder: (context, attendanceService, child) {
          final attendanceHistory = attendanceService.getStudentAttendanceHistory(widget.studentId);
          final percentage = attendanceService.getStudentAttendancePercentage(
            widget.studentId,
            startDate: startDate,
            endDate: endDate,
          );

          return Column(
            children: [
              // Attendance percentage card
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Attendance Percentage',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: percentage >= 70 ? Colors.green : Colors.red,
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

              // Attendance history list
              Expanded(
                child: attendanceHistory.isEmpty
                    ? const Center(
                        child: Text('No attendance records found'),
                      )
                    : ListView.builder(
                        itemCount: attendanceHistory.length,
                        itemBuilder: (context, index) {
                          final record = attendanceHistory[index];
                          final date = record.date;

                          if (startDate != null &&
                              endDate != null &&
                              (date.isBefore(startDate!) || date.isAfter(endDate!))) {
                            return const SizedBox.shrink();
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: Icon(
                                record.isPresent
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: record.isPresent ? Colors.green : Colors.red,
                              ),
                              title: Text(_formatDate(record.date)),
                              subtitle: Text(record.batchId),
                              trailing: widget.isCoach
                                  ? Text('Marked by: ${record.markedById}')
                                  : null,
                            ),
                          );
                        },
                      ),
              ),
            ],
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