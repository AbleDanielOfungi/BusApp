import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingsScreen extends StatefulWidget {
  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> bookingsStream;

  @override
  void initState() {
    super.initState();
    bookingsStream = firestore.collection('bookings').snapshots();
  }

  void deleteBooking(String bookingId) async {
    await firestore.collection('bookings').doc(bookingId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Bookings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bookingsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('An error occurred'));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final bookingId = booking.id;
              final bookingData = booking.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(bookingData['name']),
                subtitle: Text(bookingData['details']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteBooking(bookingId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
