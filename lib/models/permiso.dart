class Permiso {
  final int id;
  final int userId;
  final String motivo;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final bool aprobado;
  final bool denegado;

  Permiso({
    required this.id,
    required this.userId,
    required this.motivo,
    required this.fechaInicio,
    required this.fechaFin,
    required this.aprobado,
    required this.denegado,
  });

  factory Permiso.fromJson(Map<String, dynamic> json) {
    return Permiso(
      id: json['id'],
      userId: json['user_id'],
      motivo: json['motivo'],
      fechaInicio: DateTime.parse(json['fecha_inicio']),
      fechaFin: DateTime.parse(json['fecha_fin']),
      aprobado: json['aprobado'],
      denegado: json['denegado'],
    );
  }
}
