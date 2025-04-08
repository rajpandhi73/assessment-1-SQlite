import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';
import '../../../models/blood_bank.dart';

class ViewBloodBanksScreen extends StatefulWidget {
  final bool isAdmin;

  ViewBloodBanksScreen({required this.isAdmin});

  @override
  _ViewBloodBanksScreenState createState() => _ViewBloodBanksScreenState();
}

class _ViewBloodBanksScreenState extends State<ViewBloodBanksScreen> {
  late Future<List<BloodBank>> _bloodBankList;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _bloodBankList = DatabaseHelper.instance.getAllBloodBanks();
    });
  }

  void _deleteBloodBank(int id) async {
    await DatabaseHelper.instance.deleteBloodBank(id);
    _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Blood Banks"),backgroundColor: Colors.redAccent,foregroundColor: Colors.white,),
      body: FutureBuilder<List<BloodBank>>(
        future: _bloodBankList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No blood banks available."));
          }

          final bloodBanks = snapshot.data!;
          return ListView.builder(
            itemCount: bloodBanks.length,
            itemBuilder: (context, index) {
              final bank = bloodBanks[index];
              return Card(
                child: ListTile(
                  title: Text(bank.name),
                  subtitle: Text("Location: ${bank.location}\nContact: ${bank.contact}"),
                  trailing: widget.isAdmin
                      ? IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteBloodBank(bank.id!),
                  )
                      : null, // Hide delete button for users
                ),
              );
            },
          );
        },
      ),
    );
  }
}
