import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../models/room.dart';
import '../widgets/date_picker_field.dart';
import '../providers/language_provider.dart';
import 'payment_screen.dart';

class RoomBookingScreen extends StatefulWidget {
  final Room room;

  const RoomBookingScreen({super.key, required this.room});

  @override
  State<RoomBookingScreen> createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _guestsController = TextEditingController(text: '1');
  final _communityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double get _totalAmount {
    if (_checkIn == null || _checkOut == null) return 0;
    final nights = _checkOut!.difference(_checkIn!).inDays;
    return nights * widget.room.pricePerNight;
  }

  int get _nights {
    if (_checkIn == null || _checkOut == null) return 0;
    return _checkOut!.difference(_checkIn!).inDays;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _guestsController.dispose();
    _communityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();

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
          langProv.translate('book_room'),
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder, width: 0.5),
                ),
                child: Row(
                  children: [
                    // Room icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.saffron.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        widget.room.isAC ? Icons.ac_unit_rounded : Icons.bed_rounded,
                        size: 32,
                        color: AppColors.saffron,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            langProv.translate(widget.room.nameKey),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.people_outline, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                '${langProv.translate('up_to')} ${widget.room.capacity} ${langProv.translate('guests')}',
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '₹${widget.room.pricePerNight.toInt()}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.saffron,
                                  ),
                                ),
                                TextSpan(
                                  text: ' / ${langProv.translate('night')}',
                                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Date Selection
              Text(
                langProv.translate('select_dates'),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DatePickerField(
                      label: langProv.translate('check_in'),
                      selectedDate: _checkIn,
                      onDateSelected: (date) {
                        setState(() {
                          _checkIn = date;
                          if (_checkOut != null && _checkOut!.isBefore(date.add(const Duration(days: 1)))) {
                            _checkOut = null;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DatePickerField(
                      label: langProv.translate('check_out'),
                      selectedDate: _checkOut,
                      firstDate: _checkIn?.add(const Duration(days: 1)),
                      onDateSelected: (date) {
                        setState(() => _checkOut = date);
                      },
                    ),
                  ),
                ],
              ),
              if (_nights > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.saffron.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.nights_stay_outlined, size: 16, color: AppColors.saffron),
                      const SizedBox(width: 6),
                      Text(
                        '$_nights ${langProv.translate(_nights > 1 ? 'nights' : 'night')}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.saffron,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 28),

              // Guest Details
              Text(
                langProv.translate('guest_details'),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Full Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: langProv.translate('full_name'),
                  hintText: langProv.currentLanguage == 'gu' ? 'તમારું પૂરું નામ લખો' : 'Enter your full name',
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 14),

              // Phone
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: langProv.translate('phone_number'),
                  hintText: '+91 XXXXX XXXXX',
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textSecondary),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 14),

              // Number of Guests
              TextFormField(
                controller: _guestsController,
                decoration: InputDecoration(
                  labelText: langProv.translate('number_of_guests'),
                  prefixIcon: const Icon(Icons.people_outline, color: AppColors.textSecondary),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  final n = int.tryParse(v);
                  if (n == null || n < 1) return 'Invalid';
                  if (n > widget.room.capacity) return 'Max ${widget.room.capacity}';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Community (optional)
              TextFormField(
                controller: _communityController,
                decoration: InputDecoration(
                  labelText: langProv.translate('community'),
                  hintText: 'e.g. Shwetambar, Digambar',
                  prefixIcon: const Icon(Icons.group_outlined, color: AppColors.textSecondary),
                ),
              ),

              const SizedBox(height: 28),

              // Price Summary
              if (_totalAmount > 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    children: [
                      _PriceRow(
                        label: '${langProv.translate(widget.room.nameKey)} × $_nights ${langProv.translate(_nights > 1 ? 'nights' : 'night')}',
                        amount: '₹${_totalAmount.toInt()}',
                      ),
                      const Divider(height: 20),
                      _PriceRow(
                        label: langProv.translate('total'),
                        amount: '₹${_totalAmount.toInt()}',
                        isBold: true,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Proceed Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _checkIn != null && _checkOut != null
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PaymentScreen(
                                  room: widget.room,
                                  checkIn: _checkIn!,
                                  checkOut: _checkOut!,
                                  guestName: _nameController.text,
                                  phone: _phoneController.text,
                                  numberOfGuests: int.parse(_guestsController.text),
                                  community: _communityController.text.isEmpty
                                      ? null
                                      : _communityController.text,
                                  totalAmount: _totalAmount,
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.maroon,
                    disabledBackgroundColor: AppColors.maroon.withValues(alpha: 0.3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    langProv.translate('proceed_payment'),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isBold;

  const _PriceRow({
    required this.label,
    required this.amount,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.poppins(
            fontSize: isBold ? 20 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? AppColors.saffron : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
