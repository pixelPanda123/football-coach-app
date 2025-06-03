import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';
import '../screens/profile/profile_screen.dart';

class DashboardScaffold extends StatelessWidget {
  final UserModel user;
  final String title;
  final List<Widget> children;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const DashboardScaffold({
    Key? key,
    required this.user,
    required this.title,
    required this.children,
    this.actions,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (actions != null) ...actions!,
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: user),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.name),
              accountEmail: Text(user.email),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  user.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            if (user.isStudent) ...[
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.assessment),
                title: const Text('Progress'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to progress screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Attendance'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to attendance screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Fees'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to fees screen
                },
              ),
            ],
            if (user.isCoach) ...[
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.groups),
                title: const Text('My Batches'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to batches screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.how_to_reg),
                title: const Text('Take Attendance'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to take attendance screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.assessment),
                title: const Text('Assess Progress'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to progress assessment screen
                },
              ),
            ],
            if (user.isHeadCoach) ...[
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Students'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to students screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.sports),
                title: const Text('Coaches'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to coaches screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('Analytics'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to analytics screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to settings screen
                },
              ),
            ],
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // TODO: Implement logout
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
} 