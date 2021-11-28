import 'dart:convert';

class Producto {
  int? codigo;
  String? nombre;
  int? precio;
  int? existencia;

  Producto({
    this.codigo,
    this.nombre,
    this.precio,
    this.existencia,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Producto &&
        other.codigo == codigo &&
        other.nombre == nombre &&
        other.precio == precio &&
        other.existencia == existencia;
  }

  @override
  // TODO: implement hashCode
  int get hashCode {
    return codigo.hashCode ^
        nombre.hashCode ^
        precio.hashCode ^
        existencia.hashCode;
  }

  Producto copyWith({
    int? codigo,
    String? nombre,
    int? precio,
    int? existencia,
  }) {
    return Producto(
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      existencia: existencia ?? this.existencia,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nombre': nombre,
      'precio': precio,
      'existencia': existencia,
    };
  }

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      codigo: map['codigo'] != null ? map['codigo'] : null,
      nombre: map['nombre'] != null ? map['nombre'] : null,
      precio: map['precio'] != null ? map['precio'] : null,
      existencia: map['existencia'] != null ? map['existencia'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Producto.fromJson(String source) =>
      Producto.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Producto(codigo: $codigo, nombre: $nombre, precio: $precio, existencia: $existencia)';
  }
}
