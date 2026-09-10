/// Representa un recepcionista con credenciales para acceder al sistema.
class Recepcionista {
  final String usuario;
  final String contrasena;
  final String nombre;

  Recepcionista({
    required this.usuario,
    required this.contrasena,
    required this.nombre,
  });

  /// Valida si las credenciales coinciden
  bool autenticar(String usuarioIngresado, String contrasenaIngresada) {
    return usuario == usuarioIngresado && contrasena == contrasenaIngresada;
  }
}
