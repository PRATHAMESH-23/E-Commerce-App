import 'package:flutter/material.dart';

class CustomAppicon extends StatelessWidget {
  const CustomAppicon({super.key, required this.icon, this.onButtonClicked});

  final Function()? onButtonClicked;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: onButtonClicked,
      ),
    );
  }
}
