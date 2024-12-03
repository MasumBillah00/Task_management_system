

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanagement/logic/bloc/task_bloc/task_bloc.dart';
import 'package:taskmanagement/logic/bloc/task_bloc/task_event.dart';
import 'package:taskmanagement/screens/task_screen/task_list_screen.dart';
import '../../data/models/task_model.dart';
import '../../logic/bloc/task_bloc/task_state.dart';
import '../../widget/add_task_widget/deadline_picker.dart';
import '../../widget/add_task_widget/dropdown-field.dart';
import '../../widget/add_task_widget/text_field.dart';

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
  String _status = 'Not Started';
  List<String> _assignedUsers = [];
  String? _selectedTeamMember;

  Map<String, String> teamMembers = {}; // Store team members with ID and name

  @override
  void initState() {
    super.initState();
    fetchTeamMembers(); // Fetch team members on init
  }

  Future<void> fetchTeamMembers() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('users')
          .where('role', isNotEqualTo: 'Teacher').get();
      if (snapshot.docs.isNotEmpty) {
        final Map<String, String> membersMap = {
          for (var doc in snapshot.docs) doc['name']: doc.id, // Name as key, ID as value
        };
        setState(() {
          teamMembers = membersMap;
        });
      } else {
        print("No team members found.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No team members available to fetch.")),
        );
      }
    } catch (e) {
      print("Error fetching team members: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching team members: $e")),
      );
    }
  }



  void _addTask() {
    if (_formKey.currentState!.validate()) {
      Task newTask = Task(
        id: '',
        taskName: _taskNameController.text,
        description: _descriptionController.text,
        priority: _priority,
        deadline: _deadline ?? DateTime.now(),
        assignedUsers: _assignedUsers, // Ensure assigned users are added here
        status: _status,
      );
      // Add task to Firestore
      FirebaseFirestore.instance.collection('tasks').add({
        'taskName': newTask.taskName,
        'description': newTask.description,
        'priority': newTask.priority,
        'deadline': newTask.deadline,
        'assignedUsers': newTask.assignedUsers,
        'status': newTask.status,
      }).then((docRef) {
        docRef.update({'id': docRef.id});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task added successfully")),
        );
        Navigator.pop(context);
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding task: $e')),
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskAddedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Task added successfully")),
          );
          Navigator.pop(context);
        } else if (state is TaskError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Task", style: TextStyle(color: Colors.blue.shade900, fontSize: 30)),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CustomTextField(
                label: "Task Name",
                controller: _taskNameController,
                validatorMessage: "Please enter a task name",
              ),
              const SizedBox(height: 10),
              CustomTextField(label: "Description", controller: _descriptionController),
              const SizedBox(height: 10),
              CustomDropdownField(
                label: "Priority",
                value: _priority,
                items: ['Low', 'Medium', 'High'],
                onChanged: (value) => setState(() => _priority = value!),
              ),
              const SizedBox(height: 10),
              DeadlinePicker(
                selectedDeadline: _deadline,
                onDeadlineSelected: (pickedDate) => setState(() => _deadline = pickedDate),
              ),
              const SizedBox(height: 10),
              CustomDropdownField(
                label: "Status",
                value: _status,
                items: ['Not Started', 'In Progress', 'Completed'],
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 10),
              TeamMemberDropdown(
                label: "Assign to",
                selectedTeamMember: _selectedTeamMember,
                teamMembers: teamMembers,
                onChanged: (id) {
                  setState(() {
                    _selectedTeamMember = id;
                    _assignedUsers = id != null ? [id] : [];
                  });
                },
              ),




              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addTask,
                child: const Text("Add Task", style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaskListScreen()),
                ),
                child: const Text("View Task List"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
