import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class BookingHistoryPage extends StatefulWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  Future<List<Map<String, dynamic>>> fetchBookingHistory() async {
    final userId = widget.currentUser!.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('bus_routes')
        .where('buses.bookings.passengerId', isEqualTo: userId)
        .get();

    final bookings = querySnapshot.docs.map((doc) {
      final busData = doc.data();
      final buses = busData['buses'] as List<dynamic>;
      List<Map<String, dynamic>> bookingsList = [];
      buses.forEach((bus) {
        if (bus['bookings'] != null) {
          final bookings = bus['bookings'] as List<dynamic>;
          bookingsList.addAll(bookings.cast<Map<String, dynamic>>());
        }
      });

      return bookingsList;
    }).toList();

    return bookings.expand((bookings) => bookings).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBookingHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final bookingData = snapshot.data;
          if (bookingData == null || bookingData.isEmpty) {
            return Center(child: Text('No bookings found.'));
          }

          return ListView.builder(
            itemCount: bookingData.length,
            itemBuilder: (context, index) {
              final booking = bookingData[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('Route: ${booking['route']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bus: ${booking['bus']}'),
                      Text('Price: \$${booking['price']}'),
                      Text('Departure Time: ${booking['departureTime']}'),
                      Text('Arrival Time: ${booking['arrivalTime']}'),
                    ],
                  ),
                  onTap: () {
                    // Implement any action you want when a specific booking is tapped (optional).
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
