import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segundo_final_frontend/pages/clientes_page.dart';
import 'package:segundo_final_frontend/pages/mainpage.dart';
import 'package:segundo_final_frontend/pages/productos_page.dart';
import 'package:segundo_final_frontend/pages/ventas_detalladas.dart';

import 'pages/ventas_page.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Segunda Final de FrontEnd',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context) => const MainPage(),
        "/productos": (context) => const ProductosPage(),
        "/clientes": (context) => const ClientesPage(),
        "/ventas": (context) => const VentasPage(),
        "/detallesVenta": (context) => const VentasDetalles(),
      },
    );
  }
}
