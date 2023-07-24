import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'booking history/booking_history.dart';

import 'booking screen/booking_screen.dart';
import 'booking screen/user_booking_history.dart';

class PassengerDashboardScreen extends StatelessWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      // Redirect unauthorized users to a login or home screen
      return Scaffold(
        body: Center(
          child: Text('Please sign in to access the dashboard.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(child: Text('Available Routes',
            style: TextStyle(
              fontSize: 20,
            ),)),
            BusRoutesList(),
          ],
        ),
      ),
      bottomNavigationBar:  Container(
        height: 100,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingHistoryScreen(),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long,
              size: 30,),
              Text('View Booking History',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),),
            ],
          ),
        ),
      ),





    );
  }
}

class BusRoutesList extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('bus_routes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('An error occurred'));
        }

        final busRoutes = snapshot.data!.docs;

        if (busRoutes.isEmpty) {
          return Center(child: Text('No bus routes found'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: busRoutes.length,
          itemBuilder: (context, index) {
            final route = busRoutes[index];
            final routeId = route.id;
            final routeData = route.data() as Map<String, dynamic>;

            return ListTile(
              title: Text(routeData['name']),
              subtitle: Text(routeData['details']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusScheduleScreen(routeId: routeId),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class BusScheduleScreen extends StatelessWidget {
  final String routeId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  BusScheduleScreen({required this.routeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Bus Schedule'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BusSchedulesList(routeId: routeId),
          SizedBox()
        ],
      ),

    );
  }
}

class BusSchedulesList extends StatelessWidget {
  final String routeId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  BusSchedulesList({required this.routeId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('bus_routes')
          .doc(routeId)
          .collection('buses')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('An error occurred'));
        }

        final busSchedules = snapshot.data!.docs;

        if (busSchedules.isEmpty) {
          return Center(child: Text('No bus schedules found'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: busSchedules.length,
          itemBuilder: (context, index) {
            final bus = busSchedules[index];
            final busId = bus.id;
            final busData = bus.data() as Map<String, dynamic>;

            return Expanded(

              child: Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0,
                top: 8),
                child: Container(

                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    title: Text('Bus ${busData['number']}'),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(


                          children: [
                            Text('Capacity: ${busData['capacity'] } seats',
                            style: TextStyle(
                              color: Colors.blue,

                            ),),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Bus Fare:Ugx ${busData['price']}',
                              style: TextStyle(
                                color: Colors.brown,
                              ),),

                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(

                            children: [
                              Text('Departure Time: ${busData['departureTime']}'),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Arrival Time: ${busData['arrivalTime']}'),

                            ],
                          ),
                        ),

                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusBookingScreen(
                            routeId: routeId,
                            busId: busId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
