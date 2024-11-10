import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Calendar"),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_agenda),
            onPressed: () {
              setState(() {
                _calendarFormat = CalendarFormat.week;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined,size: 20,),
            onPressed: () {
              setState(() {
                _calendarFormat = CalendarFormat.month;
              });
            },
          ),
        ],
      ),
      body: Column(
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
          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text("Select a day to view tasks"))
                : _buildTaskListForSelectedDate(),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskListForSelectedDate() {
    DateTime selectedDate = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
    );

    if (_tasksByDate[selectedDate] == null || _tasksByDate[selectedDate]!.isEmpty) {
      return const Center(child: Text("No tasks available"));
    }

    List<Task> tasks = _tasksByDate[selectedDate]!;
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.taskName),
          subtitle: Text("Priority: ${task.priority} | Status: ${task.status}"),
        );
      },
    );
  }
}
