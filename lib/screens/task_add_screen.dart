import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmanagement/screens/task_list_screen.dart';

import '../models/task_model.dart';
import 'calender_task_view.dart';

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
  String? _selectedTeamMember;
  List<String> _assignedUsers = [];
  String _status = 'Not Started';
  List<String> _teamMembers = [];

  @override
  void initState() {
    super.initState();
    _fetchTeamMembers();
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
      appBar: AppBar(
        title: Text(
          "Add Task",
          style: TextStyle(
            color: Colors.blue.shade900,
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.calendar_month_outlined,
              size: 35,
              color: Colors.blue.shade900,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarTaskViewScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField("Task Name", _taskNameController, "Please enter a task name"),
                const SizedBox(height: 10),
                _buildTextField("Description", _descriptionController, null),
                const SizedBox(height: 10),
                _buildDropdownField("Priority", _priority, ['Low', 'Medium', 'High'], (value) {
                  setState(() {
                    _priority = value!;
                  });
                }),
                const SizedBox(height: 10),
                ListTile(
                  title: Text("Deadline: ${_deadline != null ? _deadline.toString() : 'Select Date'}"),
                  trailing: Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.blue.shade900,
                  ),
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
                const SizedBox(height: 10),
                _buildDropdownField("Status", _status, ['Not Started', 'In Progress', 'Completed'], (value) {
                  setState(() {
                    _status = value!;
                  });
                }),
                const SizedBox(height: 10),
                _buildTeamMemberDropdown(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _addTask(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade900, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  child: const Text(
                    "Add Task",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskListScreen()),
                      );
                    },
                    child: Text(
                      "Task List",
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String? validatorMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: validatorMessage != null ? (value) => value!.isEmpty ? validatorMessage : null : null,
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTeamMemberDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Assign to Team Member",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
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
          _assignedUsers = [value!];
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task added successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete the form")),
      );
    }
  }
}
