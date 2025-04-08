class BloodBank {
  int? id;
  String name;
  String location;
  String contact;

  BloodBank({this.id, required this.name, required this.location, required this.contact});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'contact': contact,
    };
  }

  factory BloodBank.fromMap(Map<String, dynamic> map) {
    return BloodBank(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      contact: map['contact'],
    );
  }
}
