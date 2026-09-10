import 'package:test/test.dart';
import 'package:hotel_cartagena_mod_reservas/enums/estado_habitacion.dart';
import 'package:hotel_cartagena_mod_reservas/models/huesped.dart';
import 'package:hotel_cartagena_mod_reservas/services/hotel.dart';

void main() {
  group('Pruebas del Sistema Hotel Cartagena (T01 - T11)', () {
    late Hotel hotel;
    late Huesped huespedValido;

    setUp(() {
      hotel = Hotel();
      huespedValido = Huesped(
        documento: '123456789',
        nombreCompleto: 'Carlos Perez',
        telefono: '3001234567',
        correo: 'carlos@example.com',
      );
    });

    test('T01: Registrar usuario nuevo exitosamente', () {
      final res = hotel.registrarRecepcionista('admin', '12345', 'Administrador');
      expect(res, isTrue);
      expect(hotel.recepcionistas.length, equals(1));
    });

    test('T02: Registrar usuario duplicado debe ser rechazado', () {
      hotel.registrarRecepcionista('recep1', 'clave1', 'Ana');
      expect(
        () => hotel.registrarRecepcionista('recep1', 'clave2', 'Ana Copia'),
        throwsA(isA<StateError>()),
      );
    });

    test('T03: Login correcto con credenciales válidas', () {
      hotel.registrarRecepcionista('juan', 'secret', 'Juan Gomez');
      final logueado = hotel.iniciarSesion('juan', 'secret');
      expect(logueado, isNotNull);
      expect(logueado?.nombre, equals('Juan Gomez'));
    });

    test('T04: Login incorrecto con contraseña errónea', () {
      hotel.registrarRecepcionista('juan', 'secret', 'Juan Gomez');
      final logueado = hotel.iniciarSesion('juan', 'clave_incorrecta');
      expect(logueado, isNull);
    });

    test('T05: Reserva correcta cambia el estado de la habitación a reservada', () {
      final reserva = hotel.crearReserva(
        numeroHabitacion: 101,
        huesped: huespedValido,
        cantidadDias: 3,
      );
      expect(reserva, isNotNull);
      final hab = hotel.buscarHabitacion(101);
      expect(hab?.estado, equals(EstadoHabitacion.reservada));
    });

    test('T06: Reserva con habitación inexistente debe ser rechazada', () {
      expect(
        () => hotel.crearReserva(
          numeroHabitacion: 999,
          huesped: huespedValido,
          cantidadDias: 2,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('T07: Reserva en habitación no disponible debe ser rechazada', () {
      hotel.crearReserva(
        numeroHabitacion: 101,
        huesped: huespedValido,
        cantidadDias: 2,
      );
      expect(
        () => hotel.crearReserva(
          numeroHabitacion: 101,
          huesped: huespedValido,
          cantidadDias: 1,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('T08: Check-in correcto cambia el estado a ocupado', () {
      hotel.crearReserva(
        numeroHabitacion: 201, // capacidad 2
        huesped: huespedValido,
        cantidadDias: 2,
      );
      final checkIn = hotel.realizarCheckIn(
        numeroHabitacion: 201,
        cantidadPersonas: 2,
      );
      expect(checkIn, isNotNull);
      final hab = hotel.buscarHabitacion(201);
      expect(hab?.estado, equals(EstadoHabitacion.ocupada));
    });

    test('T09: Check-in que excede la capacidad de la habitación debe ser rechazado', () {
      hotel.crearReserva(
        numeroHabitacion: 101, // capacidad 1
        huesped: huespedValido,
        cantidadDias: 1,
      );
      expect(
        () => hotel.realizarCheckIn(
          numeroHabitacion: 101,
          cantidadPersonas: 3,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('T10: Check-out correcto cambia el estado a disponible y cierra la reserva', () {
      hotel.crearReserva(
        numeroHabitacion: 102,
        huesped: huespedValido,
        cantidadDias: 2,
      );
      hotel.realizarCheckIn(
        numeroHabitacion: 102,
        cantidadPersonas: 1,
      );
      final checkOut = hotel.realizarCheckOut(numeroHabitacion: 102);
      expect(checkOut, isNotNull);
      final hab = hotel.buscarHabitacion(102);
      expect(hab?.estado, equals(EstadoHabitacion.disponible));
    });

    test('T11: Check-out de una habitación disponible debe ser rechazado', () {
      expect(
        () => hotel.realizarCheckOut(numeroHabitacion: 301),
        throwsA(isA<StateError>()),
      );
    });
  });
}
