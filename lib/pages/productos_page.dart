import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:segundo_final_frontend/objects/producto.dart';
import 'package:segundo_final_frontend/services/productos_service.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({Key? key}) : super(key: key);

  @override
  _ProductosState createState() => _ProductosState();
}

class _ProductosState extends State<ProductosPage>{

  ProductoService _servicioProductos = new ProductoService();
  final _formKey = GlobalKey<FormState>();
  final _formeditKey = GlobalKey<FormState>();
  final controladorId = TextEditingController();
  final controladorName = TextEditingController();
  final controladorPrecio = TextEditingController();
  final controladorExistencia = TextEditingController();

  var controladorEditId = TextEditingController();
  var controladorEditName = TextEditingController();
  var controladorEditPrecio = TextEditingController();
  var controladorEditExistencia = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productos = _servicioProductos.getProductos();
  }

  List<Producto>? _productos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Productos'),
          elevation: 5,
        ),
        body: Column(
          children: [
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _productos!.length,
                itemBuilder: (context, index){
                  return ListTile(
                    onLongPress: (){
                      _borrarProducto(context, _productos![index]);
                    },
                    onTap: (){
                      _alertDialogEditarProducto(context, _productos![index]);
                    },
                    title: Text( _productos![index].nombre!),
                    subtitle: Text(
                        'Precio: ' +
                        _productos![index].precio.toString() +
                        '\n' +
                        'Cantidad: '
                        + _productos![index].existencia.toString()
                    ),
                    leading: CircleAvatar(
                        child: Text(_productos![index].codigo.toString())
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  );
                }),
            ElevatedButton(
                child: Text("Agregar"),
                onPressed: () {
                  _alertDialogAgregarProducto(context);
                }
            )
          ],
        )
    );
  }

  // Funcion en cargada de mostrar un mensaje de confirmacion y boorrar
  _borrarProducto(context,Producto producto){
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Elminiar producto"),
          content: const Text("Estas seguro de elminiar?"),
          actions: [
            FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                }, child: const Text("Cancelar")),
            FlatButton(
                onPressed: (){
                  setState(() {
                    _servicioProductos.deleteProducto(producto);
                    _productos = _servicioProductos.getProductos();
                  });
                  Navigator.pop(context);
                }, child:
            const Text(
              "Borrar",
              style: TextStyle(color: Colors.red),)),
          ],
        ));
  }

  _alertDialogAgregarProducto(context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Agregar Producto'),
            content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ProductoCreateForm(
                      formKey: _formKey,
                      controladorId: controladorId,
                      controladorName: controladorName,
                      controladorPrecio: controladorPrecio,
                      controladorExistencia: controladorExistencia,
                    ),
                    ElevatedButton(
                        child: Text("Agregar"),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _servicioProductos.setProducto(
                                new Producto(
                                    codigo: int.tryParse(controladorId.value.text),
                                    nombre: controladorName.value.text,
                                    precio: int.tryParse(controladorPrecio.value.text),
                                    existencia: int.tryParse(controladorExistencia.value.text))
                            );
                            setState(() {});
                          }
                        }
                    )
                  ],
                )
            ),
          );
        });
  }

  _alertDialogEditarProducto(context,Producto producto){
    controladorEditId = TextEditingController(text: producto.codigo.toString());
    controladorEditName = TextEditingController(text: producto.nombre.toString());
    controladorEditPrecio = TextEditingController(text: producto.precio.toString());
    controladorEditExistencia = TextEditingController(text: producto.existencia.toString());

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Agregar Producto'),
            content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ProductoEditForm(
                        formEditKey: _formeditKey,
                        controladorId: controladorEditId,
                        controladorName: controladorEditName,
                        controladorPrecio: controladorEditPrecio,
                        controladorExistencia: controladorEditExistencia,
                        producto: producto
                    ),
                    ElevatedButton(
                        child: Text("Agregar"),
                        onPressed: () {
                          if (_formeditKey.currentState!.validate()) {
                            producto.codigo = int.tryParse(controladorEditId.value.text);
                            producto.nombre = controladorEditName.value.text;
                            producto.precio = int.tryParse(controladorEditPrecio.value.text);
                            producto.existencia = int.tryParse(controladorEditExistencia.value.text);
                            _servicioProductos.setProducto(
                                producto
                            );
                            _productos = _servicioProductos.getProductos();
                            setState(() {});
                          }
                        }
                    )
                  ],
                )
            ),
          );
        });
  }

  Widget _idImput() {
    return TextFormField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          icon: Icon(Icons.email),
          hintText: 'Inserte el codigo',
          labelText: 'Codigo',
        ),
        validator: (value) {
          if (value!.isEmpty ) {
            return 'Ingrese un valor';
          } else {
            for (var pr in _productos!) {
              if (pr.codigo == num.tryParse(value) ) {
                return 'Codigo ya existe';
              }
            }
          }
        }
    );
  }

  Widget _nombreImput() {
    return TextFormField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          icon: Icon(Icons.email),
          hintText: 'Inserte el nombre',
          labelText: 'Nombre',
        ),
        validator: (value) {
          if (value!.isEmpty){
            return 'Ingrese un valor';
          }else{
            for( var pr in _productos!){
              if(pr.nombre == value){
                return 'Nombre ya existe';
              }
            }
          }
        }
    );
  }

  Widget _precioImput() {
    return TextFormField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          icon: Icon(Icons.email),
          hintText: 'Inserte el precio',
          labelText: 'Precio',
        ),
        validator: (value) {
          if (num.tryParse(value!) == null) {
            return 'Ingrese un valor';
          } else if(num.tryParse(value)! <= 0 ) {
            return 'Ingrese un precio válido';
          }
        }
    );
  }

  Widget _existenciaImput() {
    return TextFormField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          icon: Icon(Icons.email),
          hintText: 'Inserte el stock',
          labelText: 'Cantidad',
        ),
        validator: (value) {
          if (num.tryParse(value!) == null) {
            return 'Ingrese un valor';
          } else if (num.tryParse(value)! <= 0) {
            return 'Ingrese una cantidad válido';
          }
        }
    );
  }

  Widget _agregarProducto() {
    return ElevatedButton(
      onPressed: () {
        // devolverá true si el formulario es válido, o falso si
        // el formulario no es válido.
        if (_formKey.currentState!.validate()) {
          // Si el formulario es válido, queremos mostrar un Snackbar
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Producto no agregado')));
        }
      },
      child: Text('Agregar'),
    );
  }

}

class ProductoCreateForm extends StatelessWidget {

  final GlobalKey<FormState> formKey;
  final TextEditingController controladorId;
  final TextEditingController controladorName;
  final TextEditingController controladorPrecio;
  final TextEditingController controladorExistencia;
  const ProductoCreateForm(
      {Key? key, required this.formKey, required this.controladorId, required this.controladorName, required this.controladorPrecio, required this.controladorExistencia})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
                controller: controladorId,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Inserte el codigo',
                  labelText: 'Codigo',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese un valor';
                  } else {
                    for (var pr in ProductoService.productos) {
                      if (pr.codigo == num.tryParse(value) ) {
                        return 'Codigo ya existe';
                      }
                    }
                  }
                }
            ),
            TextFormField(
                controller: controladorName,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Inserte el nombre',
                  labelText: 'Nombre',
                ),
                validator: (value) {
                  if (value!.isEmpty){
                    return 'Ingrese un valor';
                  }else{
                    for( var pr in  ProductoService.productos){
                      if(pr.nombre == value){
                        return 'Nombre ya existe';
                      }
                    }
                  }
                }
            ),
            TextFormField(
                controller: controladorPrecio,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Inserte el precio',
                  labelText: 'Precio',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese un valor';
                  } else if(num.tryParse(value)! <= 0 ) {
                    return 'Ingrese un precio válido';
                  }
                }
            ),
            TextFormField(
                controller: controladorExistencia,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Inserte el stock',
                  labelText: 'Cantidad',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese un valor';
                  } else if (num.tryParse(value)! <= 0) {
                    return 'Ingrese una cantidad válido';
                  }
                }
            ),
          ],
        )
    );
  }
}

class ProductoEditForm extends StatelessWidget {

  final GlobalKey<FormState> formEditKey;
  final TextEditingController controladorId;
  final TextEditingController controladorName;
  final TextEditingController controladorPrecio;
  final TextEditingController controladorExistencia;
  final Producto producto;
  const ProductoEditForm(
      {Key? key,
        required this.formEditKey,
        required this.controladorId,
        required this.controladorName,
        required this.controladorPrecio,
        required this.controladorExistencia,
        required this.producto
      }
      )
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Form(
        key: formEditKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
                controller: controladorId,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Inserte el codigo',
                  labelText: 'Codigo',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese un valor';
                  } else {
                    for (var pr in ProductoService.productos) {
                      if (pr.codigo == num.tryParse(value) && pr!=producto) {
                        return 'Codigo ya existe';
                      }
                    }
                  }
                }
            ),
            TextFormField(
                controller: controladorName,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Inserte el nombre',
                  labelText: 'Nombre',
                ),
                validator: (value) {
                  if (value!.isEmpty){
                    return 'Ingrese un valor';
                  }else{
                    for( var pr in  ProductoService.productos){
                      if(pr.nombre == value && pr!=producto){
                        return 'Nombre ya existe';
                      }
                    }
                  }
                }
            ),
            TextFormField(
                controller: controladorPrecio,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Inserte el precio',
                  labelText: 'Precio',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese un valor';
                  } else if(num.tryParse(value)! <= 0 ) {
                    return 'Ingrese un precio válido';
                  }
                }
            ),
            TextFormField(
                controller: controladorExistencia,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Inserte el stock',
                  labelText: 'Cantidad',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese un valor';
                  } else if (num.tryParse(value)! <= 0) {
                    return 'Ingrese una cantidad válido';
                  }
                }
            ),
          ],
        )
    );
  }
}