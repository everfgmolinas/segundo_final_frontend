import 'dart:convert';

class Cliente {
  String? ruc;
  String? nombre;
  String? email;

  Cliente({this.ruc, this.nombre, this.email});

  Cliente copyWith({
    String? ruc,
    String? nombre,
    String? email,
  }) {
    return Cliente(
      ruc: ruc ?? this.ruc,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ruc': ruc,
      'nombre': nombre,
      'email': email,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      ruc: map['ruc'] != null ? map['ruc'] : null,
      nombre: map['nombre'] != null ? map['nombre'] : null,
      email: map['email'] != null ? map['email'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cliente.fromJson(String source) =>
      Cliente.fromMap(json.decode(source));

  @override
  String toString() => 'Cliente(ruc: $ruc, nombre: $nombre, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cliente &&
        other.ruc == ruc &&
        other.nombre == nombre &&
        other.email == email;
  }

  @override
  int get hashCode => ruc.hashCode ^ nombre.hashCode ^ email.hashCode;
}
