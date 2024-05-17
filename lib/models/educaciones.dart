import 'dart:convert';

List<Educaciones> educacionesFromMap(String str) => List<Educaciones>.from(json.decode(str).map((x) => Educaciones.fromMap(x)));

String educacionesToMap(List<Educaciones> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Educaciones {
    int id;
    String nombreColegio;
    String gradoDiploma;
    String campoDeEstudio;
    DateTime fechaDeFinalizacion;
    String notasAdicionales;
    int idPostulante;
    String createdAt;
    String updatedAt;

    Educaciones({
        required this.id,
        required this.nombreColegio,
        required this.gradoDiploma,
        required this.campoDeEstudio,
        required this.fechaDeFinalizacion,
        required this.notasAdicionales,
        required this.idPostulante,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Educaciones.fromMap(Map<String, dynamic> json) => Educaciones(
        id: json["id"],
        nombreColegio: json["nombre_colegio"],
        gradoDiploma: json["grado_diploma"],
        campoDeEstudio: json["campo_de_estudio"],
        fechaDeFinalizacion: DateTime.parse(json["fecha_de_finalizacion"]),
        notasAdicionales: json["notas_adicionales"],
        idPostulante: json["ID_Postulante"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nombre_colegio": nombreColegio,
        "grado_diploma": gradoDiploma,
        "campo_de_estudio": campoDeEstudio,
        "fecha_de_finalizacion": "${fechaDeFinalizacion.year.toString().padLeft(4, '0')}-${fechaDeFinalizacion.month.toString().padLeft(2, '0')}-${fechaDeFinalizacion.day.toString().padLeft(2, '0')}",
        "notas_adicionales": notasAdicionales,
        "ID_Postulante": idPostulante,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
