import 'dart:convert';

import 'package:equatable/equatable.dart';

class Galery extends Equatable {
  final String id;
  final String url;

  const Galery({
    required this.id,
    required this.url,
  });

  Galery copyWith({
    String? id,
    String? url,
  }) {
    return Galery(
      id: id ?? this.id,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'galeryId': id,
      'imageUrl': url,
    };
  }

  factory Galery.fromMap(Map<String, dynamic> map) {
    return Galery(
      id: map['galeryId'] as String,
      url: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Galery.fromJson(String source) =>
      Galery.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Galery(id: $id, url: $url)';

  @override
  List<Object?> get props => [id, url];
}
