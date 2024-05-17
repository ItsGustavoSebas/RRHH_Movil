import 'dart:convert';

List<Referencias> referenciasFromMap(String str) => List<Referencias>.from(json.decode(str).map((x) => Referencias.fromMap(x)));

String referenciasToMap(List<Referencias> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Referencias {
    int id;
    String nombre;
    String descripcion;
    String telefono;
    int idPostulante;
    String createdAt;
    String updatedAt;

    Referencias({
        required this.id,
        required this.nombre,
        required this.descripcion,
        required this.telefono,
        required this.idPostulante,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Referencias.fromMap(Map<String, dynamic> json) => Referencias(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        telefono: json["telefono"],
        idPostulante: json["ID_Postulante"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "telefono": telefono,
        "ID_Postulante": idPostulante,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
