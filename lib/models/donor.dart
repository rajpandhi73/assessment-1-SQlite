class Donor {
  int? id;
  String name;
  String bloodGroup;
  String contact;
  String location;

  Donor({this.id, required this.name, required this.bloodGroup, required this.contact, required this.location});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bloodGroup': bloodGroup,
      'contact': contact,
      'location': location,
    };
  }

  factory Donor.fromMap(Map<String, dynamic> map) {
    return Donor(
      id: map['id'],
      name: map['name'],
      bloodGroup: map['bloodGroup'],
      contact: map['contact'],
      location: map['location'],
    );
  }
}
