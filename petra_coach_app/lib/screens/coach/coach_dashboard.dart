import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../models/user_model.dart';
import '../../widgets/dashboard_scaffold.dart';
import '../../widgets/stat_card.dart';

class CoachDashboard extends StatelessWidget {
  final UserModel user;

  const CoachDashboard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      user: user,
      title: 'Coach Dashboard',
      children: [
        Text(
          'Welcome back, Coach ${user.name}!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),

        // Quick Actions
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        'Take Attendance',
                        Icons.how_to_reg,
                        AppTheme.primaryColor,
                        () {
                          // TODO: Navigate to take attendance
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        'Assess Progress',
                        Icons.assessment,
                        AppTheme.secondaryColor,
                        () {
                          // TODO: Navigate to assess progress
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Batch Stats
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            StatCard(
              title: 'Total Students',
              value: '45',
              icon: Icons.people,
              color: AppTheme.primaryColor,
            ),
            StatCard(
              title: 'Today\'s Attendance',
              value: '92%',
              icon: Icons.calendar_today,
              color: AppTheme.successColor,
            ),
            StatCard(
              title: 'Pending Assessments',
              value: '8',
              icon: Icons.assignment_late,
              color: AppTheme.warningColor,
            ),
            StatCard(
              title: 'Active Batches',
              value: '3',
              icon: Icons.groups,
              color: AppTheme.secondaryColor,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Today's Schedule
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Schedule',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildScheduleItem(
                  context,
                  'Morning Batch',
                  '6:00 AM - 8:00 AM',
                  'Stadium of Hope, Khanapur',
                  '25 students',
                ),
                const Divider(),
                _buildScheduleItem(
                  context,
                  'U-13 Batch',
                  '4:00 PM - 6:00 PM',
                  'Stadium of Hope, Khanapur',
                  '18 students',
                ),
                const Divider(),
                _buildScheduleItem(
                  context,
                  'Evening Batch',
                  '6:30 PM - 8:30 PM',
                  'Petra Sports Academy, Aziz Nagar',
                  '22 students',
                ),
              ],
            ),
          ),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new assessment or attendance
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(
    BuildContext context,
    String batchName,
    String time,
    String location,
    String studentCount,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.schedule,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  batchName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  studentCount,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 