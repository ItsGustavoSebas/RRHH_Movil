class LlamadaAtencion {
  int id;
  String motivo;
  DateTime fecha;
  String gravedad;

  LlamadaAtencion({
    required this.id,
    required this.motivo,
    required this.fecha,
    required this.gravedad,
  });

  factory LlamadaAtencion.fromJson(Map<String, dynamic> json) {
    return LlamadaAtencion(
      id: json["id"],
      motivo: json["motivo"],
      fecha: DateTime.parse(json["fecha"]), // Aquí debe ser "fecha" en lugar de "fecha_fin"
      gravedad: json["gravedad"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "motivo": motivo,
        "fecha": fecha.toIso8601String(),
        "gravedad": gravedad,
  };
}