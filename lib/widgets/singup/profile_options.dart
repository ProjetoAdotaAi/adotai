import 'package:flutter/material.dart';
import 'package:adotai/theme/app_theme.dart';

class ProfileOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ProfileOption({
    Key? key,
    required this.label,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primaryColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppTheme.primaryColor : Colors.grey),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
