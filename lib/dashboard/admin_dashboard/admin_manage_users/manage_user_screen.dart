import 'package:busapp_fp/dashboard/admin_dashboard/admin_manage_users/user_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
        centerTitle: true,
      ),

      body: UserList(),


    );
  }
}
