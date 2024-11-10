import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController _passwordController = TextEditingController();


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
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) =>
                value!.isEmpty ? "Please enter a password" : null,
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
      try {
        // Create Firebase Auth user
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Create a new TeamMember instance
        TeamMember newMember = TeamMember(
          id: userCredential.user!.uid,
          name: _nameController.text,
          role: _roleController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Save member details (excluding password) in Firestore
        await FirebaseFirestore.instance.collection('team_members').doc(newMember.id).set(newMember.toMap());

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Member added successfully")));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please complete the form")));
    }
  }

}
