import 'dart:convert';

List<Puestodisponible> puestodisponibleFromMap(String str) => List<Puestodisponible>.from(json.decode(str).map((x) => Puestodisponible.fromMap(x)));

String puestodisponibleToMap(List<Puestodisponible> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Puestodisponible {
    int id;
    String nombre;
    String informacion;
    int disponible;
    String createdAt;
    String updatedAt;

    Puestodisponible({
        required this.id,
        required this.nombre,
        required this.informacion,
        required this.disponible,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Puestodisponible.fromMap(Map<String, dynamic> json) => Puestodisponible(
        id: json["id"],
        nombre: json["nombre"],
        informacion: json["informacion"],
        disponible: json["disponible"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "informacion": informacion,
        "disponible": disponible,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
