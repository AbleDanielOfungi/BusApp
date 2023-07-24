import 'package:busapp_fp/dashboard/admin_dashboard/admin_screens/schedules_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../admin_manage_users/manage_user_screen.dart';
import '../manage booking/admin_booking_history_for all_users.dart';
import '../manage booking/booking_list.dart';


class AdminDashboardScreen extends StatelessWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final user=FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    if (currentUser == null || !isAdminUser(currentUser!)) {
      // Redirect unauthorized users to a login or home screen
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('Access Denied'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Column(

          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                //color: Colors.black.withOpacity(0.1),
                border: Border.all(
                    color: Colors.grey.shade400
                ),
              ),
              child: Center(
                child: const Icon(Icons.directions_bus_filled_outlined,
                  size: 40,),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: MediaQuery.sizeOf(context).width*0.95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    )
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Email:',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold
                      ),),

                      Text(''+user.email!,
                        style: TextStyle(
                            color: Colors.grey
                        ),),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),

            Text('Welcome Back',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Manage all Bus details from here below'),
            Text('..Edit,Create, Delete and Monitor'),

            SizedBox(
              height: 30,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap:(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BusRoutesScreen()),
                    );

                  },
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:Colors.brown,
                              width: 5,
                            )

                        ),
                        child: Center(
                          child:Text(
                            'Bus Route'
                          )
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Manage Routes',
                        style: TextStyle(
                            color: Colors.brown,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                        ),)

                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SchedulesScreen()),
                        );



                  },
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:Colors.brown,
                              width: 5,
                            )

                        ),
                        child: Center(child: Text('Schedules')),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Manage schedules',
                        style: TextStyle(
                            color: Colors.brown,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic
                        ),)

                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => BusBookingScreen(routeId: routeId,)),
                        // );


                  },
                child:
                Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:Colors.brown,
                          width: 5,
                        )

                      ),
                      child:Center(
                        child: const Text('Bookings'),
                      ),

                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Manage Bookings',
                    style: TextStyle(
                        color: Colors.brown,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                    ),)
                  ],
                ),
                ),

              ],
            ),

            SizedBox(
              height: 50,
            ),

            Container(
              height: MediaQuery.sizeOf(context).height*0.2,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageUsersScreen(),
                          ),
                        );
                      },
                      child: Text('Manage Users'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminBookingHistoryScreen(),
                          ),
                        );
                      },
                      child: Text('Booking List'),
                    ),
                  ),

                ],
              ),
            ),





          ],
        ),
      ),
    );
  }

  bool isAdminUser(User user) {
    // Implement your logic to determine if the user has admin privileges
    // For example, check the user's role or a specific custom claim
    // Return true if the user is an admin, false otherwise
    return true;
  }
}

class BusRoutesScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> busRoutesStream;


  @override
  Widget build(BuildContext context) {
    busRoutesStream = firestore.collection('bus_routes').snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Bus Routes'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: busRoutesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  backgroundColor: Colors.grey,
                )
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('An error occurred'));
          }

          final busRoutes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: busRoutes.length,
            itemBuilder: (context, index) {
              final busRoute = busRoutes[index];
              final routeId = busRoute.id;
              final routeData = busRoute.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(routeData['name']),
                subtitle: Text(routeData['details']),
                leading:  IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBusRouteScreen(routeId: routeId,),
                      ),
                    );
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteBusRoute(routeId);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusDetailsScreen(routeId: routeId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBusRouteScreen(),
            ),
          );
        },
      ),
    );
  }

  void deleteBusRoute(String routeId) async {
    await firestore.collection('bus_routes').doc(routeId).delete();
  }
}

class AddBusRouteScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bus Route'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 42,
                    vertical: 20
                ),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(20),
                  borderSide:BorderSide(
                      color: Colors.black
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:BorderSide(
                      color: Colors.black
                  ),
                ),
                labelText: 'Name',


                    ),
              ),
            SizedBox(
              height: 30,
            ),


            TextField(
              controller: detailsController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 42,
                    vertical: 20
                ),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(20),
                  borderSide:BorderSide(
                      color: Colors.black
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:BorderSide(
                      color: Colors.black
                  ),
                ),
                labelText: 'Details',


              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                final name = nameController.text;
                final details = detailsController.text;

                if (name.isNotEmpty && details.isNotEmpty) {
                  addBusRoute(name, details);
                  Navigator.pop(context);
                }
              },
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black
                ),
                child: Center(
                  child: const Text('Add',
                  style: TextStyle(
                    color: Colors.white,
                  ),),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }

  void addBusRoute(String name, String details) async {
    await firestore.collection('bus_routes').add({
      'name': name,
      'details': details,
    });
  }
}


//add bus

class Bus {
  final String id;
  final String number;
  final int capacity;
  final double price;
  final String departureTime;
  final String arrivalTime;

  Bus({
    required this.id,
    required this.number,
    required this.capacity,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
  });
}

class BusDetailsScreen extends StatelessWidget {
  final String routeId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> busesStream;

  BusDetailsScreen({required this.routeId}) {
    busesStream = firestore
        .collection('bus_routes')
        .doc(routeId)
        .collection('buses')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Bus Details'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: busesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(
              color: Colors.black,
              backgroundColor: Colors.grey,
            ));
          }

          if (snapshot.hasError) {
            return Center(child: Text('An error occurred'));
          }

          final buses = snapshot.data!.docs;

          return ListView.builder(
            itemCount: buses.length,
            itemBuilder: (context, index) {
              final bus = buses[index];
              final busId = bus.id;
              final busData = bus.data() as Map<String, dynamic>;
              final busModel = Bus(
                id: busId,
                number: busData['number'],
                capacity: busData['capacity'],
                price: busData['price'],
                departureTime: busData['departureTime'],
                arrivalTime: busData['arrivalTime'],
              );

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
             
                  child: ListTile(

                    title: Text(busModel.number),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(

                          children: [
                            Text('Capacity: ${busModel.capacity}',
                              style: TextStyle(
                                  color: Colors.deepPurple
                              ),),
                            SizedBox(
                              width: 10,
                            ),

                            Text('Price:Ugx ${busModel.price}',
                            style: TextStyle(
                              color: Colors.brown
                            ),),
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(

                            children: [
                              Text('Departure: ${busModel.departureTime}'),
                              SizedBox(
                                width: 10,
                              ),

                              Text('Arrival: ${busModel.arrivalTime}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditBusScreen(
                              routeId: routeId,
                              bus: busModel,
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBusScreen(routeId: routeId),
            ),
          );
        },
      ),
    );
  }
}

class EditBusScreen extends StatefulWidget {
  final String routeId;
  final Bus bus;

  EditBusScreen({required this.routeId, required this.bus});

  @override
  _EditBusScreenState createState() => _EditBusScreenState();
}

class _EditBusScreenState extends State<EditBusScreen> {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController departureTimeController =
  TextEditingController();
  final TextEditingController arrivalTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    numberController.text = widget.bus.number;
    capacityController.text = widget.bus.capacity.toString();
    priceController.text = widget.bus.price.toString();
    departureTimeController.text = widget.bus.departureTime;
    arrivalTimeController.text = widget.bus.arrivalTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Bus'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: numberController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 42,
                      vertical: 20
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(20),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  labelText: 'Number',


                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: capacityController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 42,
                      vertical: 20
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(20),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  labelText: 'Capacity',


                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 42,
                      vertical: 20
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(20),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  labelText: 'Price',


                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: departureTimeController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 42,
                      vertical: 20
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(20),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  labelText: 'Departure Time',


                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: arrivalTimeController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 42,
                      vertical: 20
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(20),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  labelText: 'Arrival Time',


                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap:(){
                  final number = numberController.text;
                  final capacity = int.parse(capacityController.text);
                  final price = double.parse(priceController.text);
                  final departureTime = departureTimeController.text;
                  final arrivalTime = arrivalTimeController.text;

                  if (number.isNotEmpty && capacity != null && price != null && departureTime != null && arrivalTime != null) {


                    void updateBus(String routeId, String busId, String number, int capacity,
                        double price, String departureTime,String arrivalTime) async {
                      await FirebaseFirestore.instance
                          .collection('bus_routes')
                          .doc(routeId)
                          .collection('buses')
                          .doc(busId)
                          .update({
                        'number': number,
                        'capacity': capacity,
                        'price': price,
                        'departureTime': departureTime,
                        'arrivalTime': arrivalTime,
                      });
                    }

                    Navigator.pop(context);
                  }


                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text('Update',
                    style: TextStyle(
                      color: Colors.white
                    ),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}


/* add bus screen*/

class AddBusScreen extends StatefulWidget {
  final String routeId;

  AddBusScreen({required this.routeId});

  @override
  _AddBusScreenState createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController departureTimeController = TextEditingController();
  final TextEditingController arrivalTimeController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bus'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: numberController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 42,
                      vertical: 20
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(20),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  labelText: 'Number',


                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: capacityController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 42,
                      vertical: 20
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(20),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  labelText: 'Capacity',


                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 42,
                      vertical: 20
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(20),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  labelText: 'Price',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: departureTimeController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 42,
                      vertical: 20
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(20),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  labelText: 'Departure Time',


                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: arrivalTimeController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 42,
                      vertical: 20
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(20),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:BorderSide(
                        color: Colors.black
                    ),
                  ),
                  labelText: 'Arrival Time',


                ),
              ),
              SizedBox(
                height: 20,
              ),

              GestureDetector(
                onTap:(){
                  final number = numberController.text;
                  final capacity = int.parse(capacityController.text);
                  final price = double.parse(priceController.text);
                  final departureTime = departureTimeController.text;
                  final arrivalTime = arrivalTimeController.text;

                  if (number.isNotEmpty && capacity != null && price != null &&
                      departureTime != null && arrivalTime != null) {
                    addBus(
                      widget.routeId,
                      number,
                      capacity,
                      price,
                      departureTime,
                      arrivalTime,
                    );
                    Navigator.pop(context);
                  }

                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Add Bus',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }

  void addBus(String routeId, String number, int capacity, double price,
      String departureTime, String arrivalTime) async {
    await firestore
        .collection('bus_routes')
        .doc(routeId)
        .collection('buses')
        .add({
      'number': number,
      'capacity': capacity,
      'price': price,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
    });
  }

   }





/*bus route*/
class EditBusRouteScreen extends StatefulWidget {
  final String routeId;

  EditBusRouteScreen({required this.routeId});

  @override
  _EditBusRouteScreenState createState() => _EditBusRouteScreenState();
}

class _EditBusRouteScreenState extends State<EditBusRouteScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchRouteDetails();
  }

  void fetchRouteDetails() async {
    final routeDoc = await firestore.collection('bus_routes').doc(widget.routeId).get();
    final routeData = routeDoc.data() as Map<String, dynamic>;

    nameController.text = routeData['name'];
    detailsController.text = routeData['details'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Bus Route'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 42,
                    vertical: 20
                ),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(20),
                  borderSide:BorderSide(
                      color: Colors.black
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:BorderSide(
                      color: Colors.black
                  ),
                ),
                labelText: 'Name',


              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: detailsController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 42,
                    vertical: 20
                ),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(20),
                  borderSide:BorderSide(
                      color: Colors.black
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:BorderSide(
                      color: Colors.black
                  ),
                ),
                labelText: 'Details',


              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: (){
                final name = nameController.text;
                final details = detailsController.text;

                if (name.isNotEmpty && details.isNotEmpty) {
                  updateBusRoute(widget.routeId, name, details);
                  Navigator.pop(context);
                }


              },
              child: Container(

                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20)
                ),

                  child: Center(
                    child: const Text('Update',
                    style: TextStyle(
                      color: Colors.white
                    ),),
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }

  void updateBusRoute(String routeId, String name, String details) async {
    await firestore.collection('bus_routes').doc(routeId).update({
      'name': name,
      'details': details,
    });
  }
}



