

import 'package:segundo_final_frontend/objects/producto.dart';

class ProductoService{
  static List<Producto> productos = [
    new Producto(codigo: 123, nombre: "Tornillo", precio: 1200, existencia: 1212),
    new Producto(codigo: 122, nombre: "Tuerca", precio: 1000, existencia: 1223),
    new Producto(codigo: 121, nombre: "Alambre", precio: 5000, existencia: 120),
  ];

  List<Producto> getProductos(){
    productos.sort((a,b) => a.codigo!.compareTo(b.codigo!));
    return productos;
  }

  deleteProducto(Producto producto){
    productos.remove(producto);
  }

  setProducto(Producto producto){
    productos.add(producto);
    productos = productos.toSet().toList();
  }

}