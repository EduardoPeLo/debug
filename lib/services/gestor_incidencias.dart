import '../data/almacen_local.dart';
import '../model/incidencia.dart';

class GestorIncidencias {
  final AlmacenLocal datos = AlmacenLocal();
  List<Incidencia> incidencias = [];

  // BUG-003 (original): variable guardada que se desactualizaba al cambiar estados.
  // int cantidadPendientes = 0;

  Future<void> iniciar() async {
    incidencias = await datos.leer();
    // BUG-003 (original): el contador se calculaba solo una vez al iniciar.
    // cantidadPendientes =
    //     incidencias.where((x) => x.estado == 'Pendiente').length;
  }

  // BUG-002 (original): solo buscaba en el título, distinguía mayúsculas
  // y no recortaba espacios.
  // List<Incidencia> buscar(String texto) {
  //   if (texto.trim().isEmpty) return incidencias;
  //   return incidencias.where((x) => x.titulo.contains(texto)).toList();
  // }

  // BUG-002 (corregido): ignora mayúsculas y espacios sobrantes,
  // y busca en título y descripción.
  List<Incidencia> buscar(String texto) {
    final q = texto.trim().toLowerCase();
    if (q.isEmpty) return incidencias;
    return incidencias
        .where((x) =>
            x.titulo.toLowerCase().contains(q) ||
            x.descripcion.toLowerCase().contains(q))
        .toList();
  }

  Incidencia? porId(String id) {
    for (var x in incidencias) {
      if (x.id == id) return x;
    }
    return null;
  }

  // BUG-003 (original): 'Pendiente' devolvía la variable guardada, no el dato real.
  // int contar(String estado) {
  //   if (estado == 'Pendiente') return cantidadPendientes;
  //   return incidencias.where((x) => x.estado == estado).length;
  // }

  // BUG-003 (corregido): siempre se calcula desde la lista completa,
  // sin depender de búsqueda ni filtros.
  int contar(String estado) =>
      incidencias.where((x) => x.estado == estado).length;

  // BUG-001 (original): cambiaba el estado solo en memoria y nunca lo guardaba.
  // Future<void> cambiarEstado(String id, String estado) async {
  //   for (var i = 0; i < incidencias.length; i++) {
  //     if (incidencias[i].id == id) {
  //       incidencias[i].estado = estado;
  //       break;
  //     }
  //   }
  // }

  // BUG-001 (corregido): después de cambiar el estado se guarda la lista.
  Future<void> cambiarEstado(String id, String estado) async {
    for (var i = 0; i < incidencias.length; i++) {
      if (incidencias[i].id == id) {
        incidencias[i].estado = estado;
        break;
      }
    }
    await datos.guardar(incidencias);
  }

  // FEAT-001: cambiar la prioridad de una incidencia y conservarla.
  // Solo acepta Baja, Media o Alta.
  Future<void> cambiarPrioridad(String id, String prioridad) async {
    if (!Incidencia.prioridades.contains(prioridad)) {
      throw ArgumentError('Prioridad no válida: $prioridad');
    }
    for (var i = 0; i < incidencias.length; i++) {
      if (incidencias[i].id == id) {
        incidencias[i].prioridad = prioridad;
        break;
      }
    }
    await datos.guardar(incidencias);
  }

  // FEAT-001: crear() recibe la prioridad (por defecto Media).
  Future<void> crear(
      String titulo, String descripcion, String cliente, String categoria,
      {String prioridad = Incidencia.prioridadInicial}) async {
    final nuevo = Incidencia(
      id: 'INC-${DateTime.now().microsecondsSinceEpoch}',
      titulo: titulo,
      descripcion: descripcion,
      cliente: cliente,
      categoria: categoria,
      estado: 'Pendiente',
      fecha: DateTime.now().toIso8601String().split('T').first,
      prioridad: prioridad,
    );
    incidencias.insert(0, nuevo);
    // BUG-003 (original): incremento manual del contador, ya no se necesita.
    // cantidadPendientes++;
    await datos.guardar(incidencias);
  }

  Future<void> reiniciarDemo() async {
    await datos.restaurarDatosDeEjemplo();
    await iniciar();
  }
}
