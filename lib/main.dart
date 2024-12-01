// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskmanagement/screens/login_registration/loginpage.dart';
//
// import 'logic/bloc/login/login_bloc.dart';
// import 'logic/bloc/task_bloc/task_bloc.dart'; // Adjust the import based on your structure
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => TaskBloc()), // TaskBloc
//         //BlocProvider(create: (context) => LoginBloc()), // LoginBloc
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primaryColor: Colors.blue[900],
//         ),
//         home: LoginPage(),
//
//       ),
//     );
//   }
// }
//

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagement/screens/login_registration/loginpage.dart';
import 'package:taskmanagement/screens/task_screen/task_list_screen.dart';

import 'logic/bloc/login/login_bloc.dart';
import 'logic/bloc/task_bloc/task_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TaskBloc()), // TaskBloc
        // BlocProvider(create: (context) => LoginBloc()), // LoginBloc
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue[900],
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          //'/home': (context) => AssignedTaskListScreen(), // Your main app screen
          '/tasks': (context) => const TaskListScreen(),        // Task list screen
        },
      ),
    );
  }
}
