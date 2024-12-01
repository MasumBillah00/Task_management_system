import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagement/screens/task_screen/calender_task_view.dart';
import 'package:taskmanagement/screens/task_screen/task_add_screen.dart';
import 'package:taskmanagement/screens/task_screen/task_list_screen.dart';
import 'package:taskmanagement/screens/team/create_team.dart';
import 'package:taskmanagement/screens/team_member/add_team_member_screen.dart';
import '../logic/bloc/task_bloc/task_bloc.dart';
import 'login_registration/loginpage.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  // Define the pages for each bottom navigation tab
  final List<Widget> _pages = [
    // Home (Dashboard) view
    AdminHomeScreen(),
    TaskAddScreen(),
    MemberAddScreen(),
    CreateTeamScreen(),
    CalendarTaskViewScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate to the selected page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _pages[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.blue.shade900,
            ),
          ),
          backgroundColor: Colors.white70,
          centerTitle: true,
        ),
        drawer: const Custom_Drawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            shrinkWrap: true,
            children: [
              _buildNavigationCard(
                context,
                title: "Add Task",
                icon: Icons.add_task,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: BlocProvider.of<TaskBloc>(context),
                        child: TaskAddScreen(),
                      ),
                    ),
                  );
                },
              ),
              _buildNavigationCard(
                context,
                title: "Task List",
                icon: Icons.list_alt,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TaskListScreen()),
                  );
                },
              ),
              _buildNavigationCard(
                context,
                title: "Add Member",
                icon: Icons.person_add_alt_1_sharp,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MemberAddScreen()),
                  );
                },
              ),
              _buildNavigationCard(
                context,
                title: "Create Team",
                icon: Icons.group_add,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateTeamScreen()),
                  );
                },
              ),
              _buildNavigationCard(
                context,
                title: "Date View",
                icon: Icons.task,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CalendarTaskViewScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        // Bottom Navigation Bar to switch screens
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 25),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_task, size: 25),
              label: "Add Task",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add, size: 25),
              label: "Add Member",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_add, size: 25),
              label: "Create Team",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today, size: 25),
              label: "Date View",
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

  Widget _buildNavigationCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 180,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: Theme.of(context).primaryColor),
              const SizedBox(height: 1),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Custom_Drawer extends StatelessWidget {
  const Custom_Drawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text('TMS')),
          const ListTile(
            title: Text('Item1'),
          ),
          const ListTile(
            title: Text('Item2'),
          ),
          const ListTile(
            title: Text('Item3'),
          ),
          ListTile(
            title:  const Text('Logout', style: TextStyle(color: Colors.red)),
            leading:  const Icon(Icons.logout, color: Colors.red),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
