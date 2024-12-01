import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmanagement/screens/user/update_task.dart';
import '../../data/models/task_model.dart';
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
                  color: Colors.blue.shade900,
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
                if (taskSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!taskSnapshot.hasData || taskSnapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No tasks available"));
                }

                List<Task> tasks = taskSnapshot.data!.docs
                    .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
                    .toList();

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TaskListScreen()),
                            ),
                            child: Text(
                              "View Task List",
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue.shade800,
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
                            color: Colors.black,
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
                    ...tasks.map((task) => Card(
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
