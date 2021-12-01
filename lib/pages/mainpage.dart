import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Productos'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pushNamed(context, "/productos");
              },
            ),
            ListTile(
              title: const Text('Clientes'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pushNamed(context, "/clientes");
              },
            ),
            ListTile(
              title: const Text('Ventas'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pushNamed(context, "/ventas");
              },
            ),
            ListTile(
              title: const Text('Detalles Venta'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pushNamed(context, "/detallesVenta");
              },
            ),
            ListTile(
              title: const Text('Resumen Venta'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pushNamed(context, "/resumenVenta");
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Bienvenid@"),
      ),
    );
  }
}
