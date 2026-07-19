enum EventBookingStatus { pending, confirmed, rejected }

class EventBooking {
  final String id;
  final String eventType;
  final DateTime fromDate;
  final DateTime toDate;
  final int expectedGuests;
  final String fullName;
  final String phone;
  final String? notes;
  EventBookingStatus status;
  final DateTime createdAt;
  bool isRead;

  EventBooking({
    required this.id,
    required this.eventType,
    required this.fromDate,
    required this.toDate,
    required this.expectedGuests,
    required this.fullName,
    required this.phone,
    this.notes,
    this.status = EventBookingStatus.pending,
    DateTime? createdAt,
    this.isRead = false,
  }) : createdAt = createdAt ?? DateTime.now();

  int get days => toDate.difference(fromDate).inDays;
}
