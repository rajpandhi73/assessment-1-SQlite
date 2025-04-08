import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';
import '../../../models/donor.dart';

class AddDonorScreen extends StatefulWidget {
  @override
  _AddDonorScreenState createState() => _AddDonorScreenState();
}

class _AddDonorScreenState extends State<AddDonorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  void _addDonor() async {
    if (_formKey.currentState!.validate()) {
      Donor newDonor = Donor(
        name: _nameController.text,
        bloodGroup: _bloodGroupController.text,
        contact: _contactController.text,
        location: _locationController.text,
      );
      await DatabaseHelper.instance.addDonor(newDonor);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Donor Added Successfully!")),
      );

      Navigator.pop(context); // Go back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Donor"), backgroundColor: Colors.redAccent,foregroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Donor Name"),
                validator: (value) => value!.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: _bloodGroupController,
                decoration: InputDecoration(labelText: "Blood Group"),
                validator: (value) => value!.isEmpty ? "Enter blood group" : null,
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: "Contact"),
                validator: (value) => value!.isEmpty ? "Enter contact" : null,
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: "Location"),
                validator: (value) => value!.isEmpty ? "Enter location" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addDonor,
                child: Text("Add Donor"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
