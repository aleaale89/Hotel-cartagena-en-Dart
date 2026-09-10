/// Representa la información personal de un huésped.
class Huesped {
  final String documento;
  final String nombreCompleto;
  final String telefono;
  final String correo;

  Huesped({
    required this.documento,
    required this.nombreCompleto,
    required this.telefono,
    required this.correo,
  });

  @override
  String toString() {
    return '$nombreCompleto (Doc: $documento, Tel: $telefono)';
  }
}
