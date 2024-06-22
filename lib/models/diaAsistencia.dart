
import 'dart:convert';

DiaAsistencia diaAsistenciaFromJson(String str) => DiaAsistencia.fromJson(json.decode(str));

String diaAsistenciaToJson(DiaAsistencia data) => json.encode(data.toJson());

class DiaAsistencia {
    int id;
    int idAsistencia;
    int idDiaHorarioEmpleado;

    DiaAsistencia({
        required this.id,
        required this.idAsistencia,
        required this.idDiaHorarioEmpleado,

    });

    factory DiaAsistencia.fromJson(Map<String, dynamic> json) => DiaAsistencia(
        id: json["id"],
        idAsistencia: json["idAsistencia"],
        idDiaHorarioEmpleado: json["idDiaHorarioEmpleado"],

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idAsistencia": idAsistencia,
        "idDiaHorarioEmpleado": idDiaHorarioEmpleado,
    };
}
