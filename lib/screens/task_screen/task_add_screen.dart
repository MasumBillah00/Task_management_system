

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

  // Future<void> fetchTeamMembers() async {
  //   final snapshot = await FirebaseFirestore.instance.collection('team_members').get();
  //   final Map<String, String> membersMap = {
  //     for (var doc in snapshot.docs) doc['name'] as String: doc.id as String,
  //   };
  //   setState(() {
  //     teamMembers = membersMap;
  //   });
  // }
  Future<void> fetchTeamMembers() async {
    final snapshot = await FirebaseFirestore.instance.collection('team_members').get();
    final Map<String, String> membersMap = {
      for (var doc in snapshot.docs) doc['name'] as String: doc.id as String,
    };
    setState(() {
      teamMembers = membersMap;
    });
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
        'assignedUsers': newTask.assignedUsers, // Ensure this field is added
        'status': newTask.status,
      }).then((docRef) {
        // Once the task is added, update the task's document with the ID
        docRef.update({'id': docRef.id});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task added successfully")),
        );
        Navigator.pop(context); // Go back after adding the task
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding task: $e')),
        );
      });
    }
  }

  // void _addTask() {
  //   if (_formKey.currentState!.validate()) {
  //     Task newTask = Task(
  //       id: '',
  //       taskName: _taskNameController.text,
  //       description: _descriptionController.text,
  //       priority: _priority,
  //       deadline: _deadline ?? DateTime.now(),
  //       assignedUsers: _assignedUsers,
  //       status: _status,
  //     );
  //     BlocProvider.of<TaskBloc>(context).add(AddTaskEvent(newTask));
  //   }
  // }

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
              DropdownButton<String>(
                value: _selectedTeamMember,
                onChanged: (id) {
                  setState(() {
                    _selectedTeamMember = id;
                    _assignedUsers = id != null ? [id] : [];
                  });
                },
                hint: const Text("Select Team Member"),
                items: teamMembers.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.value,
                    child: Text(entry.key),
                  );
                }).toList(),
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

//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskmanagement/screens/task_screen/task_list_screen.dart';
//
// import '../../data/models/task_model.dart';
// import '../../logic/bloc/task_bloc/task_bloc.dart';
// import '../../logic/bloc/task_bloc/task_event.dart';
// import '../../logic/bloc/task_bloc/task_state.dart';
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
//   String? _selectedTeamMember;
//   List<String> _assignedUsers = [];
//   String _status = 'Not Started';
//   List<String> _teamMembers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchTeamMembers();
//   }
//
//   Future<void> _fetchTeamMembers() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('team_members').get();
//       setState(() {
//         _teamMembers = snapshot.docs.map((doc) => doc['name'] as String).toList();
//       });
//     } catch (e) {
//       print("Error fetching team members: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<TaskBloc, TaskState>(
//       listener: (context, state) {
//         if (state is TaskAddedSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Task added successfully")),
//           );
//           Navigator.pop(context);
//         } else if (state is TaskError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Add Task", style: TextStyle(color: Colors.blue.shade900, fontSize: 30)),
//         ),
//         body: Form(
//           key: _formKey,
//           child: ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               _buildTextField("Task Name", _taskNameController, "Please enter a task name"),
//               const SizedBox(
//                 height: 10,
//               ),
//               _buildTextField("Description", _descriptionController, null),
//               const SizedBox(
//                 height: 10,
//               ),
//               _buildDropdownField("Priority", _priority, ['Low', 'Medium', 'High'], (value) {
//                 setState(() {
//                   _priority = value!;
//                 });
//               }),
//               const SizedBox(
//                 height: 10,
//               ),
//               _buildDeadlinePicker(),
//               const SizedBox(
//                 height: 10,
//               ),
//               _buildDropdownField("Status", _status, ['Not Started', 'In Progress', 'Completed'], (value) {
//                 setState(() {
//                   _status = value!;
//                 });
//               }),
//               const SizedBox(
//                 height: 10,
//               ),
//               _buildTeamMemberDropdown(),
//               const SizedBox(
//                 height: 10,
//               ),
//               ElevatedButton(
//                 onPressed: () => _addTask(),
//                 child: const Text("Add Task", style: TextStyle(color: Colors.black)),
//               ),
//
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => TaskListScreen()),
//                   );
//                 },
//                 child: const Text("View Task List"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(String label, TextEditingController controller, String? validatorMessage) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
//       validator: validatorMessage != null ? (value) => value!.isEmpty ? validatorMessage : null : null,
//     );
//   }
//
//   void _addTask() {
//     if (_formKey.currentState!.validate()) {
//       Task newTask = Task(
//
//
//         taskName:   _taskNameController.text,
//         description: _descriptionController.text,
//         priority: _priority,
//         deadline: _deadline ?? DateTime.now(),
//         assignedUsers: _assignedUsers,
//         status: _status,
//         id: '',
//
//
//
//       );
//       BlocProvider.of<TaskBloc>(context).add(AddTaskEvent(newTask));
//     }
//   }
//
//   Widget _buildDropdownField(String label, String value, List<String> items, Function(String?) onChanged) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//       items: items
//           .map((item) =>
//           DropdownMenuItem(
//             value: item,
//             child: Text(item),
//           ))
//           .toList(),
//       onChanged: onChanged,
//     );
//   }
//
//   Widget _buildDeadlinePicker() {
//     return ListTile(
//       title: Text("Deadline: ${_deadline != null ? _deadline!.toLocal().toString().split(' ')[0] : 'Select Date'}"),
//       trailing: Icon(Icons.calendar_today, color: Colors.blue.shade900),
//       onTap: () async {
//         DateTime? picked = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime.now(),
//           lastDate: DateTime(2101),
//         );
//         if (picked != null) {
//           setState(() {
//             _deadline = picked;
//           });
//         }
//       },
//     );
//   }
//
//   Widget _buildTeamMemberDropdown() {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         labelText: "Assign to Team Member",
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       value: _selectedTeamMember,
//       items: _teamMembers.map((member) {
//         return DropdownMenuItem(
//           value: member,
//           child: Text(member),
//         );
//       }).toList(),
//       onChanged: (value) {
//         setState(() {
//           _selectedTeamMember = value;
//           _assignedUsers = value != null ? [value] : [];
//         });
//       },
//       validator: (value) => value == null ? "Please select a team member" : null,
//     );
//   }
//
// }

