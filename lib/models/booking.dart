enum BookingStatus { confirmed, pending, cancelled }

class Booking {
  final String id;
  final String guestName;
  final String phone;
  final String roomId;
  final String roomName;
  final DateTime checkIn;
  final DateTime checkOut;
  final int numberOfGuests;
  final String? community;
  final double totalAmount;
  BookingStatus status;
  final DateTime createdAt;
  bool isRead;

  Booking({
    required this.id,
    required this.guestName,
    required this.phone,
    required this.roomId,
    required this.roomName,
    required this.checkIn,
    required this.checkOut,
    required this.numberOfGuests,
    this.community,
    required this.totalAmount,
    this.status = BookingStatus.confirmed,
    DateTime? createdAt,
    this.isRead = false,
  }) : createdAt = createdAt ?? DateTime.now();

  int get nights => checkOut.difference(checkIn).inDays;

  String get roomNameKey => '${roomId}_name';
}
