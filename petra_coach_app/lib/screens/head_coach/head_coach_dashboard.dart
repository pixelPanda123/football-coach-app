import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/theme.dart';
import '../../models/user_model.dart';
import '../../widgets/dashboard_scaffold.dart';
import '../../widgets/stat_card.dart';

class HeadCoachDashboard extends StatelessWidget {
  final UserModel user;

  const HeadCoachDashboard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      user: user,
      title: 'Head Coach Dashboard',
      children: [
        Text(
          'Welcome back, ${user.name}!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),

        // Academy Overview
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            StatCard(
              title: 'Total Students',
              value: '127',
              icon: Icons.people,
              color: AppTheme.primaryColor,
              onTap: () {
                // TODO: Navigate to students list
              },
            ),
            StatCard(
              title: 'Active Coaches',
              value: '4',
              icon: Icons.sports,
              color: AppTheme.secondaryColor,
              onTap: () {
                // TODO: Navigate to coaches list
              },
            ),
            StatCard(
              title: 'Today\'s Attendance',
              value: '89%',
              icon: Icons.calendar_today,
              color: AppTheme.successColor,
            ),
            StatCard(
              title: 'Revenue This Month',
              value: '₹3.2L',
              icon: Icons.payments,
              color: AppTheme.warningColor,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Center Performance
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Center Performance',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const titles = ['Khanapur', 'Tellapur', 'Aziz Nagar'];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  titles[value.toInt()],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}%',
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        _createBarGroup(0, 85),
                        _createBarGroup(1, 72),
                        _createBarGroup(2, 78),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Recent Alerts
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Alerts',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to all alerts
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildAlertItem(
                  context,
                  'Low Attendance Alert',
                  '3 students have attendance below 70%',
                  AppTheme.errorColor,
                  Icons.warning,
                ),
                _buildAlertItem(
                  context,
                  'Fee Payment Due',
                  '8 students have pending fees',
                  AppTheme.warningColor,
                  Icons.payment,
                ),
                _buildAlertItem(
                  context,
                  'Progress Assessment',
                  'Monthly assessments due for U-13 batch',
                  AppTheme.primaryColor,
                  Icons.assessment,
                ),
              ],
            ),
          ),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Show quick actions menu
        },
        icon: const Icon(Icons.add),
        label: const Text('Quick Actions'),
      ),
    );
  }

  BarChartGroupData _createBarGroup(int x, double value) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: AppTheme.primaryColor,
          width: 25,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildAlertItem(
    BuildContext context,
    String title,
    String description,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              // TODO: Navigate to alert details
            },
          ),
        ],
      ),
    );
  }
} 