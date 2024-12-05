// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_charts/flutter_charts.dart';
//
// class TaskPieChartScreen extends StatefulWidget {
//   const TaskPieChartScreen({Key? key}) : super(key: key);
//
//   @override
//   _TaskPieChartScreenState createState() => _TaskPieChartScreenState();
// }
//
// class _TaskPieChartScreenState extends State<TaskPieChartScreen> {
//   bool isLoading = true;
//   late ChartData chartData;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchTaskData();
//   }
//
//   Future<void> _fetchTaskData() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance.collection('tasks').get();
//
//       int completedCount = 0;
//       int inProgressCount = 0;
//       int notStartedCount = 0;
//
//       for (var doc in snapshot.docs) {
//         final data = doc.data();
//         switch (data['status']) {
//           case 'Completed':
//             completedCount++;
//             break;
//           case 'In Progress':
//             inProgressCount++;
//             break;
//           case 'Not Started':
//             notStartedCount++;
//             break;
//         }
//       }
//
//       // Data structure for flutter_charts
//       chartData = ChartData(
//         dataRows: [
//           [completedCount.toDouble(), inProgressCount.toDouble(), notStartedCount.toDouble()]
//         ],
//         xLabels: ['Completed', 'In Progress', 'Not Started'],
//       );
//     } catch (e) {
//       print("Error fetching data: $e");
//       chartData = ChartData(dataRows: [[]], xLabels: []);
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Task Status Overview"),
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text(
//               "Task Status Distribution",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: Chart(
//                 data: chartData,
//                 chartBehavior: ChartBehavior.pie,
//                 options: ChartOptions(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
