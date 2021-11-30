import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segundo_final_frontend/objects/detalle_venta.dart';
import 'package:segundo_final_frontend/objects/producto.dart';
import 'package:segundo_final_frontend/services/productos_service.dart';
import 'package:segundo_final_frontend/services/ventas_service.dart';

import 'compra_page.dart';

List<DetalleVenta> detalles = [];

class VentasPage extends StatelessWidget {
  const VentasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ventas!"),
          actions: [
            IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CompraPage())),
                icon: const Icon(Icons.shopping_cart))
          ],
        ),
        body: const ListaProductos());
  }
}

class ListaProductos extends StatelessWidget {
  const ListaProductos({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: ProductoService.productos.length,
      itemBuilder: (context, index) =>
          GridItem(producto: ProductoService.productos[index]),
    );
  }
}

class GridItem extends StatelessWidget {
  final Producto producto;
  const GridItem({Key? key, required this.producto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(10)),
        height: 200,
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text("No hay foto!!"),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(producto.nombre ?? ""),
                subtitle: Text(producto.precio.toString() + "Gs."),
                trailing: IconButton(
                    onPressed: () =>
                        agregarProductoAlCarrito(context, producto),
                    icon: Icon(
                      Icons.shopping_bag,
                      color: Colors.green[600],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  agregarProductoAlCarrito(BuildContext context, Producto producto) {
    final _formKey = GlobalKey<FormState>();
    final controladorCantidad = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(producto.nombre ?? ""),
        content: Form(
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            controller: controladorCantidad,
            decoration: const InputDecoration(
              labelText: 'Cantidad',
            ),
            validator: (value) {
              if (value == "") {
                return "Por favor, ingrese una cantidad";
              } else if (int.tryParse(value ?? "") == 0) {
                return "No puede ser cero tu cantidad";
              }
            },
          ),
          key: _formKey,
        ),
        actions: [
          Consumer(
            builder: (_, ref, __) {
              return TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ref.watch(detallesProvider).add(DetalleVenta(
                          id: Random().nextInt(100000),
                          producto: producto,
                          cantidad: int.parse(controladorCantidad.value.text),
                          totalDetalle:
                              int.parse(controladorCantidad.value.text) *
                                  (producto.precio ?? 0)));
                      print(detalles);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Agregar a carrito!"));
            },
          )
        ],
      ),
    );
  }
}
