import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../models/notice.dart';
import '../providers/language_provider.dart';
import 'package:intl/intl.dart';

class NoticeCard extends StatelessWidget {
  final Notice notice;
  final bool showDate;
  final VoidCallback? onTap;

  const NoticeCard({
    super.key,
    required this.notice,
    this.showDate = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type badge + date row
            Row(
              children: [
                // Type badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: notice.type == NoticeType.event
                        ? AppColors.saffron.withValues(alpha: 0.15)
                        : AppColors.info.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        notice.type == NoticeType.event
                            ? Icons.notifications_active_outlined
                            : Icons.info_outline_rounded,
                        size: 14,
                        color: notice.type == NoticeType.event
                            ? AppColors.saffron
                            : AppColors.info,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        notice.type == NoticeType.event
                            ? langProv.translate('events')
                            : langProv.translate('notices'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: notice.type == NoticeType.event
                              ? AppColors.saffron
                              : AppColors.info,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (showDate)
                  Text(
                    'Posted • ${DateFormat('yyyy-MM-dd').format(notice.postedDate)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            // Title
            Text(
              langProv.translate(notice.titleKey),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            // Description
            Text(
              langProv.translate(notice.descKey),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact notice card for home screen (without badge)
class NoticeCardCompact extends StatelessWidget {
  final Notice notice;
  final VoidCallback? onTap;

  const NoticeCardCompact({
    super.key,
    required this.notice,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.saffron.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.saffron,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    langProv.translate(notice.titleKey),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    langProv.translate(notice.descKey),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('yyyy-MM-dd').format(notice.postedDate),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
