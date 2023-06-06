// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Galery {
  final String id;
  final String url;
  Galery({
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
  bool operator ==(covariant Galery other) {
    if (identical(this, other)) return true;

    return other.id == id && other.url == url;
  }

  @override
  int get hashCode => id.hashCode ^ url.hashCode;
}
