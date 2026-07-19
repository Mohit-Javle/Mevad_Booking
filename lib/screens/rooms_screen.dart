import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../data/mock_data.dart';
import '../widgets/room_card.dart';
import '../providers/language_provider.dart';
import 'room_booking_screen.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

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
                    child: Text(
                      'મ',
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

          // Page header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    langProv.translate('our_rooms'),
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    langProv.translate('reserve_your_stay'),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Room cards
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: RoomCard(
                  room: MockData.rooms[index],
                  onBookNow: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RoomBookingScreen(room: MockData.rooms[index]),
                      ),
                    );
                  },
                ),
              ),
              childCount: MockData.rooms.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
