import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/bus_model.dart';

class EditBusScreen extends StatefulWidget {
  final String routeId;
  final String busId;
  final Bus bus;

  EditBusScreen({required this.routeId, required this.busId, required this.bus});

  @override
  _EditBusScreenState createState() => _EditBusScreenState();
}

class _EditBusScreenState extends State<EditBusScreen> {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController departureTimeController = TextEditingController();
  final TextEditingController arrivalTimeController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    numberController.text = widget.bus.number;
    capacityController.text = widget.bus.capacity.toString();
    priceController.text = widget.bus.price.toString();
    departureTimeController.text = widget.bus.departureTime.toString();
    arrivalTimeController.text = widget.bus.arrivalTime.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Bus'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: numberController,
              decoration: InputDecoration(labelText: 'Number'),
            ),
            TextField(
              controller: capacityController,
              decoration: InputDecoration(labelText: 'Capacity'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: departureTimeController,
              decoration: InputDecoration(labelText: 'Departure Time'),
            ),
            TextField(
              controller: arrivalTimeController,
              decoration: InputDecoration(labelText: 'Arrival Time'),
            ),
            ElevatedButton(
              onPressed: () {
                final number = numberController.text;
                final capacity = int.parse(capacityController.text);
                final price = double.parse(priceController.text);
                final departureTime = departureTimeController.text;
                final arrivalTime = arrivalTimeController.text;

                if (number.isNotEmpty && capacity != null && price != null &&
                    departureTime != null && arrivalTime != null) {
                  updateBus(
                    widget.routeId,
                    widget.busId,
                    number,
                    capacity,
                    price,
                    departureTime,
                    arrivalTime,
                  );
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

  void updateBus(String routeId, String busId, String number, int capacity,
      double price, String departureTime, String arrivalTime) async {
    await firestore
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
}
