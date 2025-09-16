import 'dart:convert';

class ContactModel {
  String id;
  String name;
  String email;

  ContactModel({
    this.id = '',
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  factory ContactModel.fromFirebase(Map<String, dynamic> map) {
    final id = map['name'].toString().split('/').last;
    final fields = map['fields'] as Map<String, dynamic>;

    return ContactModel(
      id: id,
      name: fields['name']['stringValue'] as String,
      email: fields['email']['stringValue'] as String,
    );
  }

  Map<String, dynamic> toFirebase() {
    return <String, dynamic>{
      "fields": {
        "email": {"stringValue": email},
        "name": {"stringValue": name},
      },
    };
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
