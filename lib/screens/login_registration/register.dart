// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import 'loginpage.dart';
//
// class Register extends StatefulWidget {
//   const Register({super.key});
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
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController mobile = TextEditingController();
//   bool _isObscure = true;
//   bool _isObscure2 = true;
//   File? file;
//   var options = [
//     'User',
//     'Teacher',
//   ];
//   var _currentItemSelected = "User";
//   var role = "User";
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
//                         const SizedBox(height: 50),
//
//                         // Name Input Field
//                         TextFormField(
//                           controller: nameController,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Name',
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
//                               return "Name cannot be empty";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Email Input Field
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
//                               return "Please enter a valid email";
//                             }
//                             return null;
//                           },
//                           keyboardType: TextInputType.emailAddress,
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Password Input Field
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
//                             if (value!.isEmpty) {
//                               return "Password cannot be empty";
//                             }
//                             if (value.length < 6) {
//                               return "Password must be at least 6 characters long";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Confirm Password Input Field
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
//                             if (value != passwordController.text) {
//                               return "Passwords do not match";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Role Selection
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
//                                   role = newValueSelected;
//                                 });
//                               },
//                               value: _currentItemSelected,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Register Button
//                         MaterialButton(
//                           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                           elevation: 5.0,
//                           height: 40,
//                           onPressed: () {
//                             if (_formkey.currentState!.validate()) {
//                               signUp(emailController.text, passwordController.text, role);
//                             }
//                           },
//                           color: Colors.white,
//                           child: const Text(
//                             "Register",
//                             style: TextStyle(fontSize: 20),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
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
//   void signUp(String email, String password, String role) async {
//     if (_formkey.currentState!.validate()) {
//       await _auth
//           .createUserWithEmailAndPassword(email: email, password: password)
//           .then((value) => {postDetailsToFirestore(email, role)})
//           .catchError((e) {
//         print("Error: $e");
//       });
//     }
//   }
//
//   void postDetailsToFirestore(String email, String role) async {
//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//     User? user = _auth.currentUser;
//
//     await firebaseFirestore.collection('users').doc(user!.uid).set({
//       'name': nameController.text, // Capture name input
//       'email': email,
//       'role': role,
//       'uid': user.uid,
//     });
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'loginpage.dart';

class Register extends StatefulWidget {
  const Register({super.key});
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  bool showProgress = false;

  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool _isObscure = true;

  var options = ['User', 'Teacher'];
  var _currentItemSelected = "User";
  var role = "User";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[900],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.orangeAccent[700],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
                        const Text(
                          "Register Now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        const SizedBox(height: 50),
                        buildTextField("Name", nameController, false, null),
                        const SizedBox(height: 20),
                        buildTextField(
                          "Email",
                          emailController,
                          false,
                              (value) {
                            if (value == null || value.isEmpty) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]+$").hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          "Password",
                          passwordController,
                          true,
                              (value) {
                            if (value == null || value.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters long";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          "Confirm Password",
                          confirmPassController,
                          true,
                              (value) {
                            if (value != passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        roleSelection(),
                        const SizedBox(height: 20),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          elevation: 5.0,
                          height: 40,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                showProgress = true;
                              });
                              signUp(
                                emailController.text,
                                passwordController.text,
                                role,
                              );
                            }
                          },
                          color: Colors.white,
                          child: showProgress
                              ? const CircularProgressIndicator(
                            color: Colors.orange,
                          )
                              : const Text(
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

  Widget buildTextField(String label, TextEditingController controller, bool isPassword,
      String? Function(String?)? validator) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _isObscure : false,
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        )
            : null,
        filled: true,
        fillColor: Colors.white,
        hintText: label,
        enabled: true,
        focusedBorder:
        OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder:
        OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      validator: validator ??
              (value) => value == null || value.isEmpty
              ? "$label cannot be empty"
              : null,
    );
  }

  Widget roleSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Role: ",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        DropdownButton<String>(
          dropdownColor: Colors.orange,
          value: _currentItemSelected,
          items: options.map((String role) {
            return DropdownMenuItem(
              value: role,
              child: Text(
                role,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentItemSelected = value!;
              role = value;
            });
          },
        ),
      ],
    );
  }

  void signUp(String email, String password, String role) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await postDetailsToFirestore(email, role);
    } on FirebaseAuthException catch (e) {
      setState(() {
        showProgress = false;
      });
      String errorMessage =
      e.code == 'email-already-in-use' ? "Email already in use" : "An error occurred";
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  Future<void> postDetailsToFirestore(String email, String role) async {
    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text("User is not logged in.")));
      return;
    }
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'name': nameController.text,
      'email': email,
      'role': role,
      'uid': user.uid,
    });
    setState(() {
      showProgress = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Ensure LoginPage is defined
    );
  }
}
