import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class TaskPieChartScreen extends StatefulWidget {
  const TaskPieChartScreen({Key? key}) : super(key: key);

  @override
  _TaskPieChartScreenState createState() => _TaskPieChartScreenState();
}

class _TaskPieChartScreenState extends State<TaskPieChartScreen> {
  bool isLoading = true;
  int completedCount = 0;
  int inProgressCount = 0;
  int notStartedCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchTaskData();
  }

  Future<void> _fetchTaskData() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('tasks').get();

      int completed = 0;
      int inProgress = 0;
      int notStarted = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        switch (data['status']) {
          case 'Completed':
            completed++;
            break;
          case 'In Progress':
            inProgress++;
            break;
          case 'Not Started':
            notStarted++;
            break;
        }
      }

      setState(() {
        completedCount = completed;
        inProgressCount = inProgress;
        notStartedCount = notStarted;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Task Status Overview",style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700
          ),),
          centerTitle: true,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Task Counts",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        _buildRawDataItem("Completed", completedCount, Colors.teal),
                        _buildRawDataItem("In Progress", inProgressCount, Colors.grey.shade900),
                        _buildRawDataItem("Not Started", notStartedCount, Colors.grey.shade400),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // const Text(
                    //   "Task Status Distribution",
                    //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    // ),
                    //const SizedBox(height: 16),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sections: _getPieChartSections(),
                              centerSpaceRadius: 5, // Minimal center radius
                              sectionsSpace: 4,
                              borderData: FlBorderData(show: false),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildRawDataItem(String label, int count, Color color) {
    return Row(
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),
          ),
          child: Container(
            width: 20,
            height: 16,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Text(": $count"),
      ],
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    final total = completedCount + inProgressCount + notStartedCount;

    if (total == 0) {
      return [
        PieChartSectionData(
          color: Colors.grey,
          value: 1,
          title: "No Data",
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        )
      ];
    }

    return [
      PieChartSectionData(
        radius: 130,
        color: Colors.teal,
        value: completedCount.toDouble(),
        title: "${((completedCount / total) * 100).toStringAsFixed(1)}%",
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        radius: 130,
        color: Colors.grey.shade900,
        value: inProgressCount.toDouble(),
        title: "${((inProgressCount / total) * 100).toStringAsFixed(1)}%",
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.grey.shade400,
        radius: 130,
        value: notStartedCount.toDouble(),
        title: "${((notStartedCount / total) * 100).toStringAsFixed(1)}%",
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    ];
  }

  // List<Widget> _buildCustomLabels() {
  //   return [
  //     _buildCustomLabel("Completed", Colors.green, completedCount),
  //     const SizedBox(height: 8),
  //     _buildCustomLabel("In Progress", Colors.blue, inProgressCount),
  //     const SizedBox(height: 8),
  //     _buildCustomLabel("Not Started", Colors.red, notStartedCount),
  //   ];
  // }

  // Widget _buildCustomLabel(String label, Color color, int count) {
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Container(
  //             width: 12,
  //             height: 12,
  //             decoration: BoxDecoration(
  //               color: color,
  //               shape: BoxShape.circle,
  //             ),
  //           ),
  //           const SizedBox(width: 8),
  //           Text(
  //             "$label: $count",
  //             style: const TextStyle(fontSize: 14),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
