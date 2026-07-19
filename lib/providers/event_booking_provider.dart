import 'package:flutter/material.dart';
import '../models/event_booking.dart';
import '../data/mock_data.dart';

class EventBookingProvider extends ChangeNotifier {
  final List<EventBooking> _eventBookings = List.from(MockData.sampleEventBookings);
  int _bookingCounter = 3;

  List<EventBooking> get eventBookings => List.unmodifiable(_eventBookings);

  List<EventBooking> get pendingRequests =>
      _eventBookings.where((b) => b.status == EventBookingStatus.pending).toList();

  int get unreadCount => _eventBookings.where((b) => !b.isRead).length;

  EventBooking addEventBooking({
    required String eventType,
    required DateTime fromDate,
    required DateTime toDate,
    required int expectedGuests,
    required String fullName,
    required String phone,
    String? notes,
  }) {
    _bookingCounter++;
    final booking = EventBooking(
      id: 'EB-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${_bookingCounter.toString().padLeft(2, '0')}',
      eventType: eventType,
      fromDate: fromDate,
      toDate: toDate,
      expectedGuests: expectedGuests,
      fullName: fullName,
      phone: phone,
      notes: notes,
      status: EventBookingStatus.pending,
    );
    _eventBookings.insert(0, booking);
    notifyListeners();
    return booking;
  }

  void updateStatus(String bookingId, EventBookingStatus status) {
    final index = _eventBookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _eventBookings[index].status = status;
      notifyListeners();
    }
  }

  void markAsRead(String bookingId) {
    final index = _eventBookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _eventBookings[index].isRead = true;
      notifyListeners();
    }
  }
}
