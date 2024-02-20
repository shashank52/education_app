import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  const ServerException({
    required this.serverMessage,
    required this.statusCode,
  });

  final String serverMessage;
  final int statusCode;

  @override
  List<Object?> get props => [serverMessage, statusCode];
}

class CacheException extends Equatable implements Exception {
  const CacheException({
    required this.serverMessage,
    this.statusCode = 500,
  });

  final String serverMessage;
  final int statusCode;

  @override
  List<Object?> get props => [serverMessage, statusCode];
}
