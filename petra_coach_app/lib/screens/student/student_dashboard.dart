import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/theme.dart';
import '../../models/user_model.dart';
import '../../widgets/dashboard_scaffold.dart';
import '../../widgets/stat_card.dart';

class StudentDashboard extends StatelessWidget {
  final UserModel user;

  const StudentDashboard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      user: user,
      title: 'Student Dashboard',
      children: [
        Text(
          'Welcome back, ${user.name}!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        
        // Quick Stats
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            StatCard(
              title: 'Attendance',
              value: '85%',
              icon: Icons.calendar_today,
              color: AppTheme.primaryColor,
              onTap: () {
                // TODO: Navigate to attendance details
              },
            ),
            StatCard(
              title: 'Next Fee Due',
              value: '₹2,500',
              icon: Icons.payment,
              color: AppTheme.warningColor,
              onTap: () {
                // TODO: Navigate to fee details
              },
            ),
            StatCard(
              title: 'Training Hours',
              value: '24h',
              icon: Icons.timer,
              color: AppTheme.secondaryColor,
            ),
            StatCard(
              title: 'Achievements',
              value: '3',
              icon: Icons.emoji_events,
              color: AppTheme.successColor,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Progress Chart
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Overview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: RadarChart(
                    RadarChartData(
                      radarShape: RadarShape.polygon,
                      tickCount: 4,
                      ticksTextStyle: const TextStyle(color: Colors.transparent),
                      gridBorderData: const BorderSide(color: Colors.black12),
                      titleTextStyle: const TextStyle(fontSize: 12),
                      getTitle: (index, angle) {
                        final titles = ['Technical', 'Tactical', 'Physical', 'Psychological'];
                        return RadarChartTitle(text: titles[index]);
                      },
                      dataSets: [
                        RadarDataSet(
                          fillColor: AppTheme.primaryColor.withOpacity(0.2),
                          borderColor: AppTheme.primaryColor,
                          entryRadius: 2,
                          dataEntries: [
                            const RadarEntry(value: 8), // Technical
                            const RadarEntry(value: 7), // Tactical
                            const RadarEntry(value: 9), // Physical
                            const RadarEntry(value: 6), // Psychological
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Recent Activity
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildActivityItem(
                  context,
                  'Attendance Marked',
                  'Present for Morning Training',
                  '2h ago',
                  Icons.check_circle,
                  AppTheme.successColor,
                ),
                _buildActivityItem(
                  context,
                  'Progress Updated',
                  'Technical Skills Assessment',
                  '1d ago',
                  Icons.trending_up,
                  AppTheme.primaryColor,
                ),
                _buildActivityItem(
                  context,
                  'Fee Payment',
                  'Monthly Fee Paid: ₹2,500',
                  '3d ago',
                  Icons.payment,
                  AppTheme.secondaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
} 