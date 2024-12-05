import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanagement/screens/home.dart';
import 'package:taskmanagement/screens/user/assign_task_list.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.orangeAccent[700],
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 40,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Email',
                              enabled: true,
                              contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Email cannot be empty";
                              }
                              if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: passwordController,
                            obscureText: _isObscure3,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(_isObscure3 ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure3 = !_isObscure3;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Password',
                              enabled: true,
                              contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              RegExp regex = RegExp(r'^.{6,}$');
                              if (value!.isEmpty) {
                                return "Password cannot be empty";
                              }
                              if (!regex.hasMatch(value)) {
                                return "Please enter a valid password (min. 6 characters)";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),
                          MaterialButton(
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            elevation: 5.0,
                            height: 40,
                            onPressed: () {
                              setState(() {
                                visible = true;
                              });
                              signIn(emailController.text, passwordController.text);
                            },
                            color: Colors.white,
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Visibility(
                            visible: visible,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                          // MaterialButton(
                          //   shape: const RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          //   ),
                          //   elevation: 5.0,
                          //   height: 40,
                          //   onPressed: () {
                          //     Navigator.pushReplacement(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => const Register(),
                          //       ),
                          //     );
                          //   },
                          //   color: Colors.blue[900],
                          //   child: const Text(
                          //     "Register Now",
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 20,
                          //     ),
                          //   ),
                          // ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text('don\'t have an account?'),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Register()),
                                    );
                                  },
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void route() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String role = '';

      // Step 1: Attempt to retrieve role from 'users' collection
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userSnapshot.exists) {
        // Get the role from the 'users' collection
        role = userSnapshot.get('role') ?? '';
      } else {
        // Step 2: If not found in 'users', attempt to retrieve from 'team_members'
        DocumentSnapshot teamMemberSnapshot = await FirebaseFirestore.instance.collection('team_members').doc(user.uid).get();
        if (teamMemberSnapshot.exists) {
          // Get the role from the 'team_members' collection
          role = teamMemberSnapshot.get('role') ?? '';
        } else {
          print('User document does not exist in either Firestore collection');
        }
      }

      // Step 3: Navigate based on the retrieved role
      // if (role == "Teacher") {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => AdminHomeScreen()),
      //   );
      // } else if (role == "User" || role == "user") {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => AssignedTaskListScreen()),
      //   );
      // } else {
      //   print("Invalid role assigned to user.");
      // }
      if (role == "Teacher") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen()),
        );
      } else if (role == "User" || role == "user") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AssignedTaskListScreen()),
        );
      } else {
        print("Invalid role assigned to user.");
      }
    }
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
