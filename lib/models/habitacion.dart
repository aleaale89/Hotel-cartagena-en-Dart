import '../enums/estado_habitacion.dart';
import '../enums/tipo_habitacion.dart';

/// Representa una habitación del hotel con su número, tipo, capacidad, precio y estado.
class Habitacion {
  final int numero;
  final TipoHabitacion tipo;
  final int capacidad;
  final double precioPorNoche;
  EstadoHabitacion estado;

  Habitacion({
    required this.numero,
    required this.tipo,
    required this.capacidad,
    required this.precioPorNoche,
    this.estado = EstadoHabitacion.disponible,
  });

  @override
  String toString() {
    return 'Habitación $numero | Tipo: ${tipo.name} | Capacidad: $capacidad pers. | Precio: \$$precioPorNoche | Estado: ${estado.name}';
  }
}
