import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../models/room.dart';
import '../providers/booking_provider.dart';
import '../providers/language_provider.dart';
import 'booking_confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Room room;
  final DateTime checkIn;
  final DateTime checkOut;
  final String guestName;
  final String phone;
  final int numberOfGuests;
  final String? community;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.guestName,
    required this.phone,
    required this.numberOfGuests,
    this.community,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentMethod = 0;
  bool _isProcessing = false;

  void _processPayment() async {
    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final provider = context.read<BookingProvider>();
    final booking = provider.addBooking(
      guestName: widget.guestName,
      phone: widget.phone,
      roomId: widget.room.id,
      roomName: widget.room.name,
      checkIn: widget.checkIn,
      checkOut: widget.checkOut,
      numberOfGuests: widget.numberOfGuests,
      community: widget.community,
      totalAmount: widget.totalAmount,
    );

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => BookingConfirmationScreen(booking: booking),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();
    final nights = widget.checkOut.difference(widget.checkIn).inDays;

    final paymentMethods = [
      {'name': 'UPI', 'icon': Icons.phone_android_rounded, 'subtitle': 'Google Pay, PhonePe, Paytm'},
      {'name': langProv.currentLanguage == 'gu' ? 'કાર્ડ' : 'Card', 'icon': Icons.credit_card_rounded, 'subtitle': langProv.currentLanguage == 'gu' ? 'ક્રેડિટ / ડેબિટ કાર્ડ' : 'Credit / Debit Card'},
      {'name': langProv.currentLanguage == 'gu' ? 'નેટ બેંકિંગ' : 'Net Banking', 'icon': Icons.account_balance_rounded, 'subtitle': langProv.currentLanguage == 'gu' ? 'બધી મુખ્ય બેંકો' : 'All major banks'},
      {'name': langProv.currentLanguage == 'gu' ? 'કાઉન્ટર પર ચૂકવણી' : 'Pay at Counter', 'icon': Icons.storefront_rounded, 'subtitle': langProv.currentLanguage == 'gu' ? 'આગમન પર રોકડ' : 'Cash on arrival'},
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          langProv.translate('payment'),
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount Summary
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.maroon, Color(0xFF8B3A3A)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          langProv.translate('total_amount'),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '₹${widget.totalAmount.toInt()}',
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.room.isAC ? Icons.ac_unit : Icons.bed_rounded,
                                size: 16,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${langProv.translate(widget.room.nameKey)} • $nights ${langProv.translate(nights > 1 ? 'nights' : 'night')}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${DateFormat('dd MMM').format(widget.checkIn)} – ${DateFormat('dd MMM yyyy').format(widget.checkOut)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Payment Methods
                  Text(
                    langProv.translate('payment_method'),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...List.generate(paymentMethods.length, (index) {
                    final method = paymentMethods[index];
                    final isSelected = _selectedPaymentMethod == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPaymentMethod = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.saffron.withValues(alpha: 0.08)
                              : AppColors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.saffron : AppColors.cardBorder,
                            width: isSelected ? 1.5 : 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.saffron.withValues(alpha: 0.15)
                                    : AppColors.inputBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                method['icon'] as IconData,
                                color: isSelected ? AppColors.saffron : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    method['name'] as String,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    method['subtitle'] as String,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? AppColors.saffron : AppColors.cardBorder,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.saffron,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 12),

                  // Secure payment badge
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline, size: 14, color: AppColors.success),
                        const SizedBox(width: 6),
                        Text(
                          langProv.translate('secure_payment'),
                          style: GoogleFonts.inter(
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
          ),

          // Pay Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          '${langProv.translate('pay_now')} ₹${widget.totalAmount.toInt()}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
