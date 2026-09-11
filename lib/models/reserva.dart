import 'habitacion.dart';
import 'huesped.dart';

class Reserva {
  final Habitacion habitacion;
  final Huesped huesped;
  final int dias;
  bool activa;

  Reserva({
    required this.habitacion,
    required this.huesped,
    required this.dias,
    this.activa = true,
  });
}
