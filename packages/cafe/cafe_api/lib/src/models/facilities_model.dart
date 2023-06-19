// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Facility extends Equatable {
  final String name;
  final IconData iconData;
  final bool isCheck;

  const Facility({
    required this.name,
    required this.iconData,
    this.isCheck = false,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      name: json['name'],
      iconData: json['iconData'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  String toJson() => jsonEncode(toMap());

  @override
  List<Object?> get props => [name, iconData, isCheck];

  Facility copyWith({
    String? name,
    IconData? iconData,
    bool? isCheck,
  }) {
    return Facility(
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      isCheck: isCheck ?? this.isCheck,
    );
  }
}
