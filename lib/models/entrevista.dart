class Entrevista {
  int id;
  DateTime fechaInicio;
  String hora;
  DateTime fechaFin;
  String detalles;
  int puntos;
  EntrevistaPostulante postulante;
  EntrevistaUsuario usuario;

  Entrevista({
    required this.id,
    required this.fechaInicio,
    required this.hora,
    required this.fechaFin,
    required this.detalles,
    required this.puntos,
    required this.postulante,
    required this.usuario,
  });

  factory Entrevista.fromJson(Map<String, dynamic> json) {
    return Entrevista(
      id: json["id"],
      fechaInicio: DateTime.parse(json["fecha_inicio"]),
      hora: json["hora"],
      fechaFin: DateTime.parse(json["fecha_fin"]),
      detalles: json["detalles"],
      puntos: json["puntos"],
      postulante: EntrevistaPostulante.fromJson(json['postulante']),
      usuario: EntrevistaUsuario.fromJson(json['usuario']),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "fecha_inicio": fechaInicio.toIso8601String(),
        "hora": hora,
        "fecha_fin": fechaFin.toIso8601String(),
        "detalles": detalles,
        "puntos": puntos,
        "postulante": postulante.toJson(),
        "usuario": usuario.toJson(),
      };
}

class EntrevistaPostulante {
  final String nombre;

  EntrevistaPostulante({required this.nombre});

  factory EntrevistaPostulante.fromJson(Map<String, dynamic> json) {
    return EntrevistaPostulante(nombre: json['nombre']);
  }

  Map<String, dynamic> toJson() {
    return {'nombre': nombre};
  }
}

class EntrevistaUsuario {
  final String nombre;
  final String cargo;

  EntrevistaUsuario({required this.nombre, required this.cargo});

  factory EntrevistaUsuario.fromJson(Map<String, dynamic> json) {
    return EntrevistaUsuario(nombre: json['nombre'], cargo: json['cargo']);
  }

  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'cargo': cargo};
  }
}