import 'reserva.dart';

class CheckIn {
  final Reserva reserva;
  final int numeroPersonas;
  final DateTime fecha;

  CheckIn({
    required this.reserva,
    required this.numeroPersonas,
    DateTime? fecha,
  }) : fecha = fecha ?? DateTime.now();
}
