import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:segundo_final_frontend/objects/cliente.dart';
import 'package:segundo_final_frontend/services/clientes_service.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({Key? key}) : super(key: key);

  @override
  _ClientesState createState() => _ClientesState();
}

class _ClientesState extends State<ClientesPage>{

  ClienteService _servicioClientes = new ClienteService();
  final _formKey = GlobalKey<FormState>();
  final _formeditKey = GlobalKey<FormState>();
  final controladorRuc = TextEditingController();
  final controladorName = TextEditingController();
  final controladorEmail = TextEditingController();

  var controladorEditRuc = TextEditingController();
  var controladorEditName = TextEditingController();
  var controladorEditEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    _clientes = _servicioClientes.getClientes();
  }

  List<Cliente>? _clientes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Clientes'),
          elevation: 5,
        ),
        body: Column(
          children: [
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _clientes!.length,
                itemBuilder: (context, index){
                  return ListTile(
                    onLongPress: (){
                      _borrarCliente(context, _clientes![index]);
                    },
                    onTap: (){
                      _alertDialogEditarCliente(context, _clientes![index]);
                    },
                    title: Text( _clientes![index].nombre!),
                    subtitle: Text(
                        'Ruc: ' +
                            _clientes![index].ruc.toString() +
                            '\n' +
                            'Email: '
                            + _clientes![index].email.toString()
                    ),
                    leading: CircleAvatar(
                        child: Text(_clientes![index].nombre.toString()[0].toUpperCase())
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  );
                }),
            ElevatedButton(
                child: Text("Agregar"),
                onPressed: () {
                  _alertDialogAgregarCliente(context);
                }
            )
          ],
        )
    );
  }

  _borrarCliente(context,Cliente cliente){
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Eliminar cliente"),
          content: Text("¿Elminiar a " + cliente.nombre.toString()+"?"),
          actions: [
            FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                }, child: const Text("Cancelar")),
            FlatButton(
                onPressed: (){
                  setState(() {
                    _servicioClientes.deleteCliente(cliente);
                    _clientes = _servicioClientes.getClientes();
                  });
                  Navigator.pop(context);
                }, child:
            const Text(
              "Borrar",
              style: TextStyle(color: Colors.red),)),
          ],
        ));
  }



  _alertDialogEditarCliente(context,Cliente cliente){
    controladorEditRuc = TextEditingController(text: cliente.ruc.toString());
    controladorEditName = TextEditingController(text: cliente.nombre.toString());
    controladorEditEmail = TextEditingController(text: cliente.email.toString());

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Actualizar Cliente'),
            content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClienteEditForm(
                        formEditKey: _formeditKey,
                        controladorRuc: controladorEditRuc,
                        controladorName: controladorEditName,
                        controladorEmail: controladorEditEmail,
                        cliente: cliente
                    ),
                    ElevatedButton(
                        child: Text("Actualizar"),
                        onPressed: () {
                          if (_formeditKey.currentState!.validate()) {
                            cliente.ruc = controladorEditRuc.value.text;
                            cliente.nombre = controladorEditName.value.text;
                            cliente.email = controladorEditEmail.value.text;
                            _servicioClientes.setCliente(
                                cliente
                            );
                            _clientes = _servicioClientes.getClientes();
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

  _alertDialogAgregarCliente(context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Agregar Cliente'),
            content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClienteCreateForm(
                      formKey: _formKey,
                      controladorRuc: controladorRuc,
                      controladorName: controladorName,
                      controladorEmail: controladorEmail,
                    ),
                    ElevatedButton(
                        child: Text("Agregar"),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _servicioClientes.setCliente(
                                new Cliente(
                                    ruc: controladorRuc.value.text,
                                    nombre: controladorName.value.text,
                                    email: controladorEmail.value.text)
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


}

class ClienteCreateForm extends StatelessWidget {

  final GlobalKey<FormState> formKey;
  final TextEditingController controladorRuc;
  final TextEditingController controladorName;
  final TextEditingController controladorEmail;
  const ClienteCreateForm(
      {Key? key,
        required this.formKey,
        required this.controladorRuc,
        required this.controladorName,
        required this.controladorEmail})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
                controller: controladorRuc,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Inserte su ruc',
                  labelText: 'RUC',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese su ruc';
                  } else {
                    for (var cl in ClienteService.clientes) {
                      if (cl.ruc == value ) {
                        return 'Este ruc ya existe, verifique nuevamente';
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
                    return 'Por favor, ingrese su nombre';
                  }else{
                    for( var cl in  ClienteService.clientes){
                      if(cl.nombre == value){
                        return 'Este nombre ya existe, verifique nuevamente';
                      }
                    }
                  }
                }
            ),
            TextFormField(
                controller: controladorEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Inserte su correo electrónico',
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese su email';
                  } else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                    return 'No es una dirección de correo válida';
                  } else {
                    for( var cl in  ClienteService.clientes){
                      if(cl.email == value){
                        return 'Este email ya está registrado, verifique nuevamente';
                      }
                    }
                  }
                }
            ),
          ],
        )
    );
  }
}

class ClienteEditForm extends StatelessWidget {

  final GlobalKey<FormState> formEditKey;
  final TextEditingController controladorRuc;
  final TextEditingController controladorName;
  final TextEditingController controladorEmail;
  final Cliente cliente;
  const ClienteEditForm(
      {Key? key,
        required this.formEditKey,
        required this.controladorRuc,
        required this.controladorName,
        required this.controladorEmail,
        required this.cliente
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
                controller: controladorRuc,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Inserte su ruc',
                  labelText: 'RUC',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese su ruc';
                  } else {
                    for (var cl in ClienteService.clientes) {
                      if (cl.ruc == num.tryParse(value) && cl!=cliente) {
                        return 'Este ruc ya existe, verifique nuevamente';
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
                    return 'Por favor, ingrese su nombre';
                  }else{
                    for( var cl in  ClienteService.clientes){
                      if(cl.nombre == value && cl!=cliente){
                        return 'Este nombre ya existe, verifique nuevamente';
                      }
                    }
                  }
                }
            ),
            TextFormField(
                controller: controladorEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Inserte su correo electrónico',
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese su email';
                  } else {
                    for( var cl in  ClienteService.clientes){
                      if(cl.email == value && cl!=cliente){
                        return 'Este email ya está registrado, verifique nuevamente';
                      }
                    }
                  }
                }
            ),
          ],
        )
    );
  }
}