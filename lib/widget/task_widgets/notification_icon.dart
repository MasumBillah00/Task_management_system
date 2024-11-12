import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final int notificationCount;
  final VoidCallback? onPressed;

  const NotificationIcon({
    Key? key,
    required this.notificationCount,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:12.0),
      child: Stack(
        children: [
          IconButton(
            hoverColor: Colors.blueGrey,
            icon:  Icon(Icons.notifications,
              size: 45,
              color: Colors.blue.shade800,

            ),
            onPressed: onPressed,
          ),
          if (notificationCount > 0)
            Positioned(
              right: 12,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$notificationCount',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
