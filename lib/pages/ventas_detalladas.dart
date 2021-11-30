import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:segundo_final_frontend/objects/cliente.dart';
import 'package:segundo_final_frontend/objects/detalle_venta.dart';
import 'package:segundo_final_frontend/objects/producto.dart';
import 'package:segundo_final_frontend/objects/venta.dart';
import 'package:segundo_final_frontend/services/clientes_service.dart';
import 'package:segundo_final_frontend/services/productos_service.dart';
import 'package:segundo_final_frontend/services/ventas_service.dart';

import 'compra_page.dart';

List<DetalleVenta> detalles = [];
List<Venta>? ventas;

class VentasDetalles extends StatefulWidget {
  const VentasDetalles({Key? key}) : super(key: key);
  @override
  _VentasDetalles createState() => _VentasDetalles();

}

class _VentasDetalles extends State<VentasDetalles> {

  @override
  void initState() {
    super.initState();
    ventas = VentasService.getVentas();
  }

  String getFecha1() {
    if( init == null){
      return 'Seleccione una fecha inicial';
    }else {
     return  '${init!.day}/${init!.month}/${init!.year}';
    }
  }

  String getFecha2() {
    if( end == null){
      return 'Seleccione una fecha final';
    }else {
      return  '${end!.day}/${end!.month}/${end!.year}';
    }
  }

  DateTime? init;
  DateTime? end;
  Producto? producto ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Detalles de Venta!"),
        ),
        body: Column(
          children: [
            ElevatedButton(
                child: Text(getFecha1()),
                onPressed: callDatePicker1,
            ),
            ElevatedButton(
              child: Text(getFecha2()),
              onPressed: callDatePicker2,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: DropdownButtonFormField<Producto>(
                value: producto,
                onChanged: (value) => setState(() {
                  producto = value!;
                  init = null;
                  end = null;
                  ventas = VentasService.filtrarProducto(producto!);
                }),
                validator: (value) {
                  if (value == null) {
                    return "Elegi un producto!!";
                  }
                },
                items: ProductoService.productos
                    .map((producto) => DropdownMenuItem<Producto>(
                  child: Text(producto.nombre!),
                  value: producto,
                ))
                    .toList(),
              ),
            ),
            ListaProductosDetalles(),
            ElevatedButton(
                child: const Text("Eliminar filtros"),
                onPressed: () {
                  ventas = VentasService.getVentas();
                  producto = null;
                  init = null;
                  end = null;
                  setState(() {
                  });
                }),
            ElevatedButton(
                child: Text("Filtrar por fecha"),
                onPressed: init != null && end != null
                    ? () => {
                  ventas = VentasService.filtrarFecha(init!, end!),
                  producto = null,
                  init = null,
                  end = null,
                  setState(() {
                  }),
                } : null
            )
          ],
        )
    );
  }

  void callDatePicker1() async{
    var date = await getDatePickerWidget();
    setState(() {
      init = date;
      producto = null;
    });
  }

  void callDatePicker2() async{
    var date = await getDatePickerWidget();
    setState(() {
      end = date;
      producto = null;
    });
  }

  Future <DateTime?> getDatePickerWidget() {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2017),
        lastDate: DateTime(2032)
    );
  }
}

class ListaProductosDetalles extends StatelessWidget {
  const ListaProductosDetalles({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: ventas!.length,
      itemBuilder: (context, index) =>
          GridItem(venta: ventas![index]),
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
