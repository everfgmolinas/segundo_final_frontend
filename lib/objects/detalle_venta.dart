import 'dart:convert';

import 'package:segundo_final_frontend/objects/producto.dart';

class DetalleVenta {
  int id;
  Producto producto;
  int cantidad = 0;
  int totalDetalle = 0;
  DetalleVenta({
    required this.id,
    required this.producto,
    required this.cantidad,
    required this.totalDetalle,
  });

  DetalleVenta copyWith({
    int? id,
    Producto? producto,
    int? cantidad,
    int? totalDetalle,
  }) {
    return DetalleVenta(
      id: id ?? this.id,
      producto: producto ?? this.producto,
      cantidad: cantidad ?? this.cantidad,
      totalDetalle: totalDetalle ?? this.totalDetalle,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'producto': producto.toMap(),
      'cantidad': cantidad,
      'totalDetalle': totalDetalle,
    };
  }

  factory DetalleVenta.fromMap(Map<String, dynamic> map) {
    return DetalleVenta(
      id: map['id'],
      producto: Producto.fromMap(map['producto']),
      cantidad: map['cantidad'],
      totalDetalle: map['totalDetalle'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DetalleVenta.fromJson(String source) =>
      DetalleVenta.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DetalleVenta(id: $id, producto: $producto, cantidad: $cantidad, totalDetalle: $totalDetalle)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DetalleVenta &&
        other.id == id &&
        other.producto == producto &&
        other.cantidad == cantidad &&
        other.totalDetalle == totalDetalle;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        producto.hashCode ^
        cantidad.hashCode ^
        totalDetalle.hashCode;
  }
}
