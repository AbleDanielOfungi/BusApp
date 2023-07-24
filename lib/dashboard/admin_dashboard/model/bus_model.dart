// class Bus {
//   final String id;
//   final String number;
//   final int capacity;
//   final double price;
//   final DateTime departureTime;
//   final DateTime arrivalTime;
//
//   Bus({
//     required this.id,
//     required this.number,
//     required this.capacity,
//     required this.price,
//     required this.departureTime,
//     required this.arrivalTime,
//   });
// }


import 'package:cloud_firestore/cloud_firestore.dart';
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

  // Create a static method to construct the Bus model from QueryDocumentSnapshot
  static Bus fromDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Bus(
      id: snapshot.id,
      number: data['number'],
      capacity: data['capacity'],
      price: data['price'],
      departureTime: data['departureTime'],
      arrivalTime: data['arrivalTime'],
    );
  }
}
