import 'dart:convert';

import 'package:equatable/equatable.dart';

class Menu extends Equatable {
  final String name;
  final double price;

  const Menu({
    required this.name,
    required this.price,
  });

  static const empty = Menu(
    name: '',
    price: 0,
  );

  factory Menu.fromMap(Map<String, dynamic> json) {
    return Menu(
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
  String toString() => 'Menu(name: $name, price: $price)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Menu && other.name == name && other.price == price;
  }

  @override
  int get hashCode => name.hashCode ^ price.hashCode;

  Menu copyWith({
    String? name,
    double? price,
  }) {
    return Menu(
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [name, price];
}
