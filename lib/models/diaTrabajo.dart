
import 'dart:convert';

DiaTrabajo diaTrabajoFromJson(String str) => DiaTrabajo.fromJson(json.decode(str));

String diaTrabajoToJson(DiaTrabajo data) => json.encode(data.toJson());

class DiaTrabajo {
    int id;
    String nombre;

    DiaTrabajo({
        required this.id,
        required this.nombre,
    });

    factory DiaTrabajo.fromJson(Map<String, dynamic> json) => DiaTrabajo(
        id: json["id"],
        nombre: json["nombre"],

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,

    };
}
