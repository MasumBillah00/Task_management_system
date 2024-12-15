
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/task_model.dart';
import '../../widget/component/deadline_picker.dart';

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
            // Task Name
            _buildCustomListTile(
              title: "Task Name",
              value: widget.task.taskName,
              onTap: null, // Read-only, no action needed
            ),

            // Priority
            _buildCustomListTile(
              title: "Priority",
              value: widget.task.priority,
              onTap: null, // Read-only, no action needed
            ),

            // Editable Description as it is
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Status Dropdown
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
              items: ['Not Started', 'In Progress', 'Completed']
                  .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) => setState(() => _status = value!),
            ),
            const SizedBox(height: 16),

            // Deadline Picker
            DeadlinePicker(
              selectedDeadline: _deadline,
              onDeadlineSelected: (pickedDate) => setState(() => _deadline = pickedDate),
            ),
            const SizedBox(height: 16),

            // Assigned Team Member Dropdown
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

            const SizedBox(height: 10,),

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



  Widget _buildCustomListTile({
    required String title,
    required String value,
    required VoidCallback? onTap,
    String? assetIconPath,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                if (assetIconPath != null)
                  Image.asset(
                    assetIconPath,
                    width: 30,
                    height: 30,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

