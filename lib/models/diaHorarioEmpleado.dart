
import 'dart:convert';

DiaHorarioEmpleado diaHorarioEmpleadoFromJson(String str) => DiaHorarioEmpleado.fromJson(json.decode(str));

String diaHorarioEmpleadoToJson(DiaHorarioEmpleado data) => json.encode(data.toJson());

class DiaHorarioEmpleado {
    int id;
    int iDDiaTrabajo;
    int iDHorarioEmpleado;

    DiaHorarioEmpleado({
        required this.id,
        required this.iDDiaTrabajo,
        required this.iDHorarioEmpleado,

    });

    factory DiaHorarioEmpleado.fromJson(Map<String, dynamic> json) => DiaHorarioEmpleado(
        id: json["id"],
        iDDiaTrabajo: json["iDDiaTrabajo"],
        iDHorarioEmpleado: json["iDHorarioEmpleado"],

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "iDDiaTrabajo": iDDiaTrabajo,
        "iDHorarioEmpleado": iDHorarioEmpleado,
    };
}
