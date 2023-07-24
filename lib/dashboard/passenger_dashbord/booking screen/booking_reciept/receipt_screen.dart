import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../user_booking_history.dart';

class ReceiptScreen extends StatefulWidget {
  final String routeId;
  final String busId;
  final String bookingId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  ReceiptScreen({
    required this.routeId,
    required this.busId,
    required this.bookingId,
  });

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  Map<String, dynamic>? bookingData;
  Map<String, dynamic>? busData;
  Map<String, dynamic>? routeData;
  Map<String, dynamic>? passengerData;
  double busFare = 0.0; // Declare the busFare variable here

  @override
  void initState() {
    super.initState();
    fetchBookingDetails();
  }

  void fetchBookingDetails() async {
    final bookingSnapshot = await widget.firestore
        .collection('bus_routes')
        .doc(widget.routeId)
        .collection('buses')
        .doc(widget.busId)
        .collection('bookings')
        .doc(widget.bookingId)
        .get();

    setState(() {
      bookingData = bookingSnapshot.data();
    });

    final busSnapshot = await widget.firestore
        .collection('bus_routes')
        .doc(widget.routeId)
        .collection('buses')
        .doc(widget.busId)
        .get();

    setState(() {
      busData = busSnapshot.data();
      busFare = busData!['price'];
    });

    final routeSnapshot = await widget.firestore
        .collection('bus_routes')
        .doc(widget.routeId)
        .get();

    setState(() {
      routeData = routeSnapshot.data();
    });

    // Fetch user email from Firestore based on the user's UID
    if (widget.currentUser != null) {
      final userSnapshot = await widget.firestore
          .collection('users')
          .doc(widget.currentUser!.uid)
          .get();

      setState(() {
        passengerData = userSnapshot.data();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: bookingData != null && busData != null && routeData != null && passengerData != null
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Booking Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Passenger Email: ${widget.currentUser!.email}'),
            Text('Route: ${routeData!['name']}'),
            Text('Bus: ${busData!['number']}'),
            Text('Seat Number: ${bookingData!['seatNumber']}'),
            Text('Bus Fare: ${busData!['price']}'), // Display the bus fare with 2 decimal places
            Text('Booking Time: ${bookingData!['bookingTime'].toDate().toString()}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement any further actions you want to perform after displaying the receipt.
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Booking Successful'),
                      content: Text('Your seat has been booked successfully.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Save the booking details to the user's Firestore document
                            saveBookingToUserHistory();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Confirm'),
            ),

            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingHistoryScreen()),
                );
              },
              child: Text('View Booking History'),
            )

          ],
        )
            : Center(
          child: CircularProgressIndicator(
            color: Colors.black,
            strokeWidth: 4,
            backgroundColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  // Method to save the booking details to the user's Firestore document
  void saveBookingToUserHistory() async {
    if (widget.currentUser != null && bookingData != null) {
      try {
        await widget.firestore
            .collection('users')
            .doc(widget.currentUser!.uid)
            .collection('booking_history')
            .doc(widget.bookingId)
            .set({
          'route': routeData!['name'],
          'bus': busData!['number'],
          'seatNumber': bookingData!['seatNumber'],
          'busFare': busData!['price'],
          'bookingTime': bookingData!['bookingTime'],
        });

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Booking Saved'),
              content: Text('Your booking details have been saved for future reference.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred while saving the booking details.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
