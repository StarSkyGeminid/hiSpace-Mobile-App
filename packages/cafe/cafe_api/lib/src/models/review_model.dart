import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String locationId;
  final String userId;
  final String userName;
  final String userPhotoUrl;
  final String review;
  final double rating;
  final DateTime? createdAt;

  const Review({
    this.id = '',
    this.locationId = '',
    required this.userId,
    this.userName = '',
    this.userPhotoUrl = '',
    required this.review,
    required this.rating,
    this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> json) => Review(
        id: json['reviewId'],
        locationId: json.containsKey('locationId') ? json['locationId'] : '',
        userId: json['userId'],
        userPhotoUrl:
            json.containsKey('userPhotoUrl') ? json['userPhotoUrl'] : '',
        review: json['comment'],
        rating: json['rating'].toDouble(),
        createdAt: json.containsKey('createdAt')
            ? DateTime.parse(json['createdAt'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'comment': review,
        'rating': rating.toStringAsFixed(0),
      };

  Review copyWith({
    String? id,
    String? locationId,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? review,
    double? rating,
    DateTime? createdAt,
  }) =>
      Review(
        id: id ?? this.id,
        locationId: locationId ?? this.locationId,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
        review: review ?? this.review,
        rating: rating ?? this.rating,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [
        id,
        locationId,
        userId,
        userName,
        userPhotoUrl,
        review,
        rating,
        createdAt,
      ];
}
