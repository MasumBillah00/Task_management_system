import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagement/screens/task_screen/calender_task_view.dart';
import 'package:taskmanagement/screens/task_screen/progressscreen.dart';
import 'package:taskmanagement/screens/task_screen/task_add_screen.dart';
import 'package:taskmanagement/screens/task_screen/task_list_screen.dart';
import 'package:taskmanagement/screens/team/create_team.dart';
import 'package:taskmanagement/screens/team_member/add_team_member_screen.dart';

import '../logic/bloc/task_bloc/task_bloc.dart';
import '../widget/component/customdrawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
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
                  MaterialPageRoute(
                      builder: (context) => const TaskListScreen()),
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
                  MaterialPageRoute(
                      builder: (context) => MemberAddScreen()),
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
                  MaterialPageRoute(
                      builder: (context) => CreateTeamScreen()),
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
            _buildNavigationCard(
              context,
              title: "Progress Report",
              icon: Icons.show_chart,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TaskPieChartScreen()),
                );
              },
            ),
          ],
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
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
