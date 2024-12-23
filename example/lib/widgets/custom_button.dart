import 'package:flutter/material.dart';

import '../app_colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const CustomButton({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 40,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(0xFF, 0x43, 0x38, 0x78),
          borderRadius: BorderRadius.circular(7.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(0, 4),
              blurRadius: 10,
              spreadRadius: -3,
            )
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
