import 'dart:convert';

List<Fuentedecontratacion> fuentedecontratacionFromMap(String str) => List<Fuentedecontratacion>.from(json.decode(str).map((x) => Fuentedecontratacion.fromMap(x)));

String fuentedecontratacionToMap(List<Fuentedecontratacion> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Fuentedecontratacion {
    int id;
    String nombre;
    String createdAt;
    String updatedAt;

    Fuentedecontratacion({
        required this.id,
        required this.nombre,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Fuentedecontratacion.fromMap(Map<String, dynamic> json) => Fuentedecontratacion(
        id: json["id"],
        nombre: json["nombre"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
