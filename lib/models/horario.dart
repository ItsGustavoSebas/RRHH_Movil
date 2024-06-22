import 'dart:convert';

List<Horario> horarioFromMap(String str) => List<Horario>.from(json.decode(str).map((x) => Horario.fromMap(x)));

String horarioToMap(List<Horario> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Horario {
    String dia;
    String horaInicio;
    String horaFin;
    String horaLimite;

    Horario({
        required this.dia,
        required this.horaInicio,
        required this.horaFin,
        required this.horaLimite,
    });

    factory Horario.fromMap(Map<String, dynamic> json) => Horario(
        dia: json["Dia"],
        horaInicio: json["HoraInicio"],
        horaFin: json["HoraFin"],
        horaLimite: json["HoraLimite"],
    );

    Map<String, dynamic> toMap() => {
        "Dia": dia,
        "HoraInicio": horaInicio,
        "HoraFin": horaFin,
        "HoraLimite": horaLimite,
    };
}