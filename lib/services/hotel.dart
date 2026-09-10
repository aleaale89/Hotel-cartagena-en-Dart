import '../enums/estado_habitacion.dart';
import '../enums/tipo_habitacion.dart';
import '../models/check_in.dart';
import '../models/check_out.dart';
import '../models/habitacion.dart';
import '../models/huesped.dart';
import '../models/recepcionista.dart';
import '../models/reserva.dart';

/// Servicio central que gestiona la lógica del hotel:
/// habitaciones, recepcionistas, reservas, check-in y check-out.
class Hotel {
  final String nombre;
  final List<Habitacion> _habitaciones = [];
  final List<Recepcionista> _recepcionistas = [];
  final List<Reserva> _reservas = [];
  final List<CheckIn> _checkIns = [];
  final List<CheckOut> _checkOuts = [];

  Hotel({this.nombre = 'Hotel Cartagena'}) {
    _inicializarHabitaciones();
  }

  // Getters para lectura segura
  List<Habitacion> get habitaciones => List.unmodifiable(_habitaciones);
  List<Recepcionista> get recepcionistas => List.unmodifiable(_recepcionistas);
  List<Reserva> get reservas => List.unmodifiable(_reservas);
  List<CheckIn> get checkIns => List.unmodifiable(_checkIns);
  List<CheckOut> get checkOuts => List.unmodifiable(_checkOuts);

  /// Carga inicial de habitaciones del hotel
  void _inicializarHabitaciones() {
    _habitaciones.addAll([
      Habitacion(numero: 101, tipo: TipoHabitacion.simple, capacidad: 1, precioPorNoche: 80000),
      Habitacion(numero: 102, tipo: TipoHabitacion.simple, capacidad: 1, precioPorNoche: 80000),
      Habitacion(numero: 201, tipo: TipoHabitacion.doble, capacidad: 2, precioPorNoche: 140000),
      Habitacion(numero: 202, tipo: TipoHabitacion.doble, capacidad: 2, precioPorNoche: 140000),
      Habitacion(numero: 301, tipo: TipoHabitacion.suite, capacidad: 4, precioPorNoche: 250000),
      Habitacion(numero: 302, tipo: TipoHabitacion.suite, capacidad: 4, precioPorNoche: 250000),
    ]);
  }

  // ==========================================
  // RF01 & RF02: Recepcionistas
  // ==========================================

  /// Registra un nuevo recepcionista. Lanza excepción si el usuario ya existe.
  bool registrarRecepcionista(String usuario, String contrasena, String nombre) {
    if (usuario.trim().isEmpty || contrasena.trim().isEmpty || nombre.trim().isEmpty) {
      throw ArgumentError('Ningún campo puede estar vacío.');
    }
    final existe = _recepcionistas.any((r) => r.usuario.toLowerCase() == usuario.trim().toLowerCase());
    if (existe) {
      throw StateError('El nombre de usuario ya está registrado.');
    }
    _recepcionistas.add(Recepcionista(
      usuario: usuario.trim(),
      contrasena: contrasena,
      nombre: nombre.trim(),
    ));
    return true;
  }

  /// Autentica un recepcionista en el sistema.
  Recepcionista? iniciarSesion(String usuario, String contrasena) {
    for (final r in _recepcionistas) {
      if (r.autenticar(usuario.trim(), contrasena)) {
        return r;
      }
    }
    return null;
  }

  // ==========================================
  // RF03: Consulta de habitaciones
  // ==========================================

  /// Retorna las habitaciones en estado disponible
  List<Habitacion> obtenerHabitacionesDisponibles() {
    return _habitaciones.where((h) => h.estado == EstadoHabitacion.disponible).toList();
  }

  /// Agrupa las habitaciones disponibles por su tipo
  Map<TipoHabitacion, List<Habitacion>> obtenerHabitacionesDisponiblesPorTipo() {
    final disponibles = obtenerHabitacionesDisponibles();
    final Map<TipoHabitacion, List<Habitacion>> agrupadas = {};
    for (final h in disponibles) {
      agrupadas.putIfAbsent(h.tipo, () => []).add(h);
    }
    return agrupadas;
  }

  /// Busca una habitación por su número
  Habitacion? buscarHabitacion(int numero) {
    try {
      return _habitaciones.firstWhere((h) => h.numero == numero);
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // RF04 & RF05: Reservas
  // ==========================================

  /// Crea una reserva cumpliendo con las validaciones de negocio:
  /// - Habitación debe existir y estar disponible
  /// - Días > 0
  /// Cambia estado a reservada.
  Reserva crearReserva({
    required int numeroHabitacion,
    required Huesped huesped,
    required int cantidadDias,
  }) {
    final habitacion = buscarHabitacion(numeroHabitacion);
    if (habitacion == null) {
      throw ArgumentError('La habitación número $numeroHabitacion no existe.');
    }
    if (habitacion.estado != EstadoHabitacion.disponible) {
      throw StateError('La habitación $numeroHabitacion no está disponible (Estado actual: ${habitacion.estado.name}).');
    }
    if (cantidadDias <= 0) {
      throw ArgumentError('La cantidad de días debe ser mayor que cero.');
    }

    // Cambiar estado de habitación
    habitacion.estado = EstadoHabitacion.reservada;

    final id = 'RES-${_reservas.length + 1}';
    final reserva = Reserva(
      id: id,
      habitacion: habitacion,
      huesped: huesped,
      cantidadDias: cantidadDias,
    );
    _reservas.add(reserva);
    return reserva;
  }

  /// Busca una reserva activa por número de habitación
  Reserva? buscarReservaActivaPorHabitacion(int numeroHabitacion) {
    try {
      return _reservas.firstWhere(
        (r) => r.habitacion.numero == numeroHabitacion && r.activa,
      );
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // RF06 & RF08: Check-In
  // ==========================================

  /// Realiza el check-in para una habitación con reserva activa:
  /// - Habitación debe estar reservada
  /// - Personas > 0 y <= capacidad
  /// Cambia estado a ocupada.
  CheckIn realizarCheckIn({
    required int numeroHabitacion,
    required int cantidadPersonas,
  }) {
    final habitacion = buscarHabitacion(numeroHabitacion);
    if (habitacion == null) {
      throw ArgumentError('La habitación $numeroHabitacion no existe.');
    }
    if (habitacion.estado != EstadoHabitacion.reservada) {
      throw StateError('La habitación no se encuentra en estado reservada.');
    }
    final reserva = buscarReservaActivaPorHabitacion(numeroHabitacion);
    if (reserva == null) {
      throw StateError('No se encontró una reserva activa para la habitación $numeroHabitacion.');
    }
    if (cantidadPersonas <= 0) {
      throw ArgumentError('El número de personas debe ser mayor que cero.');
    }
    if (cantidadPersonas > habitacion.capacidad) {
      throw ArgumentError(
        'El número de personas ($cantidadPersonas) supera la capacidad máxima (${habitacion.capacidad}) de la habitación.',
      );
    }

    // Cambiar estado a ocupada
    habitacion.estado = EstadoHabitacion.ocupada;

    final id = 'CHK-${_checkIns.length + 1}';
    final checkIn = CheckIn(
      id: id,
      reserva: reserva,
      cantidadPersonas: cantidadPersonas,
    );
    _checkIns.add(checkIn);
    return checkIn;
  }

  // ==========================================
  // RF07 & RF08: Check-Out
  // ==========================================

  /// Realiza el check-out de una habitación ocupada:
  /// - Habitación debe estar ocupada
  /// - Cierra la reserva activa
  /// - Cambia estado a disponible
  CheckOut realizarCheckOut({required int numeroHabitacion}) {
    final habitacion = buscarHabitacion(numeroHabitacion);
    if (habitacion == null) {
      throw ArgumentError('La habitación $numeroHabitacion no existe.');
    }
    if (habitacion.estado != EstadoHabitacion.ocupada) {
      throw StateError('La habitación no está ocupada (Estado actual: ${habitacion.estado.name}).');
    }

    final reserva = buscarReservaActivaPorHabitacion(numeroHabitacion);
    if (reserva != null) {
      reserva.activa = false; // Se cierra la reserva activa al salir
    }

    // Liberar la habitación
    habitacion.estado = EstadoHabitacion.disponible;

    final total = reserva != null ? reserva.costoTotal : habitacion.precioPorNoche;
    final id = 'OUT-${_checkOuts.length + 1}';
    final checkOut = CheckOut(
      id: id,
      habitacion: habitacion,
      reserva: reserva,
      montoTotal: total,
    );
    _checkOuts.add(checkOut);
    return checkOut;
  }
}
