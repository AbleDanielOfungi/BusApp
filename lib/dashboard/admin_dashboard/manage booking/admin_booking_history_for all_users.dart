import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class AdminBookingHistoryScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade200,
      appBar: AppBar(
        title: Text('Admin Booking History'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore.collectionGroup('booking_history').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.grey,
            ));
          }

          final bookingDocs = snapshot.data!.docs;

          if (bookingDocs.isEmpty) {
            return Center(child: Text('No booking history found.'));
          }

          return ListView.builder(
            itemCount: bookingDocs.length,
            itemBuilder: (context, index) {
              final bookingData = bookingDocs[index].data();
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                    ),
                    child: ListTile(
                      title: Column(
                        children: [
                          Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      color: Colors.grey
                                  )
                              ),
                              child: Icon(Icons.directions_bus_filled)),
                          Row(
                            children: [
                              Text('Passenger:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                              Text(' ${bookingData['passengerEmail']}'),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Route:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                              Text('${bookingData['route']}'),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Bus:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                              Text('${bookingData['bus']}'),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Seat Numbber:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                              Text('${bookingData['seatNumber']}'),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Bus Fare:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                              Text(' Ugx ${bookingData['busFare']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),),
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text('Booking Time:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),),
                                Text(' ${bookingData['bookingTime'].toDate().toString()}'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );


            },
          );
        },
      ),
    );
  }
}
