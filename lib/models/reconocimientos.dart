
import 'dart:convert';

List<Reconocimientos> reconocimientosFromMap(String str) => List<Reconocimientos>.from(json.decode(str).map((x) => Reconocimientos.fromMap(x)));

String reconocimientosToMap(List<Reconocimientos> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Reconocimientos {
    int id;
    String nombre;
    String descripcion;
    int idPostulante;
    String createdAt;
    String updatedAt;

    Reconocimientos({
        required this.id,
        required this.nombre,
        required this.descripcion,
        required this.idPostulante,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Reconocimientos.fromMap(Map<String, dynamic> json) => Reconocimientos(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        idPostulante: json["ID_Postulante"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "ID_Postulante": idPostulante,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
