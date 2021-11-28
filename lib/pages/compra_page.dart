import 'dart:math';

import 'package:flutter/material.dart';
import 'package:segundo_final_frontend/objects/cliente.dart';
import 'package:segundo_final_frontend/objects/detalle_venta.dart';
import 'package:segundo_final_frontend/objects/venta.dart';
import 'package:segundo_final_frontend/services/clientes_service.dart';
import 'package:segundo_final_frontend/services/ventas_service.dart';

class CompraPage extends StatefulWidget {
  final List<DetalleVenta> detalles;
  CompraPage({Key? key, required this.detalles}) : super(key: key);

  @override
  State<CompraPage> createState() => _CompraPageState();
}

class _CompraPageState extends State<CompraPage> {
  final columnas = ["cantidad", "producto", "precio unitario", "total"];

  final _formkey = GlobalKey<FormState>();

  var cliente = ClienteService.clientes[0];

  @override
  Widget build(BuildContext context) {
    int total = 0;
    for (var detalle in widget.detalles) {
      total += detalle.totalDetalle;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de la compra!"),
      ),
      body: widget.detalles.isNotEmpty
          ? Form(
              key: _formkey,
              child: Column(
                children: [
                  DropdownButtonFormField<Cliente>(
                    value: cliente,
                    onChanged: (value) => setState(() {
                      cliente = value!;
                    }),
                    validator: (value) {
                      if (value == null) {
                        return "Elegi un cliente!!";
                      }
                    },
                    items: ClienteService.clientes
                        .map((cliente) => DropdownMenuItem<Cliente>(
                              child: Text(cliente.nombre!),
                              value: cliente,
                            ))
                        .toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DataTable(
                        columns: columnas
                            .map((columna) => DataColumn(label: Text(columna)))
                            .toList(),
                        rows: widget.detalles
                            .map((detalle) => DataRow(cells: [
                                  DataCell(Text(
                                    detalle.cantidad.toString(),
                                  )),
                                  DataCell(Text(
                                    detalle.producto.nombre ?? " ",
                                  )),
                                  DataCell(Text(
                                    detalle.producto.precio.toString(),
                                  )),
                                  DataCell(Text(
                                    detalle.totalDetalle.toString(),
                                  )),
                                ]))
                            .toList()),
                  ),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Total: $total Gs."),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            VentasService.agregarVenta(Venta(
                                id: Random().nextInt(100000),
                                fecha: DateTime.now(),
                                facturaNum:
                                    Random().nextInt(10000000).toString(),
                                cliente: cliente,
                                detalles: widget.detalles,
                                total: total));
                            print("Venta agregada!");
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("¡Comprar!"),
                      ),
                    )
                  ]),
                ],
              ),
            )
          : const Center(
              child: Text("NO HAY NADA EN TU CARRITO!!"),
            ),
    );
  }
}
