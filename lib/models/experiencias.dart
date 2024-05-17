import 'dart:convert';

List<Experiencias> experienciasFromMap(String str) => List<Experiencias>.from(json.decode(str).map((x) => Experiencias.fromMap(x)));

String experienciasToMap(List<Experiencias> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Experiencias {
    int id;
    String cargo;
    String descripcion;
    int aos;
    String lugar;
    int idPostulante;
    String createdAt;
    String updatedAt;

    Experiencias({
        required this.id,
        required this.cargo,
        required this.descripcion,
        required this.aos,
        required this.lugar,
        required this.idPostulante,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Experiencias.fromMap(Map<String, dynamic> json) => Experiencias(
        id: json["id"],
        cargo: json["cargo"],
        descripcion: json["descripcion"],
        aos: json["años"],
        lugar: json["lugar"],
        idPostulante: json["ID_Postulante"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "cargo": cargo,
        "descripcion": descripcion,
        "años": aos,
        "lugar": lugar,
        "ID_Postulante": idPostulante,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
