import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagement/screens/calender_task_view.dart';
import 'package:taskmanagement/screens/task_add_screen.dart';
import 'package:taskmanagement/screens/team/create_team.dart';
import 'package:taskmanagement/screens/team_member/add_team_member_screen.dart';

import 'logic/bloc/task_bloc.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dashboard",style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: Colors.blue.shade900
          ),
          ),
          backgroundColor: Colors.white70,
          centerTitle: true,
        ),
        drawer: const Custom_Drawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0,),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            shrinkWrap: true,
            children: [
              _buildNavigationCard(
                context,
                title: "Add Task",
                //description: "Create and assign a new task",
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
                title: "Add Member",
                //description: "Add a new team member",
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
                //description: "Create a team for new tasks",
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
               // description: "View tasks by date",
                icon: Icons.task,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalendarTaskViewScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
      BuildContext context, {
        required String title,
        //required String description,
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
              Icon(icon, size: 60, color: Theme.of(context).primaryColor), // Increased icon size
              const SizedBox(height: 1),
              Text(
                title,
                textAlign: TextAlign.center,
                style:const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Text(
              //   description,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              // ),
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
        children: const [
          DrawerHeader(child: Text('TMS')),
          ListTile(
           title: Text('Item1'),
          ),
          ListTile(
            title: Text('Item1'),
          ),
          ListTile(
            title: Text('Item1'),
          ),
        ],

      )

    );
  }
}
