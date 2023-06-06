// class CafeModel {
//   final String locationId;
//   final String name;
//   final String address;
//   final bool isFavorite;
//   final DateTime openTime;
//   final DateTime closeTime;
//   final List<double> priceRange;
//   final double rating;
//   final List<String> tags;
//   final List<CafePictureModel>? picture;

//   const CafeModel({
//     required this.locationId,
//     required this.name,
//     required this.address,
//     required this.isFavorite,
//     required this.openTime,
//     required this.closeTime,
//     required this.priceRange,
//     required this.rating,
//     required this.tags,
//     this.picture,
//   });

//   String get priceRangeString =>
//       'Rp${(priceRange[0] / 1000).round()}K - Rp${(priceRange[1] / 1000).round()}K';

//   String? get distanceString => '1.2 km';

//   bool get isOpen {
//     final now = DateTime.now();
//     return now.isAfter(openTime) && now.isBefore(closeTime);
//   }
// }

class CafePictureModel {
  final String id;
  final String url;

  const CafePictureModel({
    required this.id,
    required this.url,
  });
}

List<CafePictureModel> pictures = [
  const CafePictureModel(
      id: '01',
      url: 'https://images.unsplash.com/photo-1567880905822-56f8e06fe630'),
  const CafePictureModel(
      id: '02',
      url: 'https://images.unsplash.com/photo-1567880905822-56f8e06fe630'),
  const CafePictureModel(
      id: '03',
      url: 'https://images.unsplash.com/photo-1567880905822-56f8e06fe630'),
];

// List<CafeModel> listCafeModel = [
//   CafeModel(
//     locationId: '1',
//     name: 'Koopi',
//     address: 'Jl. Raya Tengah Ndalan',
//     isFavorite: true,
//     openTime: DateTime.parse('2023-05-14 10:00:00'),
//     closeTime: DateTime.parse('2023-05-14 23:00:00'),
//     priceRange: [10000, 30000],
//     rating: 4.5,
//     picture: [
//       const CafePictureModel(
//           id: '01',
//           url:
//               'https://images.unsplash.com/photo-1567880905822-56f8e06fe630'),
//       const CafePictureModel(
//           id: '02',
//           url:
//               'https://images.unsplash.com/photo-1567880905822-56f8e06fe630'),
//       const CafePictureModel(
//           id: '03',
//           url:
//               'https://images.unsplash.com/photo-1567880905822-56f8e06fe630'),
//     ],
//     tags: ['Kopi', 'Kopi', 'Kopi', 'Kopi', 'Kopi', 'Kopi', 'Kopi', 'Kopi'],
//   ),
//   CafeModel(
//     locationId: '2',
//     name: 'Kopi Ilang',
//     address: 'Jl. Raya Tengah Ndalan',
//     isFavorite: false,
//     openTime: DateTime.parse('2023-05-14 11:00:00'),
//     closeTime: DateTime.parse('2023-05-14 12:00:00'),
//     priceRange: [10000, 40000],
//     rating: 4.5,
//     picture: [
//       const CafePictureModel(
//           id: '01',
//           url:
//               'https://images.unsplash.com/photo-1567880905822-56f8e06fe630'),
//       const CafePictureModel(
//           id: '02',
//           url:
//               'https://images.unsplash.com/photo-1567880905822-56f8e06fe630'),
//       const CafePictureModel(
//           id: '03',
//           url:
//               'https://images.unsplash.com/photo-1567880905822-56f8e06fe630'),
//     ],
//     tags: ['Kopi', 'Kopi', 'Kopi', 'Kopi', 'Kopi', 'Kopi', 'Kopi', 'Kopi'],
//   ),
//   CafeModel(
//     locationId: '1',
//     name: 'Kopi Pahit',
//     address: 'Jl. Raya Tengah Ndalan',
//     isFavorite: false,
//     openTime: DateTime.parse('2023-05-14 08:00:00'),
//     closeTime: DateTime.parse('2023-05-14 22:00:00'),
//     priceRange: [10000, 60000],
//     rating: 4.5,
//     picture: [
//       const CafePictureModel(
//           id: '01',
//           url:
//               'https://images.unsplash.com/photo-1567880905822-56f8e06fe630'),
//       const CafePictureModel(
//           id: '02',
//           url:
//               'https://images.unsplash.com/photo-1567880905822-56f8e06fe630'),
//       const CafePictureModel(
//           id: '03',
//           url:
//               'https://images.unsplash.com/photo-1567880905822-56f8e06fe630'),
//     ],
//     tags: ['Kopi', 'Kopi', 'Kopi', 'Kopi', 'Kopi', 'Kopi', 'Kopi', 'Kopi'],
//   ),
// ];
