// import 'package:flutter/material.dart';
//
// class DeadlinePicker extends StatelessWidget {
//   final DateTime? selectedDeadline;
//   final ValueChanged<DateTime> onDeadlineSelected;
//
//   const DeadlinePicker({
//     Key? key,
//     required this.selectedDeadline,
//     required this.onDeadlineSelected,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text("Deadline: ${selectedDeadline != null ? selectedDeadline!.toLocal().toString().split(' ')[0] : 'Select Date'}"),
//       trailing: Icon(Icons.calendar_today, color: Colors.blue.shade900),
//       onTap: () async {
//         DateTime? picked = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime.now(),
//           lastDate: DateTime(2101),
//         );
//         if (picked != null) onDeadlineSelected(picked);
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';

class DeadlinePicker extends StatelessWidget {
  final DateTime? selectedDeadline;
  final ValueChanged<DateTime> onDeadlineSelected;

  const DeadlinePicker({
    Key? key,
    required this.selectedDeadline,
    required this.onDeadlineSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (picked != null) onDeadlineSelected(picked);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDeadline != null
                  ? selectedDeadline!.toLocal().toString().split(' ')[0]
                  : 'Assign Date',
              style: TextStyle(
                fontSize: 16,
                color: selectedDeadline != null ? Colors.black : Colors.black,
              ),
            ),
            Image.asset('assets/icon/calendar1.png',width: 35,height: 35,),
            // Icon(
            //   Icons.calendar_today,
            //   color: Colors.blue.shade900,
            // ),
          ],
        ),
      ),
    );
  }




}
