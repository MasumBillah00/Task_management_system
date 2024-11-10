// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../../data/models/task_model.dart';
//
// class UpdateTaskScreen extends StatefulWidget {
//   final Task task;
//
//   UpdateTaskScreen({required this.task});
//
//   @override
//   _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
// }
//
// class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
//   late TextEditingController _taskNameController;
//   late TextEditingController _descriptionController;
//
//   @override
//   void initState() {
//     super.initState();
//     _taskNameController = TextEditingController(text: widget.task.taskName);
//     _descriptionController = TextEditingController(text: widget.task.description);
//   }
//
//   @override
//   void dispose() {
//     _taskNameController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _updateTask() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('tasks')
//           .doc(widget.task.id)
//           .update({
//         'taskName': _taskNameController.text,
//         'description': _descriptionController.text,
//       });
//       Navigator.pop(context); // Close the screen after updating
//     } catch (e) {
//       print("Failed to update task: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Update Task")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _taskNameController,
//               decoration: InputDecoration(labelText: 'Task Name'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: 'Description'),
//               maxLines: 3,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _updateTask,
//               child: Text('Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/task_model.dart';

class UpdateTaskScreen extends StatefulWidget {
  final Task task;

  UpdateTaskScreen({required this.task});

  @override
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  late TextEditingController _taskNameController;
  late TextEditingController _descriptionController;
  String _priority = 'Low';
  String _status = 'Not Started';
  DateTime? _deadline;
  String? _selectedTeamMember;
  List<String> _teamMembers = [];
  List<String> _assignedUsers = [];

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController(text: widget.task.taskName);
    _descriptionController = TextEditingController(text: widget.task.description);
    _priority = widget.task.priority;
    _status = widget.task.status;
    _deadline = widget.task.deadline;
    _assignedUsers = widget.task.assignedUsers;
    _fetchTeamMembers();
  }

  Future<void> _fetchTeamMembers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('team_members').get();
      setState(() {
        _teamMembers = snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print("Error fetching team members: $e");
    }
  }

  Future<void> _updateTask() async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(widget.task.id).update({
        'taskName': _taskNameController.text,
        'description': _descriptionController.text,
        'priority': _priority,
        'status': _status,
        'deadline': _deadline,
        'assignedUsers': _assignedUsers,
      });
      Navigator.pop(context); // Close the screen after updating
    } catch (e) {
      print("Failed to update task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _taskNameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: InputDecoration(
                labelText: "Priority",
                border: OutlineInputBorder(),
              ),
              items: ['Low', 'Medium', 'High']
                  .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
                  .toList(),
              onChanged: (value) => setState(() => _priority = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
              items: ['Not Started', 'In Progress', 'Completed']
                  .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) => setState(() => _status = value!),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text("Deadline: ${_deadline != null ? _deadline!.toLocal().toString().split(' ')[0] : 'Select Date'}"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _deadline ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) setState(() => _deadline = pickedDate);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedTeamMember,
              decoration: InputDecoration(
                labelText: "Assign to Team Member",
                border: OutlineInputBorder(),
              ),
              items: _teamMembers.map((member) {
                return DropdownMenuItem(value: member, child: Text(member));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTeamMember = value;
                  _assignedUsers = value != null ? [value] : [];
                });
              },
              validator: (value) => value == null ? "Please select a team member" : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTask,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
