/// Modelo para representar detecciones en tiempo real (US019)
class RealtimeDetectionModel {
  final String id;
  final String nombre;
  final String apellido;
  final String? dni;
  final String tipo; // 'entrada' o 'salida'
  final DateTime fechaHora;
  final String puerta;
  final String? guardiaId;
  final String? guardiaNombre;
  final bool isLocal; // Si fue detectado localmente o vía WebSocket

  RealtimeDetectionModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    this.dni,
    required this.tipo,
    required this.fechaHora,
    required this.puerta,
    this.guardiaId,
    this.guardiaNombre,
    this.isLocal = false,
  });

  factory RealtimeDetectionModel.fromJson(Map<String, dynamic> json) {
    return RealtimeDetectionModel(
      id: json['id'] ?? json['_id'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      dni: json['dni'],
      tipo: json['tipo'] ?? 'entrada',
      fechaHora: json['fecha_hora'] != null
          ? DateTime.parse(json['fecha_hora'])
          : json['timestamp'] != null
              ? DateTime.parse(json['timestamp'])
              : DateTime.now(),
      puerta: json['puerta'] ?? '',
      guardiaId: json['guardia_id'],
      guardiaNombre: json['guardia_nombre'],
      isLocal: json['isLocal'] ?? false,
    );
  }

  factory RealtimeDetectionModel.fromAlumno(
    dynamic alumno,
    String tipo,
    String puerta,
    String? guardiaId,
    String? guardiaNombre,
  ) {
    return RealtimeDetectionModel(
      id: alumno.id ?? '',
      nombre: alumno.nombre ?? '',
      apellido: alumno.apellido ?? '',
      dni: alumno.dni,
      tipo: tipo,
      fechaHora: DateTime.now(),
      puerta: puerta,
      guardiaId: guardiaId,
      guardiaNombre: guardiaNombre,
      isLocal: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'dni': dni,
      'tipo': tipo,
      'fecha_hora': fechaHora.toIso8601String(),
      'puerta': puerta,
      'guardia_id': guardiaId,
      'guardia_nombre': guardiaNombre,
      'isLocal': isLocal,
    };
  }

  String get nombreCompleto => '$nombre $apellido';

  String get tipoDisplay {
    switch (tipo.toLowerCase()) {
      case 'entrada':
        return 'Entrada';
      case 'salida':
        return 'Salida';
      default:
        return tipo;
    }
  }

  String get fechaHoraFormateada {
    return '${fechaHora.hour.toString().padLeft(2, '0')}:${fechaHora.minute.toString().padLeft(2, '0')}';
  }

  String get fechaFormateada {
    return '${fechaHora.day}/${fechaHora.month}/${fechaHora.year}';
  }

  bool get isEntrada => tipo.toLowerCase() == 'entrada';
  bool get isSalida => tipo.toLowerCase() == 'salida';
}

