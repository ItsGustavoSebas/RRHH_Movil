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

  factory Horario.fromMap(Map<String, dynamic> map) {
    return Horario(
      dia: map['Dia'],
      horaInicio: map['HoraInicio'],
      horaFin: map['HoraFin'],
      horaLimite: map['HoraLimite'],
    );
  }
}