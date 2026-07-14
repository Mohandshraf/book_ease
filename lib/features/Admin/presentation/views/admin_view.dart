import 'package:book_ease/core/widgets/custom_text_field.dart';
import 'package:book_ease/features/Admin/presentation/views/widgets/admin_view_body.dart';
import 'package:flutter/material.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 222,
        elevation: 0,
        backgroundColor: const Color(0xff1C2740),
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
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
                              color: Color(0xff6E7C99),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            "Dashboard",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.08),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(.08),
                        ),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                CustomTextField(
                  style: TextStyle(color: Colors.white),
                  hintText: "Live · 34 appointments today",
                  fillColor: Color(0xff2B354D),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(
                      Icons.circle,
                      color: Color(0xff34D399),
                      size: 12,
                    ),
                  ),
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 18),
                    child: Icon(
                      Icons.show_chart_rounded,
                      color: Color(0xff34D399),
                    ),
                  ),
                  hintStyle: const TextStyle(
                    color: Color(0xffAEB8CC),
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: AdminViewBody(),
    );
  }
}
