class Incidencia {
  // FEAT-001: únicos valores de prioridad aprobados por el cliente.
  static const List<String> prioridades = ['Baja', 'Media', 'Alta'];
  static const String prioridadInicial = 'Media';

  // Devuelve una prioridad válida. Si el dato falta (incidencias antiguas),
  // viene vacío o trae un valor no aprobado, usa 'Media'.
  static String normalizarPrioridad(Object? valor) {
    final texto = valor?.toString().trim().toLowerCase() ?? '';
    for (final p in prioridades) {
      if (p.toLowerCase() == texto) return p;
    }
    return prioridadInicial;
  }

  String id;
  String titulo;
  String descripcion;
  String cliente;
  String categoria;
  String estado;
  String fecha;
  String prioridad;

  Incidencia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.cliente,
    required this.categoria,
    required this.estado,
    required this.fecha,
    String? prioridad,
  }) : prioridad = normalizarPrioridad(prioridad);

  factory Incidencia.desdeJson(Map<String, dynamic> m) {
    return Incidencia(
      id: m['id']?.toString() ?? '',
      titulo: m['titulo']?.toString() ?? '',
      descripcion: m['descripcion']?.toString() ?? '',
      cliente: m['cliente']?.toString() ?? '',
      categoria: m['categoria']?.toString() ?? 'Software',
      estado: m['estado']?.toString() ?? 'Pendiente',
      fecha: m['fecha']?.toString() ?? '',
      // FEAT-001: los registros antiguos no tienen 'prioridad' -> Media.
      prioridad: m['prioridad']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'cliente': cliente,
      'categoria': categoria,
      'estado': estado,
      'fecha': fecha,
      'prioridad': prioridad,
    };
  }
}
