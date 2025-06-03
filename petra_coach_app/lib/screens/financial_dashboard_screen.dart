import 'package:flutter/material.dart';
import '../services/fee_service.dart';
import 'package:fl_chart/fl_chart.dart';

class FinancialDashboardScreen extends StatefulWidget {
  const FinancialDashboardScreen({Key? key}) : super(key: key);

  @override
  _FinancialDashboardScreenState createState() => _FinancialDashboardScreenState();
}

class _FinancialDashboardScreenState extends State<FinancialDashboardScreen> {
  final FeeService _feeService = FeeService();
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final data = await _feeService.generateFinancialDashboardData();
      if (mounted) {
        setState(() {
          _dashboardData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading dashboard data: $e')),
        );
      }
    }
  }

  Widget _buildSummaryCard(String title, String value) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodChart() {
    if (_dashboardData == null || 
        _dashboardData!['paymentMethods'] == null || 
        (_dashboardData!['paymentMethods'] as Map).isEmpty) {
      return const Center(child: Text('No payment method data available'));
    }

    final paymentMethods = _dashboardData!['paymentMethods'] as Map<String, double>;
    final total = paymentMethods.values.reduce((a, b) => a + b);

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: paymentMethods.entries.map((entry) {
            return PieChartSectionData(
              color: Colors.primaries[paymentMethods.keys.toList().indexOf(entry.key) % Colors.primaries.length],
              value: entry.value,
              title: '${(entry.value / total * 100).toStringAsFixed(1)}%',
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(
                'Current Month Collection',
                '₹${_dashboardData?['currentMonthCollection']?.toStringAsFixed(2) ?? '0.00'}',
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment Methods Distribution',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildPaymentMethodChart(),
              const SizedBox(height: 24),
              if (_dashboardData?['paymentMethods'] != null) ...[
                const Text(
                  'Payment Methods Breakdown',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._dashboardData!['paymentMethods'].entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key),
                    trailing: Text(
                      '₹${entry.value.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 