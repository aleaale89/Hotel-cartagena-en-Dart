import 'habitacion.dart';
import 'huesped.dart';

/// Representa una reserva realizada por un huésped para una habitación específica.
class Reserva {
  final String id;
  final Habitacion habitacion;
  final Huesped huesped;
  final int cantidadDias;
  final DateTime fechaCreacion;
  bool activa;

  Reserva({
    required this.id,
    required this.habitacion,
    required this.huesped,
    required this.cantidadDias,
    DateTime? fechaCreacion,
    this.activa = true,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();

  double get costoTotal => habitacion.precioPorNoche * cantidadDias;

  @override
  String toString() {
    return 'Reserva [$id] - Hab: ${habitacion.numero} - Huésped: ${huesped.nombreCompleto} - Días: $cantidadDias - Estado: ${activa ? "Activa" : "Cerrada"}';
  }
}
