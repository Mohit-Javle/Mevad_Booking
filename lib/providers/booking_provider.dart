import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../data/mock_data.dart';

class BookingProvider extends ChangeNotifier {
  final List<Booking> _bookings = List.from(MockData.sampleBookings);
  int _bookingCounter = 5;

  List<Booking> get bookings => List.unmodifiable(_bookings);

  List<Booking> get userBookings =>
      _bookings.where((b) => b.createdAt.isAfter(DateTime(2026, 7, 4))).toList();

  List<Booking> get pendingBookings =>
      _bookings.where((b) => b.status == BookingStatus.pending).toList();

  List<Booking> get confirmedBookings =>
      _bookings.where((b) => b.status == BookingStatus.confirmed).toList();

  int get unreadCount => _bookings.where((b) => !b.isRead).length;

  int get todayBookings {
    final today = DateTime.now();
    return _bookings
        .where((b) =>
            b.checkIn.year == today.year &&
            b.checkIn.month == today.month &&
            b.checkIn.day == today.day)
        .length;
  }

  Booking addBooking({
    required String guestName,
    required String phone,
    required String roomId,
    required String roomName,
    required DateTime checkIn,
    required DateTime checkOut,
    required int numberOfGuests,
    String? community,
    required double totalAmount,
  }) {
    _bookingCounter++;
    final booking = Booking(
      id: 'BK-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${_bookingCounter.toString().padLeft(2, '0')}',
      guestName: guestName,
      phone: phone,
      roomId: roomId,
      roomName: roomName,
      checkIn: checkIn,
      checkOut: checkOut,
      numberOfGuests: numberOfGuests,
      community: community,
      totalAmount: totalAmount,
      status: BookingStatus.confirmed,
    );
    _bookings.insert(0, booking);
    notifyListeners();
    return booking;
  }

  void updateStatus(String bookingId, BookingStatus status) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index].status = status;
      notifyListeners();
    }
  }

  void markAsRead(String bookingId) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (final booking in _bookings) {
      booking.isRead = true;
    }
    notifyListeners();
  }
}
