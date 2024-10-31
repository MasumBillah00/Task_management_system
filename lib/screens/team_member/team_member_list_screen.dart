import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/team_member_model.dart';


class MemberListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Members"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('team_members').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No team members available"));
          }
          List<TeamMember> members = snapshot.data!.docs
              .map((doc) => TeamMember.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return Card(
                margin:const  EdgeInsets.all(8),
                child: ListTile(
                  title: Text(member.name),
                  subtitle: Text("Role: ${member.role}\nEmail: ${member.email}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
