import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../models/room.dart';
import '../providers/language_provider.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback? onBookNow;
  final bool compact;

  const RoomCard({
    super.key,
    required this.room,
    this.onBookNow,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();
    if (compact) return _buildCompactCard(context, langProv);
    return _buildFullCard(context, langProv);
  }

  // Compact card for horizontal scrolling on home screen
  Widget _buildCompactCard(BuildContext context, LanguageProvider langProv) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                'assets/images/${room.imageAsset}.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: room.isAC
                            ? [const Color(0xFFE3D5CA), const Color(0xFFF5EBE0)]
                            : [const Color(0xFFD5C4A1), const Color(0xFFF0E6D3)],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            room.isAC ? Icons.ac_unit_rounded : Icons.bed_rounded,
                            size: 48,
                            color: AppColors.maroon.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            room.name,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.maroon.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  langProv.translate(room.nameKey),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '₹${room.pricePerNight.toInt()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.saffron,
                        ),
                      ),
                      TextSpan(
                        text: ' / ${langProv.translate('per_night')}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Full card for the Rooms screen
  Widget _buildFullCard(BuildContext context, LanguageProvider langProv) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/${room.imageAsset}.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: room.isAC
                                  ? [const Color(0xFFE3D5CA), const Color(0xFFF5EBE0)]
                                  : [const Color(0xFFD5C4A1), const Color(0xFFF0E6D3)],
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  room.isAC ? Icons.ac_unit_rounded : Icons.bed_rounded,
                                  size: 64,
                                  color: AppColors.maroon.withValues(alpha: 0.4),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  langProv.translate(room.nameKey),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.maroon.withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // AC badge
                  if (room.isAC)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.saffron,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.ac_unit, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'AC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  langProv.translate(room.nameKey),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  langProv.translate(room.descKey),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Amenities row
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: room.amenities.take(4).map((a) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Text(
                      langProv.translate(a),
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    // Capacity
                    const Icon(Icons.people_outline, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${langProv.translate('up_to')} ${room.capacity} ${langProv.translate('guests')}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    // Availability
                    const Icon(Icons.check_circle_outline, size: 16, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text(
                      '${room.availableCount} ${langProv.translate('available')}',
                      style: const TextStyle(fontSize: 12, color: AppColors.success),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '₹${room.pricePerNight.toInt()}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.saffron,
                            ),
                          ),
                          TextSpan(
                            text: ' / ${langProv.translate('per_night')}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onBookNow,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(langProv.translate('book_room')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
