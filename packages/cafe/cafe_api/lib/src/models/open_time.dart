// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class OpenTime {
  final Day? monday;
  final Day? tuesday;
  final Day? wednesday;
  final Day? thursday;
  final Day? friday;
  final Day? saturday;
  final Day? sunday;

  const OpenTime({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  OpenTime copyWith({
    Day? monday,
    Day? tuesday,
    Day? wednesday,
    Day? thursday,
    Day? friday,
    Day? saturday,
    Day? sunday,
  }) {
    return OpenTime(
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
    );
  }

  static const empty = OpenTime(
    monday: null,
    tuesday: null,
    wednesday: null,
    thursday: null,
    friday: null,
    saturday: null,
    sunday: null,
  );

  OpenTime setFromIndex(index, Day day) {
    switch (index) {
      case 0:
        return copyWith(monday: day);
      case 1:
        return copyWith(tuesday: day);
      case 2:
        return copyWith(wednesday: day);
      case 3:
        return copyWith(thursday: day);
      case 4:
        return copyWith(friday: day);
      case 5:
        return copyWith(saturday: day);
      case 6:
        return copyWith(sunday: day);
      default:
        return this;
    }
  }

  Day? getFromIndex(index) {
    switch (index) {
      case 0:
        return monday;
      case 1:
        return tuesday;
      case 2:
        return wednesday;
      case 3:
        return thursday;
      case 4:
        return friday;
      case 5:
        return saturday;
      case 6:
        return sunday;
      default:
        return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'monday': monday?.toMap(),
      'tuesday': tuesday?.toMap(),
      'wednesday': wednesday?.toMap(),
      'thursday': thursday?.toMap(),
      'friday': friday?.toMap(),
      'saturday': saturday?.toMap(),
      'sunday': sunday?.toMap(),
    };
  }

  factory OpenTime.fromMap(Map<String, dynamic> json) {
    return OpenTime(
        monday: Day.fromMap(json['monday'], Days.monday),
        tuesday: Day.fromMap(json['tuesday'], Days.tuesday),
        wednesday: Day.fromMap(json['wednesday'], Days.wednesday),
        thursday: Day.fromMap(json['thursday'], Days.thursday),
        friday: Day.fromMap(json['friday'], Days.friday),
        saturday: Day.fromMap(json['saturday'], Days.saturday),
        sunday: Day.fromMap(json['sunday'], Days.sunday));
  }

  String toJson() => json.encode(toMap());

  bool isValid() {
    bool status = (monday?.isValid() ?? true) &&
        (tuesday?.isValid() ?? true) &&
        (wednesday?.isValid() ?? true) &&
        (thursday?.isValid() ?? true) &&
        (friday?.isValid() ?? true) &&
        (saturday?.isValid() ?? true) &&
        (sunday?.isValid() ?? true);

    return status;
  }

  bool get isOpenNow {
    final now = DateTime.now();
    final day = getFromIndex(now.weekday - 1);
    if (day == null) return false;

    final openTime = DateTime(now.year, now.month, now.day, day.open?.hour ?? 0,
        day.open?.minute ?? 0);

    int isOvernight = 0;

    if (day.close != null &&
        day.open != null &&
        day.close!.hour < day.open!.hour) {
      isOvernight = 1;
    }

    DateTime closeTime = DateTime(now.year, now.month, now.day,
        day.close?.hour ?? 0, day.close?.minute ?? 0);

    closeTime = closeTime.add(Duration(days: isOvernight));

    return now.isAfter(openTime) && now.isBefore(closeTime);
  }
}

class Day {
  final Days day;
  final TimeOfDay? open;
  final TimeOfDay? close;

  const Day({
    required this.day,
    this.open,
    this.close,
  });

  Day copyWith({
    Days? day,
    TimeOfDay? open,
    TimeOfDay? close,
  }) {
    return Day(
      day: day ?? this.day,
      open: open ?? this.open,
      close: close ?? this.close,
    );
  }

  Map<String, dynamic> toMap() {
    final now = DateTime.now();
    final openTime = DateTime(
        now.year, now.month, now.day, open?.hour ?? 0, open?.minute ?? 0);

    final closeTime = DateTime(
        now.year, now.month, now.day, close?.hour ?? 0, close?.minute ?? 0);

    return {
      'open': DateFormat('HH:mm').format(openTime),
      'close': DateFormat('HH:mm').format(closeTime),
    };
  }

  factory Day.fromMap(Map<String, dynamic>? json, Days days) {
    return Day(
      day: days,
      open: json != null && json.containsKey('open')
          ? TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(json['open']))
          : null,
      close: json != null && json.containsKey('close')
          ? TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(json['close']))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  bool isValid() {
    return open != null && close != null || open == null && close == null;
  }
}
