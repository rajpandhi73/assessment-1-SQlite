import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../admin/blood_bank/view_blood_bank.dart';
import '../admin/blood_requests/view_blood_requests.dart';
import '../admin/donor/view_donor.dart';
import '../login_screen.dart';
import 'request_blood/request_blood_screen.dart';
import 'profile/profile_screen.dart';

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final String emergencyNumber = "108";
  int _currentIndex = 0;

  final List<Widget> _screens = [];

  final List<String> awarenessImages = [
    "assets/blood_awareness1.jpg",
    "assets/blood_awareness2.jpg",
    "assets/blood_awareness3.jpg"
  ];

  void _callEmergency() async {
    final Uri url = Uri.parse("tel:$emergencyNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Could not launch emergency call");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Dashboard"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      drawer: _buildDrawer(context),

      body: Column(
        children: [
          SizedBox(height: 10),

          // **Image Carousel**
          SizedBox(
            height: 180,
            child: PageView.builder(
              itemCount: awarenessImages.length,
              controller: PageController(viewportFraction: 0.9),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    awarenessImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 20),

          // **Grid View**
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                children: [
                  _buildGridItem(
                    title: "View Blood Banks",
                    icon: Icons.local_hospital,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewBloodBanksScreen(isAdmin: false)),
                    ),
                  ),
                  _buildGridItem(
                    title: "View Donors",
                    icon: Icons.group,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewDonorsScreen(isAdmin: false)),
                    ),
                  ),
                  _buildGridItem(
                    title: "Request Blood",
                    icon: Icons.bloodtype,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequestBloodScreen()),
                    ),
                  ),
                  _buildGridItem(
                    title: "My Blood Requests",
                    icon: Icons.history,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewBloodRequestsScreen(isAdmin: false),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // **Bottom Navigation Bar**
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.redAccent,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          if (index == 1) {
            _callEmergency();
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone, color: Colors.white),
            label: "Emergency",
          ),
        ],
      ),
    );
  }

  // **Helper Widget for Grid Items**
  Widget _buildGridItem({required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.red),
            SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // **Navigation Drawer**
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.red),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 80, color: Colors.white),
                SizedBox(height: 10),
                Text("User Profile", style: TextStyle(fontSize: 18, color: Colors.white)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black),
            title: Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.black),
            title: Text("Logout"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
