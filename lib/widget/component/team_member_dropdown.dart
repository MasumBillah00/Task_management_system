import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeamMemberDropdown extends StatefulWidget {
  final String? selectedTeamMember;
  final ValueChanged<String?> onMemberSelected;

  const TeamMemberDropdown({
    Key? key,
    required this.selectedTeamMember,
    required this.onMemberSelected,
  }) : super(key: key);

  @override
  _TeamMemberDropdownState createState() => _TeamMemberDropdownState();
}

class _TeamMemberDropdownState extends State<TeamMemberDropdown> {
  List<String> _teamMembers = [];

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Assign to Team Member",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      value: widget.selectedTeamMember,
      items: _teamMembers.map((member) {
        return DropdownMenuItem(
          value: member,
          child: Text(member),
        );
      }).toList(),
      onChanged: widget.onMemberSelected,
      validator: (value) => value == null ? "Please select a team member" : null,
    );
  }
}
