import 'package:book_ease/features/Admin/data/dashboard_state_model.dart';
import 'package:book_ease/features/Admin/data/quick_actions_model.dart';
import 'package:book_ease/features/Admin/presentation/views/widgets/dashboard_state_card.dart';
import 'package:book_ease/features/Admin/presentation/views/widgets/quick_actions_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AdminViewBody extends StatelessWidget {
  const AdminViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return DashboardStatCard(model: dashboardStates[index]);
              },
              itemCount: dashboardStates.length,
            ),
            Gap(20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Quick Actions",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(10),
            SizedBox(
              height: 150,
              child: GridView.builder(
                itemCount: quickActions.length,
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.3,
                  mainAxisSpacing: 16,
                  crossAxisCount: 1,
                ),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return QuickActionsWidget(
                    quickActionModel: quickActions[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
