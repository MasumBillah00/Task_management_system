import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanagement/screens/team/view_team.dart';

class CreateTeamScreen extends StatefulWidget {
  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _teamNameController = TextEditingController();
  List<String> _members = []; // This will hold the member names.
  List<String> _selectedMembers = []; // Store selected members

  @override
  void initState() {
    super.initState();
    _fetchTeamMembers();
  }

  Future<void> _fetchTeamMembers() async {
    // Fetch existing team members from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('team_members').get();
    setState(() {
      _members = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<void> _createTeam() async {
    if (_teamNameController.text.isNotEmpty && _selectedMembers.isNotEmpty) {
      await FirebaseFirestore.instance.collection('teams').add({
        'teamName': _teamNameController.text,
        'members': _selectedMembers, // Store selected members in an array
      });
      _teamNameController.clear();
      setState(() {
        _selectedMembers.clear(); // Reset selected members
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Team created successfully!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Team"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _teamNameController,
              decoration: const InputDecoration(
                  labelText: "Team Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                )

              ),
            ),
            const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedMembers.contains(_members[index]);

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 1),
                  color: isSelected ? Colors.blue.shade50 : Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected ? Colors.blue : Colors.grey.shade300,
                      child: Icon(
                        isSelected ? Icons.check : Icons.person,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                    title: Text(
                      _members[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.blue.shade800 : Colors.grey.shade800,
                      ),
                    ),
                    subtitle: Text(
                      "Team Member",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    trailing: Checkbox(
                      activeColor: Colors.blue,
                      value: isSelected,
                      onChanged: (bool? isChecked) {
                        setState(() {
                          if (isChecked == true) {
                            _selectedMembers.add(_members[index]);
                          } else {
                            _selectedMembers.remove(_members[index]);
                          }
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedMembers.remove(_members[index]);
                        } else {
                          _selectedMembers.add(_members[index]);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createTeam,
              child: const Text("Create Team"),
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewTeamsScreen()),
              );
            }, child:const Text('Team'))
          ],
        ),
      ),
    );
  }
}
