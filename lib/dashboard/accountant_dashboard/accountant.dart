import 'package:flutter/material.dart';

import '../admin_dashboard/manage booking/admin_booking_history_for all_users.dart';
import '../passenger_dashbord/booking screen/user_booking_history.dart';



class Accountant extends StatefulWidget {
  const Accountant({super.key});

  @override
  State<Accountant> createState() => _AccountantState();
}

class _AccountantState extends State<Accountant> {
  @override
  Widget build(BuildContext context) {
    return AdminBookingHistoryScreen();

  }
}
