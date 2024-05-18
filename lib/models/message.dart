import 'dart:convert';

List<Message> messageFromJson(String str) => List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));
String messageToJson(List<Message> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Message {
  int id;
  String lastMessage;
  String name;
  String? avatar;
  int pendiente;

  Message({
    required this.id,
    required this.lastMessage,
    required this.name,
    this.avatar,
    required this.pendiente,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    lastMessage: json["last_message"],
    name: json["name"],
    avatar: json["avatar"],
    pendiente: json["pendiente"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "last_message": lastMessage,
    "name": name,
    "avatar": avatar,
    "pendiente": pendiente,
  };
}
