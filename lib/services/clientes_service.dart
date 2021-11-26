import 'package:segundo_final_frontend/objects/cliente.dart';

class ClienteService {
  static List<Cliente> clientes = [
    new Cliente(ruc: "1234567-2", nombre: "Elias Cáceres", email: "ejemplo1@gmail.com"),
    new Cliente(ruc: "3456567-1", nombre: "Ever Garay", email: "ejemplo2@gmail.com"),
    new Cliente(ruc: "4756567-2", nombre: "Marcelo Molas", email: "ejemplo3@gmail.com"),
    new Cliente(ruc: "3408967-1", nombre: "Carin Martínez", email: "ejemplo4@gmail.com"),
    new Cliente(ruc: "1452587-2", nombre: "Melani Bazán", email: "ejemplo5@gmail.com"),
  ];

  List<Cliente> getClientes(){
    clientes.sort((a,b) => a.nombre!.compareTo(b.nombre!));
    return clientes;
  }

  deleteCliente(Cliente cliente){
    clientes.remove(cliente);
  }

  setCliente(Cliente cliente){
    clientes.add(cliente);
    clientes = clientes.toSet().toList();
  }

}