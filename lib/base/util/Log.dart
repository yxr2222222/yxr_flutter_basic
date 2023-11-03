import 'package:logger/logger.dart';

class Log {
  Log._internal();

  static final Logger _logger = Logger(printer: PrettyPrinter());

  static void i(dynamic message, {Object? error}) {
    _logger.i(message, error: error);
  }

  static void d(dynamic message, {Object? error}) {
    _logger.d(message, error: error);
  }

  static void w(dynamic message, {Object? error}) {
    _logger.w(message, error: error);
  }

  static void e(dynamic message, {Object? error}) {
    _logger.e(message, error: error);
  }
}
