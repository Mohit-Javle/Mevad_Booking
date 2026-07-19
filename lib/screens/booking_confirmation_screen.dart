import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../models/booking.dart';
import '../providers/language_provider.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Booking booking;

  const BookingConfirmationScreen({super.key, required this.booking});

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Success animation
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 64,
                      color: AppColors.success,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        langProv.translate('booking_confirmed'),
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        langProv.translate('success_desc'),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Booking Summary Card
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cardBorder, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Booking ID
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.saffron.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.confirmation_number_outlined,
                                  size: 16, color: AppColors.saffron),
                              const SizedBox(width: 8),
                              Text(
                                '${langProv.currentLanguage == 'gu' ? 'બુકિંગ આઈડી' : 'Booking ID'}: ${widget.booking.id}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.saffron,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        _DetailRow(
                          icon: Icons.person_outline,
                          label: langProv.currentLanguage == 'gu' ? 'મહેમાન' : 'Guest',
                          value: widget.booking.guestName,
                        ),
                        const Divider(height: 20),
                        _DetailRow(
                          icon: Icons.bed_outlined,
                          label: langProv.translate('rooms'),
                          value: langProv.translate(widget.booking.roomNameKey),
                        ),
                        const Divider(height: 20),
                        _DetailRow(
                          icon: Icons.calendar_today_outlined,
                          label: langProv.translate('check_in'),
                          value: DateFormat('dd MMM yyyy').format(widget.booking.checkIn),
                        ),
                        const Divider(height: 20),
                        _DetailRow(
                          icon: Icons.calendar_today_outlined,
                          label: langProv.translate('check_out'),
                          value: DateFormat('dd MMM yyyy').format(widget.booking.checkOut),
                        ),
                        const Divider(height: 20),
                        _DetailRow(
                          icon: Icons.nights_stay_outlined,
                          label: langProv.currentLanguage == 'gu' ? 'સમયગાળો' : 'Duration',
                          value: '${widget.booking.nights} ${langProv.translate(widget.booking.nights > 1 ? 'nights' : 'night')}',
                        ),
                        const Divider(height: 20),
                        _DetailRow(
                          icon: Icons.people_outline,
                          label: langProv.translate('guests'),
                          value: '${widget.booking.numberOfGuests}',
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.currency_rupee_rounded,
                                size: 18, color: AppColors.saffron),
                            const SizedBox(width: 12),
                            Text(
                              langProv.translate('total_paid'),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '₹${widget.booking.totalAmount.toInt()}',
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.saffron,
                                ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                      const SizedBox(width: 8),
                      Text(
                        langProv.currentLanguage == 'gu' ? 'ચુકવણી સફળ રહી' : 'Payment Successful',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(langProv.translate('receipt_downloaded'))),
                      );
                    },
                    icon: const Icon(Icons.download_rounded),
                    label: Text(langProv.translate('download_receipt')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.saffron,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      langProv.translate('back_home'),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
