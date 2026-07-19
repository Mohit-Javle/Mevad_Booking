import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../data/mock_data.dart';
import '../providers/language_provider.dart';
import '../widgets/section_header.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/room_card.dart';
import '../widgets/notice_card.dart';
import '../widgets/event_card.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.scaffoldBg,
            surfaceTintColor: Colors.transparent,
            toolbarHeight: 64,
            title: Row(
              children: [
                // Logo
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.saffron,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'म',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      langProv.translate('mewad_bhavan'),
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      langProv.translate('palitana_dharamshala'),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: (String langCode) {
                  langProv.setLanguage(langCode);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'en',
                    child: Text('English', style: GoogleFonts.inter(fontSize: 14)),
                  ),
                  PopupMenuItem(
                    value: 'hi',
                    child: Text('हिन्दी', style: GoogleFonts.inter(fontSize: 14)),
                  ),
                  PopupMenuItem(
                    value: 'gu',
                    child: Text('ગુજરાતી', style: GoogleFonts.inter(fontSize: 14)),
                  ),
                ],
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.language, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        langProv.currentLanguageName,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Hero Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFFB8845A),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/hero.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFFD4A574), Color(0xFFB8845A), Color(0xFFA06B3F)],
                                ),
                              ),
                              child: CustomPaint(
                                painter: _TemplePatternPainter(),
                              ),
                            );
                          },
                        ),
                      ),
                      // Dark gradient overlay for text readability
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.15),
                                Colors.black.withValues(alpha: 0.65),
                              ],
                            ),
                          ),
                        ),
                      ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Jai Jinendra badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  langProv.translate('jai_jinendra'),
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            langProv.translate('mewad_bhavan'),
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${langProv.translate('book_your_stay')} ${langProv.translate('palitana_dharamshala').toLowerCase()}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => onNavigateToTab?.call(1),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.saffron,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  langProv.translate('book_your_stay'),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton(
                                onPressed: () => onNavigateToTab?.call(1),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  langProv.translate('explore_rooms'),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Quick Actions Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.35,
                children: [
                  QuickActionCard(
                    icon: Icons.bed_outlined,
                    title: langProv.translate('book_a_room'),
                    subtitle: langProv.translate('reserve_your_stay'),
                    onTap: () => onNavigateToTab?.call(1),
                  ),
                  QuickActionCard(
                    icon: Icons.calendar_view_month_outlined,
                    title: langProv.translate('book_a_hall'),
                    subtitle: langProv.translate('upcoming_events'),
                    onTap: () => onNavigateToTab?.call(2),
                  ),
                  QuickActionCard(
                    icon: Icons.notifications_none_rounded,
                    title: langProv.translate('notices'),
                    subtitle: langProv.translate('latest_notices'),
                    onTap: () => onNavigateToTab?.call(3),
                  ),
                  QuickActionCard(
                    icon: Icons.phone_outlined,
                    title: langProv.translate('contact'),
                    subtitle: langProv.translate('contact'),
                    onTap: () => onNavigateToTab?.call(4),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 28)),

          // Latest Notices Section
          SliverToBoxAdapter(
            child: SectionHeader(
              title: langProv.translate('latest_notices'),
              actionLabel: langProv.translate('view_all'),
              onActionTap: () => onNavigateToTab?.call(3),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: MockData.notices.take(2).map((notice) =>
                  NoticeCardCompact(notice: notice),
                ).toList(),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 28)),

          // Our Rooms Section
          SliverToBoxAdapter(
            child: SectionHeader(
              title: langProv.translate('our_rooms'),
              actionLabel: langProv.translate('view_all'),
              onActionTap: () => onNavigateToTab?.call(1),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: MockData.rooms.length,
                itemBuilder: (context, index) {
                  return RoomCard(
                    room: MockData.rooms[index],
                    compact: true,
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 28)),

          // Upcoming Events Section
          SliverToBoxAdapter(
            child: SectionHeader(
              title: langProv.translate('upcoming_events'),
              actionLabel: langProv.translate('view_all'),
              onActionTap: () => onNavigateToTab?.call(2),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => EventCard(event: MockData.events[index]),
              childCount: MockData.events.take(3).length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// Custom painter for temple arch pattern on hero section
class _TemplePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw temple arch shapes
    for (int i = 0; i < 5; i++) {
      final x = size.width * 0.6 + (i * 40);
      final y = size.height * 0.2;
      final path = Path();
      path.moveTo(x, size.height);
      path.lineTo(x, y + 60);
      path.quadraticBezierTo(x + 20, y, x + 40, y + 60);
      path.lineTo(x + 40, size.height);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
