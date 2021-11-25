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
  bool operator == (Object other) {
    if (identical(this, other)) return true;

    return other is Producto &&
        other.codigo == codigo &&
        other.nombre == nombre &&
        other.precio == precio &&
        other.existencia == existencia;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;


}