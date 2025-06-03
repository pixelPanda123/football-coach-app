import 'package:flutter/material.dart';
import '../attendance/mark_attendance_screen.dart';
import '../attendance/batch_attendance_screen.dart';
import '../student/student_list_screen.dart';

class CoachHomeScreen extends StatefulWidget {
  final String coachId;

  const CoachHomeScreen({Key? key, required this.coachId}) : super(key: key);

  @override
  State<CoachHomeScreen> createState() => _CoachHomeScreenState();
}

class _CoachHomeScreenState extends State<CoachHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home tab (to be implemented)
          const Center(child: Text('Home')),
          
          // Attendance tab
          Column(
            children: [
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text('Attendance'),
                      bottom: const TabBar(
                        tabs: [
                          Tab(text: 'Mark Attendance'),
                          Tab(text: 'View Attendance'),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        MarkAttendanceScreen(coachId: widget.coachId),
                        BatchAttendanceScreen(coachId: widget.coachId),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Students tab
          StudentListScreen(isCoach: true),

          // Progress tab (to be implemented)
          const Center(child: Text('Progress')),

          // Profile tab (to be implemented)
          const Center(child: Text('Profile')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
} 