import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanagement/screens/team_member/team_member_list_screen.dart';

import '../../data/models/team_member_model.dart';

class MemberAddScreen extends StatefulWidget {
  @override
  _MemberAddScreenState createState() => _MemberAddScreenState();
}

class _MemberAddScreenState extends State<MemberAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Team Member")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) =>
                value!.isEmpty ? "Please enter a name" : null,
              ),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: "Role"),
                validator: (value) =>
                value!.isEmpty ? "Please enter a role" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                value!.isEmpty ? "Please enter an email" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addMember(),
                child: const Text("Add Member"),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>MemberListScreen()),
                  );
                },
                child: const Text("Team Member"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addMember() async {
    if (_formKey.currentState!.validate()) {
      TeamMember newMember = TeamMember(
        name: _nameController.text,
        role: _roleController.text,
        email: _emailController.text,
        id: '', // This should be handled by Firestore
      );

      // Add the new member and get the generated ID
      DocumentReference docRef = await FirebaseFirestore.instance.collection('team_members').add(newMember.toMap());

      // Update the member ID with the generated document ID
      newMember.id = docRef.id; // Update with the Firestore document ID
      await docRef.set(newMember.toMap(), SetOptions(merge: true)); // Merge to add the ID to Firestore

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Member added successfully")));
      Navigator.pop(context); // Go back after adding the member
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please complete the form")));
    }
  }


// Future<void> _addMember() async {
  //   if (_formKey.currentState!.validate()) {
  //     TeamMember newMember = TeamMember(
  //       name: _nameController.text,
  //       role: _roleController.text,
  //       email: _emailController.text,
  //       id: '',
  //     );
  //     await FirebaseFirestore.instance.collection('team_members').add(newMember.toMap());
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(content: Text("Member added successfully")));
  //     Navigator.pop(context); // Go back after adding the member
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(content: Text("Please complete the form")));
  //   }
  // }
}
