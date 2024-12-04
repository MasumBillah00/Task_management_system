import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanagement/screens/task_screen/task_details_screen.dart';
import '../../data/models/task_model.dart';

class CalendarTaskViewScreen extends StatefulWidget {
  @override
  _CalendarTaskViewScreenState createState() => _CalendarTaskViewScreenState();
}

class _CalendarTaskViewScreenState extends State<CalendarTaskViewScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Task>> _tasksByDate = {}; // Map of dates with their tasks

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _fetchTaskDates(); // Fetch dates with tasks on initialization
  }

  Future<void> _fetchTaskDates() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tasks').get();
    Map<DateTime, List<Task>> tasksByDate = {};

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      Task task = Task.fromMap(data);

      DateTime taskDate = DateTime(
        task.deadline.year,
        task.deadline.month,
        task.deadline.day,
      );

      if (tasksByDate.containsKey(taskDate)) {
        tasksByDate[taskDate]!.add(task);
      } else {
        tasksByDate[taskDate] = [task];
      }
    }

    setState(() {
      _tasksByDate = tasksByDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Task Calendar"),
          actions: [
            IconButton(

              icon: Image.asset('assets/icon/weekdays.png',
                width:25 ,
                height: 25,
              ),
              onPressed: () {
                setState(() {
                  _calendarFormat = CalendarFormat.week;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month_outlined,size: 25,),
              onPressed: () {
                setState(() {
                  _calendarFormat = CalendarFormat.month;
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: (day) {
                  return _tasksByDate[DateTime(day.year, day.month, day.day)] ?? [];
                },
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
             const SizedBox(
                height: 10,
              ),
              Expanded(
                child: _selectedDay == null
                    ? const Center(child: Text("Select a day to view tasks"))
                    : _buildTaskListForSelectedDate(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskListForSelectedDate() {
    DateTime selectedDate = DateTime(
      _selectedDay?.year ?? DateTime.now().year,
      _selectedDay?.month ?? DateTime.now().month,
      _selectedDay?.day ?? DateTime.now().day,
    );

    if (_tasksByDate[selectedDate] == null || _tasksByDate[selectedDate]!.isEmpty) {
      return const Center(child: Text("No tasks available"));
    }

    List<Task> tasks = _tasksByDate[selectedDate]!;
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return GestureDetector(
          onTap:() {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsScreen(task: task),
              ),
            );

          },

          child: Card(
            color: Colors.white.withOpacity(0.5),  // Slightly more opaque for better contrast
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),  // Rounded corners
            ),
            elevation: 5,
            margin:const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [

                  Icon(
                    Icons.task,
                    color: task.priority == "High" ? Colors.red : (task.priority == "Medium" ? Colors.orange : Colors.green),
                    size: 30,
                  ),
                 const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Task Name
                        Text(
                          task.taskName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Priority and Status info
                        Text(
                          "Priority: ${task.priority} | Status: ${task.status}",
                          style:const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Optional: Add a small indicator or button for actions (like a checkbox, button, or more info)
                  // IconButton(
                  //   onPressed: () {
                  //
                  //   },
                  //   icon: Icon(Icons.more_vert, color: Colors.grey),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
