
import 'dart:convert';

Postulante postulanteFromJson(String str) => Postulante.fromJson(json.decode(str));

String postulanteToJson(Postulante data) => json.encode(data.toJson());

class Postulante {
    int id;
    String nombre;
    String email;
    String puesto;
    String estado;
    int ci;
    int telefono;
    String direccion;
    DateTime fechaDeNacimiento;
    String nacionalidad;
    String habilidades;
    String fuenteDeContratacion;
    String idioma;
    String nivelIdioma;

    Postulante({
        required this.id,
        required this.nombre,
        required this.email,
        required this.puesto,
        required this.estado,
        required this.ci,
        required this.telefono,
        required this.direccion,
        required this.fechaDeNacimiento,
        required this.nacionalidad,
        required this.habilidades,
        required this.fuenteDeContratacion,
        required this.idioma,
        required this.nivelIdioma,
    });

    factory Postulante.fromJson(Map<String, dynamic> json) => Postulante(
        id: json["id"],
        nombre: json["nombre"],
        email: json["email"],
        puesto: json["puesto"],
        estado: json["estado"],
        ci: json["ci"],
        telefono: json["telefono   "],
        direccion: json["direccion"],
        fechaDeNacimiento: DateTime.parse(json["fecha_de_nacimiento"]),
        nacionalidad: json["nacionalidad"],
        habilidades: json["habilidades"],
        fuenteDeContratacion: json["fuenteDeContratacion"],
        idioma: json["idioma"],
        nivelIdioma: json["nivel_idioma"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "email": email,
        "puesto": puesto,
        "estado": estado,
        "ci": ci,
        "telefono   ": telefono,
        "direccion": direccion,
        "fecha_de_nacimiento": "${fechaDeNacimiento.year.toString().padLeft(4, '0')}-${fechaDeNacimiento.month.toString().padLeft(2, '0')}-${fechaDeNacimiento.day.toString().padLeft(2, '0')}",
        "nacionalidad": nacionalidad,
        "habilidades": habilidades,
        "fuenteDeContratacion": fuenteDeContratacion,
        "idioma": idioma,
        "nivel_idioma": nivelIdioma,
    };
}
