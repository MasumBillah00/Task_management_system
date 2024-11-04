// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'login_event.dart';
// import 'login_state.dart';
//
// class LoginBloc extends Bloc<LoginEvent, LoginState> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   LoginBloc() : super(LoginInitial());
//
//   @override
//   Stream<LoginState> mapEventToState(LoginEvent event) async* {
//     if (event is LoginButtonPressed) {
//       yield LoginLoading();
//
//       try {
//         UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: event.email,
//           password: event.password,
//         );
//
//         User? user = userCredential.user;
//         if (user != null) {
//           DocumentSnapshot userDoc = await FirebaseFirestore.instance
//               .collection('users')
//               .doc(user.uid)
//               .get();
//
//           if (userDoc.exists) {
//             final isTeacher = userDoc.get('rool') == "Teacher";
//             yield LoginSuccess(isTeacher: isTeacher);
//           } else {
//             yield LoginFailure(error: 'User role not found.');
//           }
//         }
//       } on FirebaseAuthException catch (e) {
//         yield LoginFailure(
//           error: e.code == 'user-not-found'
//               ? 'No user found for that email.'
//               : 'Wrong password provided.',
//         );
//       }
//     }
//   }
// }
