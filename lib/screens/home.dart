
import 'package:flutter/material.dart';
import 'package:taskmanagement/screens/task_screen/calender_task_view.dart';
import 'package:taskmanagement/screens/task_screen/progressscreen.dart';
import 'package:taskmanagement/screens/task_screen/task_add_screen.dart';
import 'package:taskmanagement/screens/team/create_team.dart';
import 'package:taskmanagement/screens/team_member/add_team_member_screen.dart';
import '../widget/component/customdrawer.dart';
import 'dashboardscreen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  // List of pages to show
  final List<Widget> _pages = [
    const DashboardScreen(),
    TaskAddScreen(),
    MemberAddScreen(),
    CreateTeamScreen(),
    CalendarTaskViewScreen(),
    const TaskPieChartScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //drawer: const CustomDrawer(),
        // Display the selected page
        body: _pages[_selectedIndex],
        // Persistent Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_task),
              label: "Add Task",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: "Add Member",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_add),
              label: "Create Team",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Date View",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: "Progress",
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue.shade900,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
