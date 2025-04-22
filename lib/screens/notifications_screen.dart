import 'package:flutter/material.dart';
import '../widgets/home/appbar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        hasBackButton: true,
        hasNotificationIcon: false,
      ),
      body: const Center(),
    );
  }
}
