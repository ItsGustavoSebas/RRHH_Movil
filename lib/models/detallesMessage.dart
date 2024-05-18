import 'dart:convert';

List<Messages> messagesFromJson(String str) =>
    List<Messages>.from(json.decode(str).map((x) => Messages.fromJson(x)));
String messagesToJson(List<Messages> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Messages {
  int id;
  int emisorId;
  int receptorId;
  String mensaje;
  int leido;
  DateTime createdAt;
  DateTime updatedAt;

  Messages({
    required this.id,
    required this.emisorId,
    required this.receptorId,
    required this.mensaje,
    required this.leido,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      id: json['id'],
      emisorId: json['emisor_id'],
      receptorId: json['receptor_id'],
      mensaje: json['mensaje'],
      leido: json['leido'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emisor_id': emisorId,
      'receptor_id': receptorId,
      'mensaje': mensaje,
      'leido': leido,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
