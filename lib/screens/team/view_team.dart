import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewTeamsScreen extends StatelessWidget {
  const ViewTeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Teams"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('teams').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No teams available"));
            }

            List<Map<String, dynamic>> teams = snapshot.data!.docs.map((doc) {
              return {
                'teamName': doc['teamName'],
                'members': List<String>.from(doc['members']),
              };
            }).toList();

            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Team Name: ${teams[index]['teamName']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text("Members:"),
                        for (var member in teams[index]['members']) Text(member),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ViewTeamsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Teams"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('teams').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No teams available"));
//           }
//
//           List<Map<String, dynamic>> teams = snapshot.data!.docs.map((doc) {
//             return {
//               'teamName': doc['teamName'],
//               'members': List<Map<String, dynamic>>.from(doc['members']),
//             };
//           }).toList();
//
//           return ListView.builder(
//             itemCount: teams.length,
//             itemBuilder: (context, index) {
//               return Card(
//                 margin: EdgeInsets.all(8),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text("Team Name: ${teams[index]['teamName']}", style: TextStyle(fontWeight: FontWeight.bold)),
//                       SizedBox(height: 8),
//                       Text("Members:", style: TextStyle(fontWeight: FontWeight.bold)),
//                       for (var member in teams[index]['members'])
//                         _buildMemberRow(member['name'], member['role']),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildMemberRow(String memberName, String memberRole) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(memberName),
//           Text(
//             memberRole,
//             style: TextStyle(fontStyle: FontStyle.italic),
//           ),
//         ],
//       ),
//     );
//   }
// }
