import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String role;

  User(this.email, this.role);

  // Create a User object from a Firestore document
  factory User.fromFirestore(Map<String, dynamic> data) {
    final email = data['email'] ?? '';
    final role = data['role'] ?? '';
    return User(email, role);
  }
}

class Booking {
  final String id;
  final String userId;
  final String busId;
  final String routeId;
  final String departureTime;
  final String arrivalTime;
  final int seatNumber;

  Booking({
    required this.id,
    required this.userId,
    required this.busId,
    required this.routeId,
    required this.departureTime,
    required this.arrivalTime,
    required this.seatNumber,
  });

  // Create a Booking object from a Firestore document
  factory Booking.fromFirestore(Map<String, dynamic> data, String id) {
    return Booking(
      id: id,
      userId: data['userId'] ?? '',
      busId: data['busId'] ?? '',
      routeId: data['routeId'] ?? '',
      departureTime: data['departureTime'] ?? '',
      arrivalTime: data['arrivalTime'] ?? '',
      seatNumber: data['seatNumber'] ?? 0,
    );
  }
}

class UserList extends StatelessWidget {
  Future<List<User>> getUsers() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('users').get();

    final users = querySnapshot.docs
        .map((doc) => User.fromFirestore(doc.data()))
        .where((user) => user != null)
        .toList();

    return users;
  }

  Future<List<Booking>> getBookings() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('bookings').get();

    final bookings = querySnapshot.docs
        .map((doc) => Booking.fromFirestore(doc.data(), doc.id))
        .toList();

    return bookings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text('Welcome Back',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text('Manage all Bus Users from here below'),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: getUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data;
                if (users == null || users.isEmpty) {
                  return Center(child: Text('No users found.'));
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text('Email: ${user.email}'),
                      subtitle: Text('Role: ${user.role}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          showUserActions(context, user); // Show the bottom sheet with admin actions
                        },
                        child: Text('Manage'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(), // Add a divider between user and booking data
          Expanded(
            child: FutureBuilder<List<Booking>>(
              future: getBookings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(
                    color: Colors.blue,
                    backgroundColor: Colors.grey,
                  ));
                }

                final bookings = snapshot.data;
                if (bookings == null || bookings.isEmpty) {
                  return Center(child: Text('No bookings found.'));
                }

                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return ListTile(
                      title: Text('Booking ID: ${booking.id}'),
                      subtitle: Text('User ID: ${booking.userId}\n'
                          'Bus ID: ${booking.busId}\n'
                          'Route ID: ${booking.routeId}\n'
                          'Departure Time: ${booking.departureTime}\n'
                          'Arrival Time: ${booking.arrivalTime}\n'
                          'Seat Number: ${booking.seatNumber}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showUserActions(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Update Role'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                showUpdateRoleDialog(context, user); // Show the role update dialog
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete User'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                showDeleteUserConfirmation(context, user); // Show the delete user confirmation dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showUpdateRoleDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) {
        String selectedRole = user.role; // Current role of the user

        return AlertDialog(
          title: Text('Update Role for ${user.email}'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    items: ['Admin', 'Accountant', 'Passenger'].map((role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedRole = newValue!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await updateUserRole(user, selectedRole); // Update the user role
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User role updated successfully.'),
                  ),
                );
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteUserConfirmation(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete ${user.email}?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close the confirmation dialog
                await deleteUser(user); // Delete the user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User ${user.email} deleted successfully.'),
                  ),
                );
              },
              child: Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the confirmation dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateUserRole(User user, String newRole) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .update({'role': newRole});
    } catch (e) {
      throw Exception('Error updating user role: $e');
    }
  }

  Future<void> deleteUser(User user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.email).delete();
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }
}

