class Huesped {
  final String cedula;
  final String nombre;

  Huesped({required this.cedula, required this.nombre});

  @override
  String toString() => '$nombre (CC: $cedula)';
}
