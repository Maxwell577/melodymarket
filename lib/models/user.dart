class User {
  final String id;
  final String name;
  final String email;
  final bool isArtist;
  final String? profileImage;
  final List<String> purchasedTracks;
  final List<String> purchasedAlbums;
  final List<String> downloadedAlbums;
  final List<String> following;
  final List<String> followers;
  final String? bio;
  final Map<String, String>? socialLinks;
  final double balance; // For artists
  final String? phoneNumber; // For MTN Mobile Money

  User({
    required this.id,
    required this.name,
    required this.email,
    this.isArtist = false,
    this.profileImage,
    this.purchasedTracks = const [],
    this.purchasedAlbums = const [],
    this.downloadedAlbums = const [],
    this.following = const [],
    this.followers = const [],
    this.bio,
    this.socialLinks,
    this.balance = 0.0,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    isArtist: json['isArtist'] ?? false,
    profileImage: json['profileImage'],
    purchasedTracks: List<String>.from(json['purchasedTracks'] ?? []),
    purchasedAlbums: List<String>.from(json['purchasedAlbums'] ?? []),
    downloadedAlbums: List<String>.from(json['downloadedAlbums'] ?? []),
    following: List<String>.from(json['following'] ?? []),
    followers: List<String>.from(json['followers'] ?? []),
    bio: json['bio'],
    socialLinks: json['socialLinks'] != null 
        ? Map<String, String>.from(json['socialLinks']) 
        : null,
    balance: (json['balance'] ?? 0.0).toDouble(),
    phoneNumber: json['phoneNumber'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'isArtist': isArtist,
    'profileImage': profileImage,
    'purchasedTracks': purchasedTracks,
    'purchasedAlbums': purchasedAlbums,
    'downloadedAlbums': downloadedAlbums,
    'following': following,
    'followers': followers,
    'bio': bio,
    'socialLinks': socialLinks,
    'balance': balance,
    'phoneNumber': phoneNumber,
  };

  User copyWith({
    String? id,
    String? name,
    String? email,
    bool? isArtist,
    String? profileImage,
    List<String>? purchasedTracks,
    List<String>? purchasedAlbums,
    List<String>? downloadedAlbums,
    List<String>? following,
    List<String>? followers,
    String? bio,
    Map<String, String>? socialLinks,
    double? balance,
    String? phoneNumber,
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    isArtist: isArtist ?? this.isArtist,
    profileImage: profileImage ?? this.profileImage,
    purchasedTracks: purchasedTracks ?? this.purchasedTracks,
    purchasedAlbums: purchasedAlbums ?? this.purchasedAlbums,
    downloadedAlbums: downloadedAlbums ?? this.downloadedAlbums,
    following: following ?? this.following,
    followers: followers ?? this.followers,
    bio: bio ?? this.bio,
    socialLinks: socialLinks ?? this.socialLinks,
    balance: balance ?? this.balance,
    phoneNumber: phoneNumber ?? this.phoneNumber,
  );
}