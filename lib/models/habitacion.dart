import '../enums/tipo_habitacion.dart';
import '../enums/estado_habitacion.dart';

class Habitacion {
  final int numero;
  final TipoHabitacion tipo;
  final int capacidad;
  EstadoHabitacion estado;

  Habitacion({
    required this.numero,
    required this.tipo,
    required this.capacidad,
    this.estado = EstadoHabitacion.disponible,
  });

  @override
  String toString() =>
      'Habitación $numero (${tipo.name}, capacidad: $capacidad) - ${estado.name}';
}
