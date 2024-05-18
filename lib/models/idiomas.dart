import 'dart:convert';

List<Idiomas> idiomasFromMap(String str) => List<Idiomas>.from(json.decode(str).map((x) => Idiomas.fromMap(x)));

String idiomasToMap(List<Idiomas> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Idiomas {
    int id;
    String nombre;
    String createdAt;
    String updatedAt;

    Idiomas({
        required this.id,
        required this.nombre,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Idiomas.fromMap(Map<String, dynamic> json) => Idiomas(
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
