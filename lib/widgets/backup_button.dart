import 'package:flutter/material.dart';

import '../style/app_colors.dart';

class BackupButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isDanger;

  const BackupButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
            isDanger ? AppColors.background : AppColors.lightTone,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isDanger ? Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ) : Text(
            label,
            style: const TextStyle(
              color: AppColors.background,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}