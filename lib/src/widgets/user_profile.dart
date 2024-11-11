import 'package:flutter/material.dart';

class UserProfileWidget extends StatelessWidget {
  final String name;
  final String email;
  final String profileImageUrl;

  const UserProfileWidget({
    super.key,
    required this.name,
    required this.email,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Image
        CircleAvatar(
          radius: 24, // Adjust size as needed
          backgroundImage: AssetImage(profileImageUrl),
        ),
        SizedBox(width: 12), // Space between image and text
        // Name and Email
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              email,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
