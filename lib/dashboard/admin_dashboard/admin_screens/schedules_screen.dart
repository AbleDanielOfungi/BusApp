import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SchedulesScreen extends StatefulWidget {
  @override
  _SchedulesScreenState createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> schedulesStream;

  @override
  void initState() {
    super.initState();
    schedulesStream = firestore.collection('schedules').snapshots();
  }

  void deleteSchedule(String scheduleId) async {
    await firestore.collection('schedules').doc(scheduleId).delete();
  }

  Future<void> addSchedule() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String details = '';

        return AlertDialog(
          title: Text('Add New Schedule'),
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
      await firestore.collection('schedules').add({
        'name': result['name'],
        'details': result['details'],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Schedules'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: schedulesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('An error occurred'));
          }

          final schedules = snapshot.data!.docs;

          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              final scheduleId = schedule.id;
              final scheduleData = schedule.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(scheduleData['name']),
                subtitle: Text(scheduleData['details']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteSchedule(scheduleId),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => addSchedule(),
      ),
    );
  }
}
