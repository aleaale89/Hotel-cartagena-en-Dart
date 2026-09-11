import 'check_in.dart';

class CheckOut {
  final CheckIn checkIn;
  final DateTime fecha;

  CheckOut({required this.checkIn, DateTime? fecha}) : fecha = fecha ?? DateTime.now();
}
