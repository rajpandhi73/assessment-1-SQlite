import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';
import '../../../models/donor.dart';

class ViewDonorsScreen extends StatefulWidget {
  final bool isAdmin;

  ViewDonorsScreen({required this.isAdmin}); // Constructor

  @override
  _ViewDonorsScreenState createState() => _ViewDonorsScreenState();
}

class _ViewDonorsScreenState extends State<ViewDonorsScreen> {
  late Future<List<Donor>> _donorsFuture;

  @override
  void initState() {
    super.initState();
    _donorsFuture = DatabaseHelper.instance.getAllDonors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Donors"),backgroundColor: Colors.redAccent,foregroundColor: Colors.white,),
      body: FutureBuilder<List<Donor>>(
        future: _donorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No donors available"));
          }

          List<Donor> donors = snapshot.data!;

          return ListView.builder(
            itemCount: donors.length,
            itemBuilder: (context, index) {
              Donor donor = donors[index];

              void _editDonor(Donor donor) async {
                bool updated = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditDonorScreen(donor: donor)),
                );

                if (updated == true) {
                  setState(() {
                    _donorsFuture = DatabaseHelper.instance.getAllDonors();
                  });
                }
              }


              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(donor.name),
                  subtitle: Text(
                      "Blood Group: ${donor.bloodGroup}\nLocation: ${donor.location}\nContact: ${donor.contact}"
                  ),

                  trailing: widget.isAdmin
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editDonor(donor),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await DatabaseHelper.instance.deleteDonor(donor.id!);
                          setState(() {
                            _donorsFuture = DatabaseHelper.instance.getAllDonors();
                          });
                        },
                      ),
                    ],
                  )
                      : null, // Hides buttons for non-admin users
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class EditDonorScreen extends StatefulWidget {
  final Donor donor;

  EditDonorScreen({required this.donor});

  @override
  _EditDonorScreenState createState() => _EditDonorScreenState();
}

class _EditDonorScreenState extends State<EditDonorScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _locationController;
  late TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.donor.name);
    _bloodGroupController = TextEditingController(text: widget.donor.bloodGroup);
    _locationController = TextEditingController(text: widget.donor.location);
    _contactController = TextEditingController(text: widget.donor.contact);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bloodGroupController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _updateDonor() async {
    Donor updatedDonor = Donor(
      id: widget.donor.id,
      name: _nameController.text,
      bloodGroup: _bloodGroupController.text,
      location: _locationController.text,
      contact: _contactController.text,
    );

    await DatabaseHelper.instance.updateDonor(updatedDonor);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Donor updated successfully")),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Donor"),backgroundColor: Colors.redAccent,foregroundColor: Colors.white,),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _bloodGroupController,
              decoration: InputDecoration(labelText: "Blood Group"),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: "Location"),
            ),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(labelText: "Contact Number"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateDonor,
              child: Text("Update Donor"),
            ),
          ],
        ),
      ),
    );
  }
}

