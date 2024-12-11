import 'package:flutter/material.dart';

class ReusableTextWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onSubtitlePressed;
  const ReusableTextWidget({super.key, required this.title, required this.subtitle,required this.onSubtitlePressed,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25,right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
          TextButton(
            onPressed: onSubtitlePressed,
            child: Text(
              subtitle,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlueAccent
              ),
            ),
          ),
        ],
      ),
    );
  }
}
