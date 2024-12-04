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

  Future<void> _addMember() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create Firebase Auth user for the member
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Save user details in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'role': 'User', // Default role for team members
          'uid': userCredential.user!.uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Member added successfully")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete the form")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Add Team Member")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Name", enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                    validator: (value) => value!.isEmpty ? "Please enter a name" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _roleController,
                    decoration: const InputDecoration(labelText: "Role", enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                    validator: (value) => value!.isEmpty ? "Please enter a role" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Email", enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                    validator: (value) => value!.isEmpty ? "Please enter an email" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: "Password", enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? "Please enter a password" : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addMember,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      "Add Member",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MemberListScreen()),
                      );
                    },
                    style: TextButton.styleFrom(),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Team Member",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue.shade900, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
