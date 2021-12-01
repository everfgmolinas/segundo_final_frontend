import 'package:segundo_final_frontend/objects/cliente.dart';
import 'package:segundo_final_frontend/objects/detalle_venta.dart';
import 'package:segundo_final_frontend/objects/producto.dart';
import 'package:segundo_final_frontend/objects/venta.dart';

class VentasService {
  static List<Venta> ventas = [
    Venta(
        id: 1,
        fecha: DateTime(2019, 01, 16, 14, 15),
        facturaNum: "1",
        cliente: Cliente(
            ruc: "1234567-2",
            nombre: "Elias Cáceres",
            email: "ejemplo1@gmail.com"),
        detalles: [
          DetalleVenta(
              id: 1,
              producto: Producto(
                  codigo: 122,
                  nombre: "Tuerca",
                  precio: 1000,
                  existencia: 1223),
              cantidad: 1,
              totalDetalle: 1000)
        ],
        total: 1000),
    Venta(
        id: 2,
        fecha: DateTime(2019, 01, 17, 14, 15),
        facturaNum: "1",
        cliente: Cliente(
            ruc: "3456567-1",
            nombre: "Ever Garay",
            email: "ejemplo2@gmail.com"),
        detalles: [
          DetalleVenta(
              id: 1,
              producto: Producto(
                  codigo: 121,
                  nombre: "Alambre",
                  precio: 5000,
                  existencia: 120),
              cantidad: 2,
              totalDetalle: 10000)
        ],
        total: 10000)
  ];

  static List<Venta> getVentas() {
    ventas.sort((a, b) => a.id.compareTo(b.id));
    return ventas;
  }

  static void agregarVenta(Venta venta) {
    ventas.add(venta);
  }

  static void eliminarVenta(int id) {
    ventas.removeWhere((element) => element.id == id);
  }

  static List<Venta> filtrarCliente(Cliente cliente) {
    return ventas.where((venta) => venta.cliente == cliente).toList();
  }

  static List<Venta> filtrarProducto(Producto producto) {
    List<Venta> ventasProductos = [];
    for (Venta venta in ventas) {
      for (DetalleVenta detalle in venta.detalles) {
        if (detalle.producto == producto) ventasProductos.add(venta);
      }
    }
    return ventasProductos;
  }

  static List<Venta> filtrarFecha(DateTime fecha1, DateTime fecha2) {
    return ventas
        .where((venta) =>
            (venta.fecha.isAfter(fecha1) ||
                venta.fecha.difference(fecha1).inDays == 0) &&
            (venta.fecha.isBefore(fecha2) ||
                venta.fecha.difference(fecha2).inDays == 0))
        .toList();
  }
}
