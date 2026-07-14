import 'package:book_ease/features/Admin/data/quick_actions_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key, required this.quickActionModel});
  final QuickActionModel quickActionModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(20),
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xffd1fae5),
            child: Icon(
              quickActionModel.icon,
              size: 30,
              color: Color(0xff059668),
            ),
          ),
          Gap(25),
          Text(
            quickActionModel.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
