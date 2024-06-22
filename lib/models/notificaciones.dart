import 'dart:convert';

List<Notificaciones> notificacionesFromMap(String str) => List<Notificaciones>.from(json.decode(str).map((x) => Notificaciones.fromMap(x)));

String notificacionesToMap(List<Notificaciones> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Notificaciones {
    String id;
    String type;
    String notifiableType;
    int notifiableId;
    Data data;
    String? readAt;
    String createdAt;
    String updatedAt;

    Notificaciones({
        required this.id,
        required this.type,
        required this.notifiableType,
        required this.notifiableId,
        required this.data,
        required this.readAt,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Notificaciones.fromMap(Map<String, dynamic> json) => Notificaciones(
        id: json["id"],
        type: json["type"],
        notifiableType: json["notifiable_type"],
        notifiableId: json["notifiable_id"],
        data: Data.fromMap(json["data"]),
        readAt: json["read_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "notifiable_type": notifiableType,
        "notifiable_id": notifiableId,
        "data": data.toMap(),
        "read_at": readAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class Data {
    String titulo;
    String contenido;
    String link;
    String type;

    Data({
        required this.titulo,
        required this.contenido,
        required this.link,
        required this.type,
    });

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        titulo: json["titulo"],
        contenido: json["contenido"],
        link: json["link"],
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "titulo": titulo,
        "contenido": contenido,
        "link": link,
        "type": type,
    };
}
