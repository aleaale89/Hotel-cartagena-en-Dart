import 'dart:io';
import 'enums/tipo_habitacion.dart';
import 'models/huesped.dart';
import 'models/recepcionista.dart';
import 'services/hotel.dart';

/// Clase responsable de la interfaz de consola, navegación, captura
/// de datos del usuario e integración con el servicio Hotel.
class SistemaHotel {
  final Hotel _hotel = Hotel();
  Recepcionista? _recepcionistaActual;

  /// Inicia el flujo principal de la aplicación
  void iniciar() {
    print('====================================================');
    print('   BIENVENIDO AL SISTEMA DE GESTIÓN HOTEL CARTAGENA   ');
    print('====================================================');

    bool continuar = true;
    while (continuar) {
      if (_recepcionistaActual == null) {
        continuar = _mostrarMenuAutenticacion();
      } else {
        _mostrarMenuRecepcionista();
      }
    }

    print('\n¡Gracias por utilizar el Sistema Hotel Cartagena! Hasta pronto.');
  }

  // ==========================================
  // MENÚ DE AUTENTICACIÓN / ACCESO
  // ==========================================

  bool _mostrarMenuAutenticacion() {
    print('\n----------------------------------------');
    print('          ACCESO AL SISTEMA             ');
    print('----------------------------------------');
    print('1. Iniciar sesión');
    print('2. Registrar nuevo recepcionista');
    print('3. Salir de la aplicación');
    print('----------------------------------------');

    final opcion = _leerTextoNoVacio('Seleccione una opción: ');
    switch (opcion) {
      case '1':
        _iniciarSesion();
        return true;
      case '2':
        _registrarRecepcionista();
        return true;
      case '3':
        return false;
      default:
        _mostrarError('Opción inválida. Intente de nuevo.');
        return true;
    }
  }

  void _iniciarSesion() {
    print('\n>>> INICIO DE SESIÓN');
    final usuario = _leerTextoNoVacio('Usuario: ');
    final contrasena = _leerTextoNoVacio('Contraseña: ');

    final recepcionista = _hotel.iniciarSesion(usuario, contrasena);
    if (recepcionista != null) {
      _recepcionistaActual = recepcionista;
      _mostrarExito('¡Bienvenido(a), ${recepcionista.nombre}!');
    } else {
      _mostrarError('Usuario o contraseña incorrectos.');
    }
  }

  void _registrarRecepcionista() {
    print('\n>>> REGISTRO DE RECEPCIONISTA');
    final usuario = _leerTextoNoVacio('Usuario deseado: ');
    final contrasena = _leerTextoNoVacio('Contraseña: ');
    final nombre = _leerTextoNoVacio('Nombre completo: ');

    try {
      _hotel.registrarRecepcionista(usuario, contrasena, nombre);
      _mostrarExito('Recepcionista "$usuario" registrado con éxito. Ahora puede iniciar sesión.');
    } catch (e) {
      _mostrarError(e.toString().replaceAll('Bad state: ', '').replaceAll('Invalid argument(s): ', ''));
    }
  }

  // ==========================================
  // MENÚ PRINCIPAL DEL RECEPCIONISTA
  // ==========================================

  void _mostrarMenuRecepcionista() {
    print('\n========================================');
    print('  PANEL PRINCIPAL - ${_recepcionistaActual?.nombre}');
    print('========================================');
    print('1. Consultar habitaciones disponibles');
    print('2. Reservar habitación');
    print('3. Realizar Check-In');
    print('4. Realizar Check-Out');
    print('5. Ver todas las habitaciones');
    print('6. Cerrar sesión');
    print('========================================');

    final opcion = _leerTextoNoVacio('Seleccione una opción: ');
    switch (opcion) {
      case '1':
        _consultarHabitacionesDisponibles();
        break;
      case '2':
        _reservarHabitacion();
        break;
      case '3':
        _realizarCheckIn();
        break;
      case '4':
        _realizarCheckOut();
        break;
      case '5':
        _verTodasLasHabitaciones();
        break;
      case '6':
        _recepcionistaActual = null;
        _mostrarExito('Sesión cerrada correctamente.');
        break;
      default:
        _mostrarError('Opción inválida. Seleccione un número del 1 al 6.');
    }
  }

  // ==========================================
  // CASOS DE USO / OPERACIONES
  // ==========================================

  void _consultarHabitacionesDisponibles() {
    print('\n--- HABITACIONES DISPONIBLES POR TIPO ---');
    final agrupadas = _hotel.obtenerHabitacionesDisponiblesPorTipo();

    if (agrupadas.isEmpty) {
      print('No hay habitaciones disponibles en este momento.');
      return;
    }

    for (final tipo in TipoHabitacion.values) {
      final lista = agrupadas[tipo] ?? [];
      print('\n[ Tipo: ${tipo.name.toUpperCase()} ] (${lista.length} disponibles)');
      if (lista.isEmpty) {
        print('  (Ninguna disponible en esta categoría)');
      } else {
        for (final hab in lista) {
          print('  - Habitación #${hab.numero} | Capacidad: ${hab.capacidad} | Precio/noche: \$${hab.precioPorNoche}');
        }
      }
    }
  }

  void _reservarHabitacion() {
    print('\n>>> RESERVAR HABITACIÓN');
    _consultarHabitacionesDisponibles();

    final numHabitacion = _leerEntero('Ingrese el número de la habitación a reservar: ');
    final documento = _leerTextoNoVacio('Documento del huésped: ');
    final nombre = _leerTextoNoVacio('Nombre completo del huésped: ');
    final telefono = _leerTextoNoVacio('Teléfono de contacto: ');
    final correo = _leerTextoNoVacio('Correo electrónico: ');
    final dias = _leerEntero('Cantidad de días de estadía: ');

    try {
      final huesped = Huesped(
        documento: documento,
        nombreCompleto: nombre,
        telefono: telefono,
        correo: correo,
      );

      final reserva = _hotel.crearReserva(
        numeroHabitacion: numHabitacion,
        huesped: huesped,
        cantidadDias: dias,
      );

      _mostrarExito('¡Reserva creada exitosamente!');
      print('  ID de Reserva : ${reserva.id}');
      print('  Habitación    : ${reserva.habitacion.numero} (${reserva.habitacion.tipo.name})');
      print('  Huésped       : ${reserva.huesped.nombreCompleto}');
      print('  Días          : ${reserva.cantidadDias}');
      print('  Total estimado: \$${reserva.costoTotal}');
    } catch (e) {
      _mostrarError(e.toString().replaceAll('Bad state: ', '').replaceAll('Invalid argument(s): ', ''));
    }
  }

  void _realizarCheckIn() {
    print('\n>>> REALIZAR CHECK-IN');
    final numHabitacion = _leerEntero('Ingrese el número de la habitación con reserva: ');
    final numPersonas = _leerEntero('Ingrese el número de personas que ingresarán: ');

    try {
      final checkIn = _hotel.realizarCheckIn(
        numeroHabitacion: numHabitacion,
        cantidadPersonas: numPersonas,
      );
      _mostrarExito('¡Check-In realizado exitosamente!');
      print('  Código Check-In: ${checkIn.id}');
      print('  Habitación     : ${checkIn.reserva.habitacion.numero}');
      print('  Huésped titular: ${checkIn.reserva.huesped.nombreCompleto}');
      print('  Ocupantes      : ${checkIn.cantidadPersonas}');
      print('  Fecha y hora   : ${checkIn.fechaHora}');
    } catch (e) {
      _mostrarError(e.toString().replaceAll('Bad state: ', '').replaceAll('Invalid argument(s): ', ''));
    }
  }

  void _realizarCheckOut() {
    print('\n>>> REALIZAR CHECK-OUT');
    final numHabitacion = _leerEntero('Ingrese el número de habitación que realiza check-out: ');

    try {
      final checkOut = _hotel.realizarCheckOut(numeroHabitacion: numHabitacion);
      _mostrarExito('¡Check-Out completado con éxito!');
      print('  Código Check-Out: ${checkOut.id}');
      print('  Habitación      : ${checkOut.habitacion.numero}');
      print('  Total a cancelar: \$${checkOut.montoTotal}');
      print('  Estado actual   : ${checkOut.habitacion.estado.name}');
    } catch (e) {
      _mostrarError(e.toString().replaceAll('Bad state: ', '').replaceAll('Invalid argument(s): ', ''));
    }
  }

  void _verTodasLasHabitaciones() {
    print('\n--- ESTADO GENERAL DE HABITACIONES ---');
    for (final hab in _hotel.habitaciones) {
      print('  - Hab #${hab.numero} | ${hab.tipo.name.padRight(6)} | Cap: ${hab.capacidad} | Estado: ${hab.estado.name.toUpperCase()}');
    }
  }

  // ==========================================
  // MÉTODOS AUXILIARES Y VALIDACIÓN DE ENTRADAS
  // ==========================================

  /// Solicita un texto asegurando que no sea nulo ni vacío (caso T12)
  String _leerTextoNoVacio(String mensaje) {
    while (true) {
      stdout.write(mensaje);
      final entrada = stdin.readLineSync();
      if (entrada != null && entrada.trim().isNotEmpty) {
        return entrada.trim();
      }
      print('  [!] La entrada no puede estar vacía. Intente nuevamente.');
    }
  }

  /// Solicita un entero asegurando formato correcto
  int _leerEntero(String mensaje) {
    while (true) {
      final texto = _leerTextoNoVacio(mensaje);
      final valor = int.tryParse(texto);
      if (valor != null) {
        return valor;
      }
      print('  [!] Por favor ingrese un número entero válido.');
    }
  }

  void _mostrarExito(String mensaje) {
    print('\n[OK] $mensaje');
  }

  void _mostrarError(String mensaje) {
    print('\n[ERROR] $mensaje');
  }
}
