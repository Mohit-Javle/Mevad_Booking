import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../models/booking.dart';
import '../models/event_booking.dart';
import '../providers/booking_provider.dart';
import '../providers/event_booking_provider.dart';

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.maroon,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Manager Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          Consumer<BookingProvider>(
            builder: (context, provider, _) {
              final unread = provider.unreadCount;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                    onPressed: () {
                      provider.markAllAsRead();
                    },
                  ),
                  if (unread > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.saffron,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$unread',
                          style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.maroon,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Consumer2<BookingProvider, EventBookingProvider>(
              builder: (context, bookingProvider, eventProvider, _) {
                return Row(
                  children: [
                    _StatCard(
                      value: '${bookingProvider.bookings.length}',
                      label: 'Total\nBookings',
                      icon: Icons.bed_rounded,
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      value: '${bookingProvider.pendingBookings.length}',
                      label: 'Pending\nRooms',
                      icon: Icons.pending_actions_rounded,
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      value: '${eventProvider.pendingRequests.length}',
                      label: 'Event\nRequests',
                      icon: Icons.event_note_rounded,
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              indicator: BoxDecoration(
                color: AppColors.saffron,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'Room Bookings'),
                Tab(text: 'Event Requests'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _RoomBookingsTab(),
                _EventRequestsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.saffron, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.7),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomBookingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, _) {
        final bookings = provider.bookings;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return _ManagerBookingCard(booking: booking);
          },
        );
      },
    );
  }
}

class _EventRequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventBookingProvider>(
      builder: (context, provider, _) {
        final bookings = provider.eventBookings;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return _ManagerEventCard(booking: booking);
          },
        );
      },
    );
  }
}

class _ManagerBookingCard extends StatelessWidget {
  final Booking booking;

  const _ManagerBookingCard({required this.booking});

  Color get _statusColor {
    switch (booking.status) {
      case BookingStatus.confirmed:
        return AppColors.success;
      case BookingStatus.pending:
        return AppColors.pending;
      case BookingStatus.cancelled:
        return AppColors.error;
    }
  }

  String get _statusLabel {
    switch (booking.status) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: !booking.isRead ? AppColors.saffron : AppColors.cardBorder,
          width: !booking.isRead ? 1.5 : 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!booking.isRead)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(
                color: AppColors.saffron,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Center(
                child: Text(
                  'NEW',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking.guestName,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _statusLabel,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.bed_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(booking.roomName, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${DateFormat('dd MMM').format(booking.checkIn)} – ${DateFormat('dd MMM').format(booking.checkOut)} (${booking.nights}N)',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(booking.phone, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                    const Spacer(),
                    Text(
                      '₹${booking.totalAmount.toInt()}',
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.saffron),
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

class _ManagerEventCard extends StatelessWidget {
  final EventBooking booking;

  const _ManagerEventCard({required this.booking});

  Color get _statusColor {
    switch (booking.status) {
      case EventBookingStatus.confirmed:
        return AppColors.success;
      case EventBookingStatus.pending:
        return AppColors.pending;
      case EventBookingStatus.rejected:
        return AppColors.error;
    }
  }

  String get _statusLabel {
    switch (booking.status) {
      case EventBookingStatus.confirmed:
        return 'Confirmed';
      case EventBookingStatus.pending:
        return 'Pending';
      case EventBookingStatus.rejected:
        return 'Rejected';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: !booking.isRead ? AppColors.saffron : AppColors.cardBorder,
          width: !booking.isRead ? 1.5 : 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!booking.isRead)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.saffron,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'NEW',
                style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.eventType,
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(booking.fullName, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(width: 12),
              const Icon(Icons.phone_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(booking.phone, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${DateFormat('dd MMM').format(booking.fromDate)} – ${DateFormat('dd MMM').format(booking.toDate)} (${booking.days} days)',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.people_outline, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${booking.expectedGuests} guests expected',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          if (booking.notes != null) ...[
            const SizedBox(height: 6),
            Text(
              booking.notes!,
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Action buttons for pending
          if (booking.status == EventBookingStatus.pending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<EventBookingProvider>().updateStatus(
                        booking.id,
                        EventBookingStatus.rejected,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<EventBookingProvider>().updateStatus(
                        booking.id,
                        EventBookingStatus.confirmed,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
