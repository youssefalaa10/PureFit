import 'package:flutter/material.dart';

import '../../../../Core/Components/media_query.dart';


class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context); 

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: mq.height(1)), 
      leading: Icon(icon, size: mq.width(7)), 
      title: Text(
        label,
        style: TextStyle(fontSize: mq.width(4.5)), 
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: mq.width(5)), 
      onTap: onTap,
    );
  }
}
