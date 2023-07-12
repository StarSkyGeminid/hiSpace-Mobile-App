import 'package:cafe_api/src/models/models.dart';
import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String locationId;
  final String review;
  final double rating;
  final UserModel user;
  final DateTime? createdAt;

  const Review({
    this.id = '',
    this.locationId = '',
    required this.review,
    required this.rating,
    required this.user,
    this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> json) => Review(
        id: json['reviewId'],
        locationId: json.containsKey('locationId') ? json['locationId'] : '',
        review: json['comment'],
        rating: json['rating'].toDouble(),
        user: UserModel.fromMap(json['user'] as Map<String, dynamic>),
        createdAt: json.containsKey('createdAt')
            ? DateTime.parse(json['createdAt'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'userId': user.userId,
        'comment': review,
        'rating': rating.toStringAsFixed(0),
      };

  Review copyWith({
    String? id,
    String? locationId,
    String? review,
    double? rating,
    UserModel? user,
    DateTime? createdAt,
  }) =>
      Review(
        id: id ?? this.id,
        locationId: locationId ?? this.locationId,
        review: review ?? this.review,
        rating: rating ?? this.rating,
        createdAt: createdAt ?? this.createdAt,
        user: user ?? this.user,
      );

  @override
  List<Object?> get props => [
        id,
        locationId,
        review,
        rating,
        createdAt,
      ];
}
