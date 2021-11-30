import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:segundo_final_frontend/objects/detalle_venta.dart';
import 'package:segundo_final_frontend/objects/producto.dart';
import 'package:segundo_final_frontend/objects/venta.dart';
import 'package:segundo_final_frontend/services/productos_service.dart';
import 'package:segundo_final_frontend/services/ventas_service.dart';

import 'compra_page.dart';

List<DetalleVenta> detalles = [];

class VentasDetalles extends StatelessWidget {
  const VentasDetalles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Detalles de Venta!"),
          /*actions: [
            IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompraPage(detalles: detalles))),
                icon: const Icon(Icons.shopping_cart))
          ],*/
        ),
        body: const ListaProductosDetalles());
  }
}

class ListaProductosDetalles extends StatelessWidget {
  const ListaProductosDetalles({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: VentasService.ventas.length,
      itemBuilder: (context, index) =>
          GridItem(venta: VentasService.ventas[index]),
    );
  }
}
class ListaDetalles extends StatelessWidget {
  final List<DetalleVenta> detalles;
  const ListaDetalles({Key? key, required this.detalles}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: detalles.length,
      itemBuilder: (context, index) =>
          GridDetalleItem(detalle: detalles[index]),
    );
  }
}

class GridItem extends StatelessWidget {
  final Venta venta;
  const GridItem({Key? key, required this.venta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Card(
              child: ExpansionTile(
                title: Text(venta.facturaNum),
                subtitle: Text(venta.cliente.ruc! + "\n" + venta.cliente.nombre!),
                children: [
                  ListaDetalles(detalles: venta.detalles),
                ],
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
          TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  detalles.add(DetalleVenta(
                      id: Random().nextInt(100000),
                      producto: producto,
                      cantidad: int.parse(controladorCantidad.value.text),
                      totalDetalle: int.parse(controladorCantidad.value.text) *
                          (producto.precio ?? 0)));
                  print(detalles);
                  Navigator.pop(context);
                }
              },
              child: const Text("Agregar a carrito!"))
        ],
      ),
    );
  }
}

class GridDetalleItem extends StatelessWidget {
  final DetalleVenta detalle;
  const GridDetalleItem({Key? key, required this.detalle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text ("Codigo: " + detalle.producto.codigo.toString()),
           Text ("Nombre: " + detalle.producto.nombre!),
           Text ("Precio Unit.: " + detalle.producto.precio.toString()),
           Text ("Cantidad: " + detalle.cantidad.toString()),
           Text ("Total: " + detalle.totalDetalle.toString()),
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
          TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  detalles.add(DetalleVenta(
                      id: Random().nextInt(100000),
                      producto: producto,
                      cantidad: int.parse(controladorCantidad.value.text),
                      totalDetalle: int.parse(controladorCantidad.value.text) *
                          (producto.precio ?? 0)));
                  print(detalles);
                  Navigator.pop(context);
                }
              },
              child: const Text("Agregar a carrito!"))
        ],
      ),
    );
  }
}
