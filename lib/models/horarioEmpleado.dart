import 'dart:convert';

HorarioEmpleado horarioempleadoFromJson(String str) => HorarioEmpleado.fromJson(json.decode(str));

String horarioempleadoToJson(HorarioEmpleado data) => json.encode(data.toJson());

class HorarioEmpleado {
    int id;
    int iDHorario;
    int iDEmpleado;


    HorarioEmpleado({
        required this.id,
        required this.iDHorario,
        required this.iDEmpleado,
    });

    factory HorarioEmpleado.fromJson(Map<String, dynamic> json) => HorarioEmpleado(
        id: json["id"],
        iDHorario: json["iDHorario"],
        iDEmpleado: json["iDEmpleado"],


    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "iDHorario": iDHorario,
        "iDEmpleado": iDEmpleado,
    };
}
