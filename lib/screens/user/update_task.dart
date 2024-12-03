
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
  late TextEditingController _descriptionController;
  String _status = 'Not Started';
  DateTime? _deadline;
  String? _selectedTeamMember;
  List<String> _teamMembers = [];
  List<String> _assignedUsers = [];

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.task.description);
    _status = widget.task.status;
    _deadline = widget.task.deadline;
    _assignedUsers = widget.task.assignedUsers;
    _fetchTeamMembers();
  }

  Future<void> _fetchTeamMembers() async {
    try {
      // Query Firestore for users excluding those with the role 'Teacher'
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isNotEqualTo: 'Teacher') // Filter out "Teacher" roles
          .get();

      // Extract team member names for the dropdown
      setState(() {
        _teamMembers = snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print("Error fetching team members: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching team members: $e")),
      );
    }
  }


  Future<void> _updateTask() async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(widget.task.id).update({
        'description': _descriptionController.text,
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

            // Static Task Name
            ListTile(
              title: const Text('Task Name'),
              subtitle: Text(widget.task.taskName),
            ),
            const SizedBox(height: 16),

            // Static Priority
            ListTile(
              title: const Text('Priority'),
              subtitle: Text(widget.task.priority),
            ),
            const SizedBox(height: 16),

            // Editable Description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder()
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            // Editable Status
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

            // Editable Deadline
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

            // Editable Assigned Team Member
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

            // Save Changes Button
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

