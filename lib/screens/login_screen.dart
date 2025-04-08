import 'package:flutter/material.dart';
import 'admin/admin_dashboard.dart';
import 'user/user_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void login() {
    String id = _idController.text.trim();
    String password = _passwordController.text.trim();

    if (id == 'admin' && password == '1234') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AdminDashboard()));
    } else if (id == 'user' && password == '5678') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserDashboard()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid ID or Password!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"),backgroundColor: Colors.redAccent,foregroundColor: Colors.white,),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: "Enter ID"),
                validator: (value) =>
                value!.isEmpty ? "ID cannot be empty" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Enter Password"),
                obscureText: true, // Hides password input
                validator: (value) =>
                value!.isEmpty ? "Password cannot be empty" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    login();
                  }
                },
                child: Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
