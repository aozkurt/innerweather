import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Widget child;
  final double screenHeight;

  const CustomTextField({
    super.key,
    required this.child,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.25,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: child,
    );
  }
}