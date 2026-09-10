import 'package:hotel_cartagena_mod_reservas/sistema_hotel.dart';

/// Punto de entrada del programa.
/// Su única responsabilidad es inicializar y arrancar la aplicación.
void main() {
  final sistema = SistemaHotel();
  sistema.iniciar();
}
