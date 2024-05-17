import 'dart:convert';

List<Users> usersFromJson(String str) => List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));
String usersToJson(List<Users> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  int id;
  String name;
  String cargo;
  String? avatarUrl;

  Users({
    required this.id,
    required this.name,
    required this.cargo,
    required this.avatarUrl,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["id"],
    name: json["name"],
    cargo: json["cargo"],
    avatarUrl: json["avatar_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "cargo": cargo,
    "avatar_url": avatarUrl,
  };
}
