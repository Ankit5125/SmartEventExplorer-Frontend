import 'package:flutter/material.dart';
import 'package:smart_event_explorer_frontend/theme/TextTheme.dart';

class EventDetailsSectionWidget extends StatelessWidget {
  final String title;
  final Widget child;
  const EventDetailsSectionWidget({
    required this.title,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        spacing: 20,
        mainAxisAlignment: .spaceEvenly,
        crossAxisAlignment: .start,
        children: [
          Text(title, style: MyTextTheme.NormalStyle(color : Colors.white)),
          child,
        ],
      ),
    );
  }
}
