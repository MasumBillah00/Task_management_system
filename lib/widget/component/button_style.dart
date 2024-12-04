import 'package:flutter/material.dart';

class GorgeousButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const GorgeousButton({Key? key, required this.label, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30), // Remove default padding to avoid extra space around button content
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        backgroundColor: Colors.transparent, // Set background to transparent
        shadowColor: Colors.blue.withOpacity(0.1), // Soft shadow color
        elevation: 4, // Shadow effect for the button
      ),
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade600], // Gradient for the background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10), // Rounded corners to match the button
        ),
        child: Container(
          // Reduced horizontal padding for a narrower button
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white, // Text color
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
          ),
        ),
      ),
    );
  }
}
