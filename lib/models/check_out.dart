import 'habitacion.dart';
import 'reserva.dart';

/// Registra la salida del huésped, finalización de la estadía y liberación de la habitación.
class CheckOut {
  final String id;
  final Habitacion habitacion;
  final Reserva? reserva;
  final DateTime fechaHora;
  final double montoTotal;

  CheckOut({
    required this.id,
    required this.habitacion,
    this.reserva,
    DateTime? fechaHora,
    required this.montoTotal,
  }) : fechaHora = fechaHora ?? DateTime.now();

  @override
  String toString() {
    return 'Check-Out [$id] - Habitación ${habitacion.numero} - Total: \$$montoTotal - Fecha: $fechaHora';
  }
}
