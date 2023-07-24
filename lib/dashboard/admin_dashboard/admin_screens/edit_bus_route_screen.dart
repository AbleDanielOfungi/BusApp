import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: detailsController,
              decoration: InputDecoration(labelText: 'Details'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final details = detailsController.text;

                if (name.isNotEmpty && details.isNotEmpty) {
                  updateBusRoute(widget.routeId, name, details);
                  Navigator.pop(context);
                }
              },
              child: Text('Update'),
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
