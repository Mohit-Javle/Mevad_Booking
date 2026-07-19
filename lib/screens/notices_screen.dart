import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../data/mock_data.dart';
import '../models/notice.dart';
import '../widgets/notice_card.dart';
import '../providers/language_provider.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  String _filter = 'All';

  List<Notice> get _filteredNotices {
    final now = DateTime.now();
    switch (_filter) {
      case 'Upcoming':
        return MockData.notices.where((n) => n.postedDate.isAfter(now.subtract(const Duration(days: 30)))).toList();
      case 'Past':
        return MockData.notices.where((n) => n.postedDate.isBefore(now.subtract(const Duration(days: 30)))).toList();
      default:
        return MockData.notices;
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.scaffoldBg,
            surfaceTintColor: Colors.transparent,
            toolbarHeight: 64,
            title: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.saffron,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('મ', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      langProv.translate('mewad_bhavan'),
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    Text(
                      langProv.translate('palitana_dharamshala'),
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
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
                        langProv.currentLanguage == 'en' ? 'English' : 'ગુજરાતી',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    langProv.translate('latest_notices'),
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    langProv.translate('notices'),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: ['All', 'Upcoming', 'Past'].map((filter) {
                  final isActive = _filter == filter;
                  final displayLabel = filter == 'All'
                      ? langProv.translate('all')
                      : filter == 'Upcoming'
                          ? langProv.translate('upcoming')
                          : langProv.translate('past');
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = filter),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.saffron : AppColors.cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive ? AppColors.saffron : AppColors.cardBorder,
                          ),
                        ),
                        child: Text(
                          displayLabel,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isActive ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Notice cards
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => NoticeCard(notice: _filteredNotices[index]),
              childCount: _filteredNotices.length,
            ),
          ),

          // Empty state
          if (_filteredNotices.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.4)),
                    const SizedBox(height: 12),
                    Text(
                      langProv.translate('no_notices'),
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
