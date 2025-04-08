import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../db/database_helper.dart';

class RequestBloodScreen extends StatefulWidget {
  @override
  _RequestBloodScreenState createState() => _RequestBloodScreenState();
}

class _RequestBloodScreenState extends State<RequestBloodScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isLoading = false;

  Future<void> _sendRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> request = {
        "name": _nameController.text.trim(),
        "bloodGroup": _bloodGroupController.text.trim(),
        "contact": _contactController.text.trim(),
        "location": _locationController.text.trim(),
        "status": "Pending"
      };

      try {
        int result = await DatabaseHelper.instance.insertBloodRequest(request);
        if (result > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Blood Request Sent Successfully!')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send request')),
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
    _bloodGroupController.dispose();
    _contactController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Request Blood"),backgroundColor: Colors.redAccent,foregroundColor: Colors.white,  ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Your Name"),
                validator: (value) =>
                value!.isEmpty ? "Enter your name" : null,
              ),
              TextFormField(
                controller: _bloodGroupController,
                decoration: InputDecoration(labelText: "Blood Group"),
                validator: (value) =>
                value!.isEmpty ? "Enter blood group" : null,
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: "Contact"),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value!.isEmpty ? "Enter your contact number" : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: "Location"),
                validator: (value) =>
                value!.isEmpty ? "Enter your location" : null,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _sendRequest,
                child: Text("Send Request"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
