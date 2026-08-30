import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/core/widgets/custom_text_field.dart';
import 'package:book_ease/features/admin/presentation/views/widgets/admin_view_body.dart';
import 'package:flutter/material.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 200,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff1E1B4B), Color(0xff312E81)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ADMIN PANEL",
                              style: TextStyle(
                                color: Color(0xffA5B4FC),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Dashboard",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ScaleOnTap(
                        onTap: () {},
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: .15),
                            ),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const CustomTextField(
                    style: TextStyle(color: Colors.white),
                    hintText: "Live · 34 appointments today",
                    fillColor: Color(0xff3730A3),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(
                        Icons.circle,
                        color: AppColors.success,
                        size: 10,
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 18),
                      child: Icon(
                        Icons.show_chart_rounded,
                        color: AppColors.success,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: Color(0xffC7D2FE),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: const AdminViewBody(),
    );
  }
}
