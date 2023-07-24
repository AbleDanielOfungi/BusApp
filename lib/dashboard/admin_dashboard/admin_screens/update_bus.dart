import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void updateBus(String routeId, String busId, String number, int capacity,
    double price, DateTime departureTime, DateTime arrivalTime) async {
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
