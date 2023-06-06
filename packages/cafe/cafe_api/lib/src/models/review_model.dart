class Review{
  final String id;
  final String cafeId;
  final String userId;
  final String userName;
  final String userPhotoUrl;
  final String review;
  final double rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.cafeId,
    required this.userId,
    required this.userName,
    required this.userPhotoUrl,
    required this.review,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'],
    cafeId: json['cafeId'],
    userId: json['userId'],
    userName: json['userName'],
    userPhotoUrl: json['userPhotoUrl'],
    review: json['review'],
    rating: json['rating'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'cafeId': cafeId,
    'userId': userId,
    'userName': userName,
    'userPhotoUrl': userPhotoUrl,
    'review': review,
    'rating': rating,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}