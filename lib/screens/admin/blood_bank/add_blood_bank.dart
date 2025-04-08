import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';
import '../../../models/blood_bank.dart';

class AddBloodBankScreen extends StatefulWidget {
  @override
  _AddBloodBankScreenState createState() => _AddBloodBankScreenState();
}

class _AddBloodBankScreenState extends State<AddBloodBankScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  bool _isLoading = false;

  Future<void> _addBloodBank() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      BloodBank bloodBank = BloodBank(
        id: null,
        name: _nameController.text,
        location: _locationController.text,
        contact: _contactController.text,
      );

      try {
        int result = await DatabaseHelper.instance.insertBloodBank(bloodBank);
        if (result > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Blood Bank Added Successfully')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add Blood Bank')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Blood Bank"),backgroundColor: Colors.redAccent,foregroundColor: Colors.white,),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Blood Bank Name"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter the blood bank name";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: "Location"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter the location";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: "Contact"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter the contact information";
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return "Enter a valid contact number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _addBloodBank,
                child: Text("Add Blood Bank"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
