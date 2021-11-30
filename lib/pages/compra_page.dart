import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segundo_final_frontend/objects/cliente.dart';
import 'package:segundo_final_frontend/objects/detalle_venta.dart';
import 'package:segundo_final_frontend/objects/venta.dart';
import 'package:segundo_final_frontend/services/clientes_service.dart';
import 'package:segundo_final_frontend/services/ventas_service.dart';

class CompraPage extends ConsumerStatefulWidget {
  const CompraPage({Key? key}) : super(key: key);

  @override
  _CompraPageState createState() => _CompraPageState();
}

class _CompraPageState extends ConsumerState<CompraPage> {
  final columnas = ["cantidad", "producto", "precio", "total"];

  final _formkey = GlobalKey<FormState>();

  var cliente = ClienteService.clientes[0];

  @override
  Widget build(BuildContext context) {
    int total = 0;
    var detalles = ref.watch(detallesProvider.notifier).state;
    for (var detalle in detalles) {
      total += detalle.totalDetalle;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de la compra!"),
      ),
      body: detalles.isNotEmpty
          ? Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: DropdownButtonFormField<Cliente>(
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
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DataTable(
                            columns: columnas
                                .map((columna) =>
                                    DataColumn(label: Text(columna)))
                                .toList(),
                            rows: detalles
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
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                                    detalles: detalles,
                                    total: total));

                                print("Venta agregada!");

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Comprado exitosamente!!!!")));
                                ref.read(detallesProvider.state).state = [];
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
