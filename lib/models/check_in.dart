import 'reserva.dart';

/// Registra el ingreso formal de los huéspedes a la habitación reservada.
class CheckIn {
  final String id;
  final Reserva reserva;
  final int cantidadPersonas;
  final DateTime fechaHora;

  CheckIn({
    required this.id,
    required this.reserva,
    required this.cantidadPersonas,
    DateTime? fechaHora,
  }) : fechaHora = fechaHora ?? DateTime.now();

  @override
  String toString() {
    return 'Check-In [$id] - Habitación ${reserva.habitacion.numero} - Personas: $cantidadPersonas - Fecha: $fechaHora';
  }
}
