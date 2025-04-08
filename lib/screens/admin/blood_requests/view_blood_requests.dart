import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';

class ViewBloodRequestsScreen extends StatefulWidget {
  final bool isAdmin;

  ViewBloodRequestsScreen({required this.isAdmin});

  @override
  _ViewBloodRequestsScreenState createState() => _ViewBloodRequestsScreenState();
}

class _ViewBloodRequestsScreenState extends State<ViewBloodRequestsScreen> {
  late Future<List<Map<String, dynamic>>> _bloodRequests;

  @override
  void initState() {
    super.initState();
    _refreshRequests();
  }

  void _refreshRequests() {
    setState(() {
      _bloodRequests = DatabaseHelper.instance.getAllBloodRequests();
    });
  }

  void _updateStatus(int id, String status) async {
    if (widget.isAdmin) {
      await DatabaseHelper.instance.updateBloodRequestStatus(id, status);
      _refreshRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAdmin ? "Admin: View Blood Requests" : "My Blood Requests"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bloodRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No blood requests available."));
          }

          final requests = snapshot.data!;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text("${request['name']} - ${request['bloodGroup']}"),
                  subtitle: Text(
                    "Contact: ${request['contact']}\n"
                        "Location: ${request['location']}\n"
                        "Status: ${request['status']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: request['status'] == "Completed" ? Colors.green : Colors.red,
                    ),
                  ),
                  trailing: widget.isAdmin
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () => _updateStatus(request['id'], "Completed"),
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _updateStatus(request['id'], "Incomplete"),
                      ),
                    ],
                  )
                      : null, // Hide buttons for users
                ),
              );
            },
          );
        },
      ),
    );
  }
}
