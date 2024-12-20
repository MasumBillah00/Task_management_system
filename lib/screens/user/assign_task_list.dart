
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmanagement/screens/user/taskupdatehistory.dart';
import 'package:taskmanagement/screens/user/update_task.dart';

import '../../data/models/task_model.dart';
import '../../widget/component/deadline_picker.dart';
import '../task_screen/progressscreen.dart';
import '../task_screen/task_list_screen.dart';



class AssignedTaskListScreen extends StatelessWidget {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  final String userEmail = FirebaseAuth.instance.currentUser!.email!;

  Future<String> _fetchUserName() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('team_members')
          .doc(userId)
          .get();
      return doc['name'] ?? 'User';
    } catch (e) {
      print("Error fetching user name: $e");
      return 'User';
    }
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login'); // Assuming '/login' is your login route
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Profile"),
          centerTitle: true,
          backgroundColor: Colors.black.withOpacity(.1),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                    Icons.show_chart
                ),
                title: const Text('Task Progress'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  const TaskPieChartScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
        body: FutureBuilder<String>(
          future: _fetchUserName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }


            final userName = snapshot.data ?? 'User';

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .where('assignedUsers', arrayContains: userId)
                  .snapshots(),
              builder: (context, taskSnapshot) {
                List<Task> tasks = [];
                if (taskSnapshot.hasData && taskSnapshot.data!.docs.isNotEmpty) {
                  tasks = taskSnapshot.data!.docs
                      .map((doc) =>
                      Task.fromMap(doc.data() as Map<String, dynamic>))
                      .toList();
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          //child:
                          // TextButton(
                          //   onPressed: () =>
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => const TaskListScreen()),
                          //       ),
                          //   child: Text(
                          //     "Available Task",
                          //     style: TextStyle(
                          //       color: Colors.blue.shade800,
                          //       decoration: TextDecoration.underline,
                          //       decorationColor: Colors.blue.shade800,
                          //     ),
                          //   ),
                          // ),

                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TaskListScreen()),
                              );
                            },
                            child: Container(
                              // padding: const EdgeInsets.only(bottom: 0), // Space between text and line
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.blue, width: 3)), // Bottom border
                              ),
                              child: const Text(
                                "Available Task",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "Hello,",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Mr. $userName",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'These tasks are assigned to you. Best of luck!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    if (tasks.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            "Oops!\n No tasks available for you at this moment.",
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      ...tasks.map((task) =>
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    task.taskName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(task.description),
                                  Text(
                                    task.priority,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade800,
                                    ),
                                  ),
                                  Text(task.status),
                                  Text(
                                    task.deadline.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.blue.shade600,
                                    ),
                                  ),
                                  // DeadlinePicker(
                                  //   selectedDeadline: _deadline,
                                  //   onDeadlineSelected: (pickedDate) => setState(() => _deadline = pickedDate),
                                  // ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateTaskScreen(task: task),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Update Task',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskHistoryPage(taskId: '',),
                          ),
                        );
                      },
                      child: const Text('View Update History'),
                    ),

                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
