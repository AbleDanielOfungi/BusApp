import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'booking_reciept/receipt_screen.dart';
//import 'package:stripe_payment/stripe_payment.dart';

class BusBookingScreen extends StatefulWidget {
  final String routeId;
  final String busId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  BusBookingScreen({required this.routeId, required this.busId});

  @override
  _BusBookingScreenState createState() => _BusBookingScreenState();
}

class _BusBookingScreenState extends State<BusBookingScreen> {
  String? selectedSeat;
  List<String> bookedSeats = [];

  @override
  void initState() {
    super.initState();
    fetchBookedSeats();
  }

  void fetchBookedSeats() async {
    final snapshot = await widget.firestore
        .collection('bus_routes')
        .doc(widget.routeId)
        .collection('buses')
        .doc(widget.busId)
        .collection('bookings')
        .get();

    setState(() {
      bookedSeats = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Booking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select a Seat', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            buildSeatsGrid(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedSeat != null ? bookSeat : null,
              child: Text('Book Seat'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSeatsGrid() {
    final int totalSeats = 30;
    final List<String> seatNumbers = List.generate(totalSeats, (index) => '${index + 1}');

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: seatNumbers.length,
      itemBuilder: (context, index) {
        final seatNumber = seatNumbers[index];
        final isBooked = bookedSeats.contains(seatNumber);

        return ElevatedButton(
          onPressed: isBooked ? null : () => selectSeat(seatNumber),
          style: ElevatedButton.styleFrom(
            primary: isBooked ? Colors.grey : Colors.blue,
            padding: EdgeInsets.all(15),
          ),
          child: Text(
            seatNumber,
            style: TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  void selectSeat(String seatNumber) {
    setState(() {
      selectedSeat = seatNumber;
    });
  }

  void bookSeat() async {
    final String passengerId = widget.currentUser!.uid;

    final bookingId = selectedSeat;

    try {
      // Implement the payment integration using the Stripe payment gateway here.
      // For simplicity, we are assuming the payment is successful.
      // we handle the payment process using the Stripe SDK according to your requirements.

      // After the successful payment, add the booking details to Firestore.
      await widget.firestore
          .collection('bus_routes')
          .doc(widget.routeId)
          .collection('buses')
          .doc(widget.busId)
          .collection('bookings')
          .doc(bookingId)
          .set({
        'passengerId': passengerId,
        'seatNumber': bookingId,
        'bookingTime': Timestamp.now(),
      });

      // After successful booking, update the booked seats list and reset selectedSeat.
      fetchBookedSeats();
      selectedSeat = null;

      // Show a success message or navigate to a confirmation screen.
      // Navigate to the receipt screen with the booking details.
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiptScreen(
              routeId: widget.routeId,
              busId: widget.busId,
              bookingId: bookingId!,
            ),
          )
      );



    } catch (error) {
      // Handle any payment or booking errors here.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while booking the seat. Please try again later.'),
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
