import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String route;
  final String bus;
  final String departureTime;
  final String arrivalTime;
  final int seatCount;
  final double price;
  final bool isCancelled;

  Booking({
    required this.id,
    required this.userId,
    required this.route,
    required this.bus,
    required this.departureTime,
    required this.arrivalTime,
    required this.seatCount,
    required this.price,
    required this.isCancelled,
  });

  // Create a Booking object from a Firestore document
  factory Booking.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Booking(
      id: snapshot.id,
      userId: data['userId'] ?? '',
      route: data['route'] ?? '',
      bus: data['bus'] ?? '',
      departureTime: data['departureTime'] ?? '',
      arrivalTime: data['arrivalTime'] ?? '',
      seatCount: data['seatCount'] ?? 0,
      price: data['price'] ?? 0.0,
      isCancelled: data['isCancelled'] ?? false,
    );
  }
}

class BookingList extends StatelessWidget {
  Future<List<Booking>> getBookings() async {
    final querySnapshot =
    await FirebaseFirestore.instance.collection('bookings').get();

    final bookings = querySnapshot.docs
        .map((doc) => Booking.fromFirestore(doc))
        .toList();

    return bookings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Booking>>(
        future: getBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(
              color: Colors.black,
            ));
          }

          final bookings = snapshot.data;
          if (bookings == null || bookings.isEmpty) {
            return Center(child: Text('No bookings found.'));
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return ListTile(
                title: Text('Booking ID: ${booking.id}'),
                subtitle: Text('Route: ${booking.route}\nBus: ${booking.bus}\n'
                    'Departure: ${booking.departureTime}\nArrival: ${booking.arrivalTime}\n'
                    'Seat Count: ${booking.seatCount}\nPrice: ${booking.price}\n'
                    'Status: ${booking.isCancelled ? 'Cancelled' : 'Active'}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Implement admin actions for each booking, e.g., update, cancel, delete, etc.
                    // You can show a bottom sheet or a dialog to handle the actions.
                  },
                  child: Text('Manage'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
