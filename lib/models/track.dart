class Track {
  final String id;
  final String title;
  final String artist;
  final String artistId;
  final String duration;
  final String? fileUrl;
  final String? previewUrl;
  final String? albumId;
  final int trackNumber;
  final double price;
  final bool isFree;
  final int streamCount;
  final int purchaseCount;
  final String genre;
  final String? coverImageUrl;
  final DateTime createdAt;
  final List<String> tags;
  final bool isDownloaded;

  Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.artistId,
    required this.duration,
    this.fileUrl,
    this.previewUrl,
    this.albumId,
    this.trackNumber = 1,
    this.price = 0.0,
    this.isFree = true,
    this.streamCount = 0,
    this.purchaseCount = 0,
    required this.genre,
    this.coverImageUrl,
    required this.createdAt,
    this.tags = const [],
    this.isDownloaded = false,
  });

  factory Track.fromJson(Map<String, dynamic> json) => Track(
    id: json['id'],
    title: json['title'],
    artist: json['artist'],
    artistId: json['artistId'],
    duration: json['duration'],
    fileUrl: json['fileUrl'],
    previewUrl: json['previewUrl'],
    albumId: json['albumId'],
    trackNumber: json['trackNumber'] ?? 1,
    price: (json['price'] ?? 0.0).toDouble(),
    isFree: json['isFree'] ?? true,
    streamCount: json['streamCount'] ?? 0,
    purchaseCount: json['purchaseCount'] ?? 0,
    genre: json['genre'],
    coverImageUrl: json['coverImageUrl'],
    createdAt: DateTime.parse(json['createdAt']),
    tags: List<String>.from(json['tags'] ?? []),
    isDownloaded: json['isDownloaded'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist': artist,
    'artistId': artistId,
    'duration': duration,
    'fileUrl': fileUrl,
    'previewUrl': previewUrl,
    'albumId': albumId,
    'trackNumber': trackNumber,
    'price': price,
    'isFree': isFree,
    'streamCount': streamCount,
    'purchaseCount': purchaseCount,
    'genre': genre,
    'coverImageUrl': coverImageUrl,
    'createdAt': createdAt.toIso8601String(),
    'tags': tags,
    'isDownloaded': isDownloaded,
  };
}