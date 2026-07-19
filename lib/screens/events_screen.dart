import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../data/mock_data.dart';
import '../widgets/event_card.dart';
import '../widgets/date_picker_field.dart';
import '../providers/event_booking_provider.dart';
import '../providers/language_provider.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final _eventTypeController = TextEditingController();
  final _expectedGuestsController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void dispose() {
    _eventTypeController.dispose();
    _expectedGuestsController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitBooking(LanguageProvider langProv) {
    if (!_formKey.currentState!.validate()) return;
    if (_fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(langProv.translate('select_dates'))),
      );
      return;
    }

    final provider = context.read<EventBookingProvider>();
    provider.addEventBooking(
      eventType: _eventTypeController.text,
      fromDate: _fromDate!,
      toDate: _toDate!,
      expectedGuests: int.parse(_expectedGuestsController.text),
      fullName: _fullNameController.text,
      phone: _phoneController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, size: 40, color: AppColors.success),
            ),
            const SizedBox(height: 16),
            Text(
              langProv.translate('request_received'),
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              langProv.translate('request_desc'),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  // Clear form
                  _eventTypeController.clear();
                  _expectedGuestsController.clear();
                  _fullNameController.clear();
                  _phoneController.clear();
                  _notesController.clear();
                  setState(() {
                    _fromDate = null;
                    _toDate = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.saffron,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  langProv.translate('got_it'),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

          // Page Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                langProv.translate('upcoming_events'),
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          // Events list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => EventCard(event: MockData.events[index]),
              childCount: MockData.events.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFB8845A),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/main_hall.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFFD4A574), Color(0xFFB8845A)],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Dark Overlay for text readability
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.1),
                                Colors.black.withValues(alpha: 0.5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.meeting_room_outlined, size: 48, color: Colors.white.withValues(alpha: 0.7)),
                            const SizedBox(height: 8),
                            Text(
                              langProv.translate('main_hall'),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
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

          const SliverToBoxAdapter(child: SizedBox(height: 28)),

          // Event Booking Form
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder, width: 0.5),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        langProv.translate('book_event'),
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        langProv.translate('event_desc'),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      // Maroon divider
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.maroon,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Event type
                      Text(langProv.translate('event_type'), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _eventTypeController,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Chaumasa, Updhayan, Sangh',
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Dates
                      Row(
                        children: [
                          Expanded(
                            child: DatePickerField(
                              label: langProv.translate('from_date'),
                              selectedDate: _fromDate,
                              onDateSelected: (date) {
                                setState(() {
                                  _fromDate = date;
                                  if (_toDate != null && _toDate!.isBefore(date)) {
                                    _toDate = null;
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DatePickerField(
                              label: langProv.translate('to_date'),
                              selectedDate: _toDate,
                              firstDate: _fromDate,
                              onDateSelected: (date) => setState(() => _toDate = date),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Expected guests
                      Text(langProv.translate('expected_guests'), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _expectedGuestsController,
                        decoration: const InputDecoration(hintText: 'Number of people'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Name and Phone
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(langProv.translate('full_name'), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _fullNameController,
                                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(langProv.translate('phone_number'), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      Text(langProv.translate('notes'), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Any special requirements...',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _submitBooking(langProv),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.maroon,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            langProv.translate('request_booking'),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
