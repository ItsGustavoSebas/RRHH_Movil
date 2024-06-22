import 'dart:convert';

List<Asistencias> asistenciaFromMap(String str) => List<Asistencias>.from(json.decode(str).map((x) => Asistencias.fromMap(x)));

String asistenciaToMap(List<Asistencias> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Asistencias {
    int id;
    DateTime fechaMarcada;
    String horaMarcada;
    bool puntual;
    bool atraso;
    bool faltaInjustificada;
    bool faltaJustificada;
    int idEmpleado;
    String createdAt;
    String updatedAt;

    Asistencias({
        required this.id,
        required this.fechaMarcada,
        required this.horaMarcada,
        required this.puntual,
        required this.atraso,
        required this.faltaInjustificada,
        required this.faltaJustificada,
        required this.idEmpleado,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Asistencias.fromMap(Map<String, dynamic> json) => Asistencias(
        id: json["id"],
        fechaMarcada: DateTime.parse(json["fechaMarcada"]),
        horaMarcada: json["horaMarcada"],
        puntual: json["puntual"],
        atraso: json["atraso"],
        faltaInjustificada: json["faltaInjustificada"],
        faltaJustificada: json["faltaJustificada"],
        idEmpleado: json["idEmpleado"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "fechaMarcada": "${fechaMarcada.year.toString().padLeft(4, '0')}-${fechaMarcada.month.toString().padLeft(2, '0')}-${fechaMarcada.day.toString().padLeft(2, '0')}",
        "horaMarcada": horaMarcada,
        "puntual": puntual,
        "atraso": atraso,
        "faltaInjustificada": faltaInjustificada,
        "faltaJustificada": faltaJustificada,
        "idEmpleado": idEmpleado,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
