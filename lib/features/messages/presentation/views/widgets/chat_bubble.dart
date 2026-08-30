import 'package:book_ease/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMe;
  final bool isEdited;
  final VoidCallback? onLongPress;

  const ChatBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isMe,
    this.isEdited = false,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isMe ? Colors.white : AppColors.textPrimary;
    final timeColor =
        isMe ? Colors.white.withValues(alpha: 0.75) : AppColors.textMuted;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: onLongPress,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          decoration: BoxDecoration(
            gradient: isMe
                ? const LinearGradient(
                    colors: [
                      AppColors.primaryGradientStart,
                      AppColors.primaryGradientEnd,
                    ],
                  )
                : null,
            color: isMe ? null : Colors.white,
            border: isMe ? null : Border.all(color: AppColors.border),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isMe ? 18 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 18),
            ),
            boxShadow: [
              BoxShadow(
                color: isMe
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.shadowColor.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              const Gap(4),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isEdited) ...[
                    Text(
                      'edited',
                      style: TextStyle(
                        color: timeColor,
                        fontSize: 10.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Gap(4),
                  ],
                  Text(
                    time,
                    style: TextStyle(
                      color: timeColor,
                      fontSize: 10.5,
                    ),
                  ),
                  if (isMe) ...[
                    const Gap(4),
                    Icon(
                      Icons.done_all_rounded,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
