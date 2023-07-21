import 'dart:convert';

import 'package:equatable/equatable.dart';

class Menu extends Equatable {
  final String id;
  final String name;
  final double price;

  const Menu({
    required this.id,
    required this.name,
    required this.price,
  });

  static const empty = Menu(
    id: '',
    name: '',
    price: 0,
  );

  factory Menu.fromMap(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
      };

  bool get isEmpty => name.isEmpty && price == 0;

  bool get isNotEmpty => name.isNotEmpty && price != 0;

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Menu(id: $id, name: $name, price: $price)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Menu &&
        other.id == id &&
        other.name == name &&
        other.price == price;
  }

  @override
  int get hashCode => name.hashCode ^ price.hashCode;

  Menu copyWith({
    String? id,
    String? name,
    double? price,
  }) {
    return Menu(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [id, name, price];
}
