import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:segundo_final_frontend/objects/cliente.dart';

import 'detalle_venta.dart';

class Venta {
  int id;
  DateTime fecha;
  String facturaNum;
  Cliente cliente;
  List<DetalleVenta> detalles = [];
  int total = 0;
  Venta({
    required this.id,
    required this.fecha,
    required this.facturaNum,
    required this.cliente,
    required this.detalles,
    required this.total,
  });

  Venta copyWith({
    int? id,
    DateTime? fecha,
    String? facturaNum,
    Cliente? cliente,
    List<DetalleVenta>? detalles,
    int? total,
  }) {
    return Venta(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      facturaNum: facturaNum ?? this.facturaNum,
      cliente: cliente ?? this.cliente,
      detalles: detalles ?? this.detalles,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha.millisecondsSinceEpoch,
      'facturaNum': facturaNum,
      'cliente': cliente.toMap(),
      'detalles': detalles.map((x) => x.toMap()).toList(),
      'total': total,
    };
  }

  factory Venta.fromMap(Map<String, dynamic> map) {
    return Venta(
      id: map['id'],
      fecha: DateTime.fromMillisecondsSinceEpoch(map['fecha']),
      facturaNum: map['facturaNum'],
      cliente: Cliente.fromMap(map['cliente']),
      detalles: List<DetalleVenta>.from(
          map['detalles']?.map((x) => DetalleVenta.fromMap(x))),
      total: map['total'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Venta.fromJson(String source) => Venta.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Venta(id: $id, fecha: $fecha, facturaNum: $facturaNum, cliente: $cliente, detalles: $detalles, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Venta &&
        other.id == id &&
        other.fecha == fecha &&
        other.facturaNum == facturaNum &&
        other.cliente == cliente &&
        listEquals(other.detalles, detalles) &&
        other.total == total;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fecha.hashCode ^
        facturaNum.hashCode ^
        cliente.hashCode ^
        detalles.hashCode ^
        total.hashCode;
  }
}
