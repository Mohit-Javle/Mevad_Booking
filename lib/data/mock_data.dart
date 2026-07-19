import '../models/room.dart';
import '../models/event.dart';
import '../models/notice.dart';
import '../models/booking.dart';
import '../models/event_booking.dart';

class MockData {
  MockData._();

  static final List<Room> rooms = [
    const Room(
      id: 'r1',
      name: 'Standard Non-AC Room',
      description: 'A comfortable non-AC room ideal for solo pilgrims or couples. Clean bedding, attached bathroom, and basic amenities.',
      imageAsset: 'room_standard',
      capacity: 2,
      pricePerNight: 600,
      amenities: ['Attached Bathroom', 'Clean Bedding', 'Fan', 'Hot Water', 'Locker'],
      availableCount: 12,
      isAC: false,
    ),
    const Room(
      id: 'r2',
      name: 'Family Non-AC Room',
      description: 'Spacious non-AC room for families with up to 4 guests. Two double beds, attached bathroom, and extra storage.',
      imageAsset: 'room_family',
      capacity: 4,
      pricePerNight: 1100,
      amenities: ['Attached Bathroom', 'Two Beds', 'Fan', 'Hot Water', 'Wardrobe', 'Sitting Area'],
      availableCount: 8,
      isAC: false,
    ),
    const Room(
      id: 'r3',
      name: 'Deluxe AC Suite',
      description: 'Premium air-conditioned suite with modern amenities, private balcony, and temple view. Best for families seeking comfort.',
      imageAsset: 'room_deluxe',
      capacity: 4,
      pricePerNight: 2000,
      amenities: ['AC', 'Attached Bathroom', 'Balcony', 'Temple View', 'TV', 'Wardrobe', 'Sofa'],
      availableCount: 4,
      isAC: true,
    ),
    const Room(
      id: 'r4',
      name: 'Dormitory',
      description: 'Affordable shared dormitory with clean single beds. Ideal for solo pilgrims and group yatras. Common bathroom facilities.',
      imageAsset: 'room_dormitory',
      capacity: 1,
      pricePerNight: 300,
      amenities: ['Single Bed', 'Common Bathroom', 'Fan', 'Locker'],
      availableCount: 30,
      isAC: false,
    ),
    const Room(
      id: 'r5',
      name: 'AC Double Room',
      description: 'Comfortable air-conditioned room with a double bed. Perfect for couples visiting Palitana for darshan.',
      imageAsset: 'room_ac_double',
      capacity: 2,
      pricePerNight: 1500,
      amenities: ['AC', 'Attached Bathroom', 'Double Bed', 'Hot Water', 'TV', 'Wardrobe'],
      availableCount: 6,
      isAC: true,
    ),
  ];

  static final List<Event> events = [
    Event(
      id: 'e1',
      title: 'Snatra Puja',
      date: DateTime(2026, 7, 20),
      location: 'Main Hall',
      description: 'Grand Snatra Puja ceremony to celebrate the divine bath of Tirthankara.',
    ),
    Event(
      id: 'e2',
      title: 'Pravachan by Acharya Shree',
      date: DateTime(2026, 7, 25),
      location: 'Upashray',
      description: 'Spiritual discourse by revered Acharya Shree. All devotees are welcome.',
    ),
    Event(
      id: 'e3',
      title: 'Chaumasa Begins',
      date: DateTime(2026, 7, 12),
      location: 'Mewad Bhavan',
      description: 'The holy four-month period of Chaumasa begins. Special arrangements for staying devotees.',
    ),
    Event(
      id: 'e4',
      title: 'Paryushana Parva',
      date: DateTime(2026, 8, 15),
      location: 'Mewad Bhavan',
      description: 'The most important Jain festival. Eight days of fasting, prayer, and forgiveness.',
    ),
    Event(
      id: 'e5',
      title: 'Sangh Yatra from Ahmedabad',
      date: DateTime(2026, 8, 1),
      location: 'Palitana Main Road',
      description: 'A group of 80 yatris arriving from Ahmedabad for Shatrunjay darshan.',
    ),
  ];

  static final List<Notice> notices = [
    Notice(
      id: 'n1',
      title: 'Chaumasa 2026 — Booking Open',
      description: 'Bookings for Chaumasa stay (July–November) are now open. Early booking recommended.',
      postedDate: DateTime(2026, 6, 10),
      type: NoticeType.event,
    ),
    Notice(
      id: 'n2',
      title: 'Updhyan Tap — Limited Seats',
      description: 'Updhyan tap aaradhana from 1 August. Register at the office or via this app.',
      postedDate: DateTime(2026, 6, 5),
      type: NoticeType.event,
    ),
    Notice(
      id: 'n3',
      title: 'Sangh from Mumbai arriving 20 June',
      description: 'A sangh of 120 yatris will arrive on 20 June. Hall and rooms will be reserved.',
      postedDate: DateTime(2026, 5, 28),
      type: NoticeType.info,
    ),
    Notice(
      id: 'n4',
      title: 'New AC Rooms Available',
      description: 'We have added 6 new AC rooms on the 2nd floor. Book now for summer comfort.',
      postedDate: DateTime(2026, 5, 15),
      type: NoticeType.info,
    ),
    Notice(
      id: 'n5',
      title: 'Water Conservation Drive',
      description: 'We request all guests to use water wisely. The Dharamshala follows Jain principles of Aparigraha.',
      postedDate: DateTime(2026, 5, 1),
      type: NoticeType.info,
    ),
  ];

  // Pre-populated bookings for the manager dashboard demo
  static List<Booking> sampleBookings = [
    Booking(
      id: 'BK-20260701',
      guestName: 'Rajesh Jain',
      phone: '+91 98765 43210',
      roomId: 'r1',
      roomName: 'Standard Non-AC Room',
      checkIn: DateTime(2026, 7, 5),
      checkOut: DateTime(2026, 7, 8),
      numberOfGuests: 2,
      community: 'Shwetambar',
      totalAmount: 1800,
      status: BookingStatus.confirmed,
      createdAt: DateTime(2026, 7, 1),
      isRead: true,
    ),
    Booking(
      id: 'BK-20260702',
      guestName: 'Priya Shah',
      phone: '+91 99887 76655',
      roomId: 'r3',
      roomName: 'Deluxe AC Suite',
      checkIn: DateTime(2026, 7, 10),
      checkOut: DateTime(2026, 7, 14),
      numberOfGuests: 3,
      community: 'Digambar',
      totalAmount: 8000,
      status: BookingStatus.confirmed,
      createdAt: DateTime(2026, 7, 2),
      isRead: true,
    ),
    Booking(
      id: 'BK-20260703',
      guestName: 'Mahavir Doshi',
      phone: '+91 87654 32109',
      roomId: 'r2',
      roomName: 'Family Non-AC Room',
      checkIn: DateTime(2026, 7, 12),
      checkOut: DateTime(2026, 7, 15),
      numberOfGuests: 4,
      totalAmount: 3300,
      status: BookingStatus.confirmed,
      createdAt: DateTime(2026, 7, 4),
      isRead: false,
    ),
    Booking(
      id: 'BK-20260704',
      guestName: 'Suresh Mehta',
      phone: '+91 77665 54433',
      roomId: 'r4',
      roomName: 'Dormitory',
      checkIn: DateTime(2026, 7, 6),
      checkOut: DateTime(2026, 7, 7),
      numberOfGuests: 1,
      totalAmount: 300,
      status: BookingStatus.confirmed,
      createdAt: DateTime(2026, 7, 5),
      isRead: false,
    ),
  ];

  static List<EventBooking> sampleEventBookings = [
    EventBooking(
      id: 'EB-20260601',
      eventType: 'Sangh Yatra',
      fromDate: DateTime(2026, 7, 20),
      toDate: DateTime(2026, 7, 23),
      expectedGuests: 80,
      fullName: 'Vinod Sanghvi',
      phone: '+91 98765 11111',
      notes: 'Sangh arriving from Ahmedabad. Need 20 rooms + main hall.',
      status: EventBookingStatus.confirmed,
      createdAt: DateTime(2026, 6, 15),
      isRead: true,
    ),
    EventBooking(
      id: 'EB-20260602',
      eventType: 'Chaumasa Stay',
      fromDate: DateTime(2026, 7, 12),
      toDate: DateTime(2026, 11, 12),
      expectedGuests: 5,
      fullName: 'Kantaben Jain',
      phone: '+91 99887 22222',
      notes: 'Family staying for full Chaumasa. Need 2 AC rooms.',
      status: EventBookingStatus.pending,
      createdAt: DateTime(2026, 7, 3),
      isRead: false,
    ),
  ];
}
