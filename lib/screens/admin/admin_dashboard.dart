import 'package:blood_bank/screens/admin/blood_requests/view_blood_requests.dart';
import 'package:blood_bank/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'donor/AddDonorScreen.dart';
import 'blood_bank/add_blood_bank.dart';
import 'blood_bank/view_blood_bank.dart';
import 'donor/view_donor.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),backgroundColor: Colors.redAccent,foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.person_add, color: Colors.red),
              title: Text("Add Donor"),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => AddDonorScreen()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.list, color: Colors.blue),
              title: Text("View Donors"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDonorsScreen(isAdmin: true,)));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.local_hospital_sharp, color: Colors.blueAccent),
              title: Text("Add Blood Banks"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddBloodBankScreen()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.view_list_sharp, color: Colors.orangeAccent),
              title: Text("View Blood Banks"),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => ViewBloodBanksScreen(isAdmin: true,)));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.bloodtype, color: Colors.green),
              title: Text("View Requests"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewBloodRequestsScreen(isAdmin: true,)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
