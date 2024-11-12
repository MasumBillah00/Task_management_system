import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../logic/task/task_list_provider.dart';

class TeamMemberFilterPage extends StatelessWidget {
  const TeamMemberFilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskListProvider>(context);

    return Container(
      height: 40,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: provider.selectedTeamMember,
        onChanged: (value) {
          provider.applyTeamMemberFilter(context, value);
        },
        items: [
          const DropdownMenuItem<String>(
            value: "All",
            child: Text("All"),
          ),
          ...provider.teamMembers.map((memberName) {
            return DropdownMenuItem<String>(
              value: memberName,
              child: Text(memberName),
            );
          }).toList(),
        ],
      ),
    );
  }
}
