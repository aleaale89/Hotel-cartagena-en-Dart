# Hotel Cartagena - Sistema Modular de Reservas en Dart
`Hotel_cartagenena_mod_reservas`

## 1. Objetivo
Desarrollar una aplicación de consola modular en Dart aplicando principios de Programación Orientada a Objetos (POO), separación de responsabilidades, validación de reglas de negocio, manejo de estados y control de excepciones para la gestión integral de reservas, check-in y check-out en el Hotel Cartagena.

## 2. Descripción Breve del Funcionamiento
El sistema permite a los recepcionistas:
1. **Autenticación y Registro:** Crear una cuenta y loguearse con usuario y contraseña.
2. **Consulta de Habitaciones:** Listar habitaciones disponibles agrupadas por categoría (simple, doble, suite) con sus tarifas y capacidades.
3. **Reservas:** Reservar habitaciones disponibles asociándolas a los datos del huésped.
4. **Check-In:** Registrar el ingreso formal del huésped validando capacidad máxima y reserva previa.
5. **Check-Out:** Registrar la salida, calcular el costo total y liberar la habitación a estado disponible.

## 3. Estructura del Proyecto
```
Hotel-cartagena-en-Dart/
├── bin/
│   └── main.dart                     # Punto de entrada único del programa
├── lib/
│   ├── models/                       # Clases de dominio
│   │   ├── habitacion.dart
│   │   ├── huesped.dart
│   │   ├── recepcionista.dart
│   │   ├── reserva.dart
│   │   ├── check_in.dart
│   │   └── check_out.dart
│   ├── enums/                        # Enumeraciones
│   │   ├── tipo_habitacion.dart
│   │   └── estado_habitacion.dart
│   ├── services/                     # Lógica de negocio
│   │   └── hotel.dart
│   └── sistema_hotel.dart            # Interfaz de consola, menús y navegación
├── test/
│   └── hotel_test.dart               # Pruebas automatizadas (T01 - T11)
├── pubspec.yaml                      # Configuración de dependencias Dart
└── README.md                         # Documentación del proyecto
```

## 4. Requisitos y Cómo Ejecutar el Proyecto
- **SDK:** Dart SDK >= 3.0.0.
- **Instalar dependencias:**
  ```bash
  dart pub get
  ```
- **Ejecutar la aplicación de consola:**
  ```bash
  dart run bin/main.dart
  ```
- **Ejecutar las pruebas automatizadas:**
  ```bash
  dart test
  ```

## 5. Reglas de Negocio Implementadas
- **Ciclo de estados:** `disponible` → `reservada` → `ocupada` → `disponible`.
- **Habitaciones:** Inician en estado `disponible`. Solo se puede reservar una habitación disponible.
- **Reservas:** Requieren habitación existente y disponible, datos completos del huésped y días > 0.
- **Check-In:** Requiere reserva activa previa. La cantidad de personas debe ser > 0 y no puede superar la capacidad máxima de la habitación.
- **Check-Out:** Solo procede en habitaciones con estado `ocupada`. Al realizarse, se cierra la reserva activa y la habitación retorna a `disponible`.
- **Validación de entradas:** No se permiten entradas vacías ni tipos numéricos inválidos en consola.


## 7. Integrantes
Alejandra bermudez, eduard tordecilla, angi torres, gustavo gonzales.


## 8. Dificultades Encontradas y Soluciones
- *(Completar durante el desarrollo y sustentación del proyecto).*

-------------------------------------------
Los commits deben ser claros. Ejemplos:
feat: crear modelo Habitacion
feat: agregar enum EstadoHabitacion
feat: implementar reservas
feat: implementar check-in
feat: implementar check-out
feat: crear menu de consola

test: agregar pruebas de reservas

docs: actualizar README


