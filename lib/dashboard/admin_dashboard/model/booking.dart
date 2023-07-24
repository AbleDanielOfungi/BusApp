class Booking {
  final String id;
  final String userId;
  final String busId;
  final String routeId;
  final String departureTime;
  final String arrivalTime;
  final int seatNumber;

  Booking({
    required this.id,
    required this.userId,
    required this.busId,
    required this.routeId,
    required this.departureTime,
    required this.arrivalTime,
    required this.seatNumber,
  });

  // Create a Booking object from a Firestore document
  factory Booking.fromFirestore(Map<String, dynamic> data, String id) {
    return Booking(
      id: id,
      userId: data['userId'] ?? '',
      busId: data['busId'] ?? '',
      routeId: data['routeId'] ?? '',
      departureTime: data['departureTime'] ?? '',
      arrivalTime: data['arrivalTime'] ?? '',
      seatNumber: data['seatNumber'] ?? 0,
    );
  }
}
