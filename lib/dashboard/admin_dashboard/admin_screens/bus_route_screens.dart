import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusRoutesScreen extends StatefulWidget {
  @override
  _BusRoutesScreenState createState() => _BusRoutesScreenState();
}

class _BusRoutesScreenState extends State<BusRoutesScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> busRoutesStream;

  @override
  void initState() {
    super.initState();
    busRoutesStream = firestore.collection('bus_routes').snapshots();
  }

  void deleteBusRoute(String routeId) async {
    await firestore.collection('bus_routes').doc(routeId).delete();
  }

  Future<void> addBusRoute() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String details = '';

        return AlertDialog(
          title: Text('Add New Bus Route'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Details'),
                onChanged: (value) {
                  details = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop({'name': name, 'details': details});
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      await firestore.collection('bus_routes').add({
        'name': result['name'],
        'details': result['details'],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Bus Routes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: busRoutesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteBusRoute(routeId),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => addBusRoute(),
      ),
    );
  }
}
