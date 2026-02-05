import 'package:flutter/material.dart';

class WrapperCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final Color? color;
  final VoidCallback? onTap;

  const WrapperCard({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
        decoration: BoxDecoration(
          color: color ?? Colors.grey.shade300,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}