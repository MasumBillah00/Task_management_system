import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'loginpage.dart';

class Register extends StatefulWidget {
  const Register({super.key});
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  RegisterState();

  bool showProgress = false;
  bool visible = false;

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;
  var options = [
    'User',
    'Admin',
  ];
  var _currentItemSelected = "User";
  var role = "User";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[900],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.orangeAccent[700],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        const Text(
                          "Register Now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        const SizedBox(height: 50),

                        // Name Input Field
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Name',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Name cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Email Input Field
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
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
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

                        // Password Input Field
                        TextFormField(
                          obscureText: _isObscure,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Password',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters long";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Confirm Password Input Field
                        TextFormField(
                          obscureText: _isObscure2,
                          controller: confirmpassController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure2 ? Icons.visibility_off : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Confirm Password',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value != passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Role Selection
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Role : ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            DropdownButton<String>(
                              dropdownColor: Colors.blue[900],
                              isDense: true,
                              isExpanded: false,
                              iconEnabledColor: Colors.white,
                              focusColor: Colors.white,
                              items: options.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(
                                    dropDownStringItem,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                setState(() {
                                  _currentItemSelected = newValueSelected!;
                                  role = newValueSelected;
                                });
                              },
                              value: _currentItemSelected,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Register Button
                        MaterialButton(
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                          elevation: 5.0,
                          height: 40,
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              signUp(emailController.text, passwordController.text, role);
                            }
                          },
                          color: Colors.white,
                          child: const Text(
                            "Register",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signUp(String email, String password, String role) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(email, role)})
          .catchError((e) {
        print("Error: $e");
      });
    }
  }

  void postDetailsToFirestore(String email, String role) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    await firebaseFirestore.collection('users').doc(user!.uid).set({
      'name': nameController.text, // Capture name input
      'email': email,
      'role': role,
      'uid': user.uid,
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}




// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import 'loginpage.dart';
//
// class Register extends StatefulWidget {
//   const Register({super.key});
//
//   @override
//   RegisterState createState() => RegisterState();
// }
//
// class RegisterState extends State<Register> {
//   RegisterState();
//
//   bool showProgress = false;
//   bool visible = false;
//
//   final _formkey = GlobalKey<FormState>();
//   final _auth = FirebaseAuth.instance;
//
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmpassController = TextEditingController();
//   final TextEditingController name = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController mobile = TextEditingController();
//   bool _isObscure = true;
//   bool _isObscure2 = true;
//   File? file;
//   var options = [
//     'User',
//     'Admin',
//   ];
//   var _currentItemSelected = "User";
//   var rool = "User";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.orange[900],
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               color: Colors.orangeAccent[700],
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               child: SingleChildScrollView(
//                 child: Container(
//                   margin: const EdgeInsets.all(12),
//                   child: Form(
//                     key: _formkey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const SizedBox(
//                           height: 80,
//                         ),
//                         const Text(
//                           "Register Now",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             fontSize: 40,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         const SizedBox(
//                           height: 50,
//                         ),
//                         TextFormField(
//                           controller: emailController,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Email',
//                             enabled: true,
//                             contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return "Email cannot be empty";
//                             }
//                             if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
//                               return ("Please enter a valid email");
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {},
//                           keyboardType: TextInputType.emailAddress,
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         TextFormField(
//                           obscureText: _isObscure,
//                           controller: passwordController,
//                           decoration: InputDecoration(
//                             suffixIcon: IconButton(
//                                 icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
//                                 onPressed: () {
//                                   setState(() {
//                                     _isObscure = !_isObscure;
//                                   });
//                                 }),
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Password',
//                             enabled: true,
//                             contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           validator: (value) {
//                             RegExp regex = RegExp(r'^.{6,}$');
//                             if (value!.isEmpty) {
//                               return "Password cannot be empty";
//                             }
//                             if (!regex.hasMatch(value)) {
//                               return ("please enter valid password min. 6 character");
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {},
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         TextFormField(
//                           obscureText: _isObscure2,
//                           controller: confirmpassController,
//                           decoration: InputDecoration(
//                             suffixIcon: IconButton(
//                                 icon: Icon(_isObscure2 ? Icons.visibility_off : Icons.visibility),
//                                 onPressed: () {
//                                   setState(() {
//                                     _isObscure2 = !_isObscure2;
//                                   });
//                                 }),
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Confirm Password',
//                             enabled: true,
//                             contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (confirmpassController.text != passwordController.text) {
//                               return "Password did not match";
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {},
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Role : ",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             DropdownButton<String>(
//                               dropdownColor: Colors.blue[900],
//                               isDense: true,
//                               isExpanded: false,
//                               iconEnabledColor: Colors.white,
//                               focusColor: Colors.white,
//                               items: options.map((String dropDownStringItem) {
//                                 return DropdownMenuItem<String>(
//                                   value: dropDownStringItem,
//                                   child: Text(
//                                     dropDownStringItem,
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               onChanged: (newValueSelected) {
//                                 setState(() {
//                                   _currentItemSelected = newValueSelected!;
//                                   rool = newValueSelected;
//                                 });
//                               },
//                               value: _currentItemSelected,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             MaterialButton(
//                               shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                               elevation: 5.0,
//                               height: 40,
//                               onPressed: () {
//                                 const CircularProgressIndicator();
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => LoginPage(),
//                                   ),
//                                 );
//                               },
//                               color: Colors.white,
//                               child: const Text(
//                                 "Login",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                             MaterialButton(
//                               shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                               elevation: 5.0,
//                               height: 40,
//                               onPressed: () {
//                                 setState(() {
//                                   showProgress = true;
//                                 });
//                                 signUp(emailController.text, passwordController.text, rool);
//                               },
//                               color: Colors.white,
//                               child: const Text(
//                                 "Register",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void signUp(String email, String password, String rool) async {
//     const CircularProgressIndicator();
//     if (_formkey.currentState!.validate()) {
//       await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) => {postDetailsToFirestore(email, rool)}).catchError((e) {});
//     }
//   }
//
//   postDetailsToFirestore(String email, String role) async {
//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//     User? user = _auth.currentUser;
//
//     await firebaseFirestore.collection('users').doc(user!.uid).set({
//       'name': name.text, // Assuming you have a name field in registration
//       'email': email,
//       'role': role, // Role is determined by dropdown (e.g., 'User' or 'Admin')
//       'uid': user.uid,
//     });
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//     );
//   }
//
//
// // postDetailsToFirestore(String email, String rool) async {
//   //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//   //   var user = _auth.currentUser;
//   //   CollectionReference ref = FirebaseFirestore.instance.collection('users');
//   //   ref.doc(user!.uid).set({'email': emailController.text, 'rool': rool});
//   //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
//   // }
// }
