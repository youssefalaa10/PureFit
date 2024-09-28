
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.h),
      leading: Icon(icon, size: 28.sp),
      title: Text(
        label,
        style: TextStyle(fontSize: 18.sp),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 20.sp),
      onTap: onTap,
    );
  }
}
