// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:taskmanagement/screens/task_list_screen.dart';
//
// import '../models/task_model.dart';
//
// class TaskAddScreen extends StatefulWidget {
//   @override
//   _TaskAddScreenState createState() => _TaskAddScreenState();
// }
//
// class _TaskAddScreenState extends State<TaskAddScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _taskNameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   String _priority = 'Low';
//   DateTime? _deadline;
//   List<String> _assignedUsers = [];
//   String _status = 'Not Started';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Task")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _taskNameController,
//                 decoration: InputDecoration(labelText: "Task Name"),
//                 validator: (value) =>
//                 value!.isEmpty ? "Please enter a task name" : null,
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: "Description"),
//               ),
//               DropdownButtonFormField<String>(
//                 value: _priority,
//                 decoration: InputDecoration(labelText: "Priority"),
//                 items: ['Low', 'Medium', 'High']
//                     .map((priority) => DropdownMenuItem(
//                   value: priority,
//                   child: Text(priority),
//                 ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _priority = value!;
//                   });
//                 },
//               ),
//               ListTile(
//                 title: Text(
//                     "Deadline: ${_deadline != null ? _deadline.toString() : 'Select Date'}"),
//                 trailing: Icon(Icons.calendar_today),
//                 onTap: () async {
//                   DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime(2101),
//                   );
//                   if (picked != null) {
//                     setState(() {
//                       _deadline = picked;
//                     });
//                   }
//                 },
//               ),
//               DropdownButtonFormField<String>(
//                 value: _status,
//                 decoration: InputDecoration(labelText: "Status"),
//                 items: ['Not Started', 'In Progress', 'Completed']
//                     .map((status) => DropdownMenuItem(
//                   value: status,
//                   child: Text(status),
//                 ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _status = value!;
//                   });
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => _addTask(),
//                 child: Text("Add Task"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => TaskListScreen()),
//                   );
//                 },
//                 child: Text("Task List"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _addTask() async {
//     if (_formKey.currentState!.validate() && _deadline != null) {
//       Task newTask = Task(
//         taskName: _taskNameController.text,
//         description: _descriptionController.text,
//         priority: _priority,
//         deadline: _deadline!,
//         assignedUsers: _assignedUsers, // Assuming you’ll handle assigned users later
//         status: _status,
//       );
//
//       await FirebaseFirestore.instance.collection('tasks').add(newTask.toMap());
//
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Task added successfully")));
//      // Navigator.pop(context); // Go back after adding the task
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Please complete the form")));
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmanagement/screens/task_list_screen.dart';

import '../models/task_model.dart';

class TaskAddScreen extends StatefulWidget {
  @override
  _TaskAddScreenState createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _priority = 'Low';
  DateTime? _deadline;
  String? _selectedTeamMember; // For dropdown selection
  List<String> _assignedUsers = [];
  String _status = 'Not Started';
  List<String> _teamMembers = []; // To store fetched team members

  @override
  void initState() {
    super.initState();
    _fetchTeamMembers(); // Fetch team members when the screen is initialized
  }

  Future<void> _fetchTeamMembers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('team_members').get();
    setState(() {
      _teamMembers = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _taskNameController,
                  decoration: InputDecoration(labelText: "Task Name"),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter a task name" : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                ),
                DropdownButtonFormField<String>(
                  value: _priority,
                  decoration: InputDecoration(labelText: "Priority"),
                  items: ['Low', 'Medium', 'High']
                      .map((priority) => DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _priority = value!;
                    });
                  },
                ),
                ListTile(
                  title: Text(
                      "Deadline: ${_deadline != null ? _deadline.toString() : 'Select Date'}"),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() {
                        _deadline = picked;
                      });
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(labelText: "Status"),
                  items: ['Not Started', 'In Progress', 'Completed']
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                _buildTeamMemberDropdown(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _addTask(),
                  child: Text("Add Task"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskListScreen()),
                    );
                  },
                  child: Text("Task List"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMemberDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: "Assign to Team Member"),
      value: _selectedTeamMember,
      items: _teamMembers.map((member) {
        return DropdownMenuItem(
          value: member,
          child: Text(member),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedTeamMember = value;
          _assignedUsers = [value!]; // Store the selected team member in assigned users
        });
      },
      validator: (value) => value == null ? "Please select a team member" : null,
    );
  }

  Future<void> _addTask() async {
    if (_formKey.currentState!.validate() && _deadline != null) {
      Task newTask = Task(
        taskName: _taskNameController.text,
        description: _descriptionController.text,
        priority: _priority,
        deadline: _deadline!,
        assignedUsers: _assignedUsers,
        status: _status,
      );

      await FirebaseFirestore.instance.collection('tasks').add(newTask.toMap());

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Task added successfully")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please complete the form")));
    }
  }
}

