import 'dart:convert';

List<Permisos> permisosFromMap(String str) =>
    List<Permisos>.from(json.decode(str).map((x) => Permisos.fromMap(x)));

String permisosToMap(List<Permisos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Permisos {
  int id;
  int userId;
  String motivo;
  DateTime fechaInicio;
  DateTime fechaFin;
  int aprobado;
  int denegado;
  String createdAt;
  String updatedAt;

  Permisos({
    required this.id,
    required this.userId,
    required this.motivo,
    required this.fechaInicio,
    required this.fechaFin,
    required this.aprobado,
    required this.denegado,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Permisos.fromMap(Map<String, dynamic> json) => Permisos(
        id: json["id"],
        userId: json["user_id"],
        motivo: json["motivo"],
        fechaInicio: DateTime.parse(json["fecha_inicio"]),
        fechaFin: DateTime.parse(json["fecha_fin"]),
        aprobado: json["aprobado"],
        denegado: json["denegado"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "motivo": motivo,
        "fecha_inicio":
            "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
        "fecha_fin":
            "${fechaFin.year.toString().padLeft(4, '0')}-${fechaFin.month.toString().padLeft(2, '0')}-${fechaFin.day.toString().padLeft(2, '0')}",
        "aprobado": aprobado,
        "denegado": denegado,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
