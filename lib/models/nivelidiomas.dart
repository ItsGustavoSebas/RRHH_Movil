import 'dart:convert';

List<Nivelidiomas> nivelidiomasFromMap(String str) => List<Nivelidiomas>.from(json.decode(str).map((x) => Nivelidiomas.fromMap(x)));

String nivelidiomasToMap(List<Nivelidiomas> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Nivelidiomas {
    int id;
    String categoria;
    String createdAt;
    String updatedAt;

    Nivelidiomas({
        required this.id,
        required this.categoria,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Nivelidiomas.fromMap(Map<String, dynamic> json) => Nivelidiomas(
        id: json["id"],
        categoria: json["categoria"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "categoria": categoria,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
