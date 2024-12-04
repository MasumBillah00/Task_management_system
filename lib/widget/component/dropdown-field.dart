import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dropdownColor: Colors.white,

      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
            child: Text(item),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
class TeamMemberDropdown extends StatelessWidget {
  final String label;
  final String? selectedTeamMember;
  final Map<String, String> teamMembers;
  final ValueChanged<String?> onChanged;

  const TeamMemberDropdown({
    Key? key,
    required this.label,
    required this.selectedTeamMember,
    required this.teamMembers,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedTeamMember,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
      ),
      hint: const Text("Select Team Member"),
      items: teamMembers.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.value, // UID of the team member
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.blue.shade800), // Optional icon
              const SizedBox(width: 10),
              Text("${entry.key}", // Display both name and UID
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

