import 'package:melodymarket/models/track.dart';
import 'package:melodymarket/models/purchase.dart';

class Album {
  final String id;
  final String title;
  final String artistId;
  final String artistName;
  final double price;
  final String coverImageUrl;
  final List<Track> tracks;
  final DateTime createdAt;
  final String genre;
  final String description;
  final bool isDownloaded;

  Album({
    required this.id,
    required this.title,
    required this.artistId,
    required this.artistName,
    required this.price,
    required this.coverImageUrl,
    this.tracks = const [],
    required this.createdAt,
    this.genre = 'Unknown',
    this.description = '',
    this.isDownloaded = false,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    id: json['id'],
    title: json['title'],
    artistId: json['artistId'],
    artistName: json['artistName'],
    price: (json['price'] as num).toDouble(),
    coverImageUrl: json['coverImageUrl'],
    tracks: (json['tracks'] as List<dynamic>?)
        ?.map((track) => Track.fromJson(track))
        .toList() ?? [],
    createdAt: DateTime.parse(json['createdAt']),
    genre: json['genre'] ?? 'Unknown',
    description: json['description'] ?? '',
    isDownloaded: json['isDownloaded'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artistId': artistId,
    'artistName': artistName,
    'price': price,
    'coverImageUrl': coverImageUrl,
    'tracks': tracks.map((track) => track.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'genre': genre,
    'description': description,
    'isDownloaded': isDownloaded,
  };

  String get formattedPrice => 'L${price.toStringAsFixed(2)}';

  int get trackCount => tracks.length;

  Album copyWith({
    String? id,
    String? title,
    String? artistId,
    String? artistName,
    double? price,
    String? coverImageUrl,
    List<Track>? tracks,
    DateTime? createdAt,
    String? genre,
    String? description,
    bool? isDownloaded,
  }) {
    return Album(
      id: id ?? this.id,
      title: title ?? this.title,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      price: price ?? this.price,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      tracks: tracks ?? this.tracks,
      createdAt: createdAt ?? this.createdAt,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  Purchase toPurchase(String userId) => Purchase(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    userId: userId,
    albumId: id,
    purchaseDate: DateTime.now(),
    price: price,
  );
}