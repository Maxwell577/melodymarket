import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:melodymarket/models/user.dart';
import 'package:melodymarket/models/album.dart';
import 'package:melodymarket/models/track.dart';
import 'package:melodymarket/models/purchase.dart';

class StorageService {
  static const String _userKey = 'current_user';
  static const String _albumsKey = 'albums';
  static const String _purchasesKey = 'purchases';
  static const String _isInitializedKey = 'is_initialized';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _initializeSampleData();
  }

  static Future<void> _initializeSampleData() async {
    final isInitialized = _prefs!.getBool(_isInitializedKey) ?? false;
    if (!isInitialized) {
      await _createSampleData();
      await _prefs!.setBool(_isInitializedKey, true);
    }
  }

  static Future<void> _createSampleData() async {
    final sampleAlbums = [
      Album(
        id: '1',
        title: 'Midnight Vibes',
        artistId: 'artist1',
        artistName: 'Luna Eclipse',
        price: 12.99,
        coverImageUrl: 'https://pixabay.com/get/gb223fd4f7b017d2ccaafa9d8905ee83ec85ccfc09c554239fa23c70d96abfa494a203ce5640fd59147fb96e648b3ecf9357a01279b142616e36b6a6d436ccaf5_1280.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        genre: 'Electronic',
        description: 'A collection of ambient electronic tracks perfect for late-night listening.',
        tracks: [
          Track(
            id: '1-1',
            title: 'Neon Dreams',
            artist: 'Luna Eclipse',
            artistId: 'artist1',
            duration: '4:32',
            albumId: '1',
            trackNumber: 1,
            price: 2.50,
            isFree: false,
            genre: 'Electronic',
            previewUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
            createdAt: DateTime.now().subtract(Duration(days: 30)),
          ),
          Track(
            id: '1-2',
            title: 'City Lights',
            artist: 'Luna Eclipse',
            artistId: 'artist1',
            duration: '3:47',
            albumId: '1',
            trackNumber: 2,
            price: 2.50,
            isFree: false,
            genre: 'Electronic',
            previewUrl: 'https://www.soundjay.com/misc/sounds/magic-chime-02.wav',
            createdAt: DateTime.now().subtract(Duration(days: 30)),
          ),
          Track(
            id: '1-3',
            title: 'Digital Rain',
            artist: 'Luna Eclipse',
            artistId: 'artist1',
            duration: '5:21',
            albumId: '1',
            trackNumber: 3,
            price: 2.50,
            isFree: false,
            genre: 'Electronic',
            previewUrl: 'https://www.soundjay.com/misc/sounds/clock-chimes-01.wav',
            createdAt: DateTime.now().subtract(Duration(days: 30)),
          ),
          Track(
            id: '1-4',
            title: 'Midnight Drive',
            artist: 'Luna Eclipse',
            artistId: 'artist1',
            duration: '4:15',
            albumId: '1',
            trackNumber: 4,
            price: 2.50,
            isFree: false,
            genre: 'Electronic',
            previewUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
            createdAt: DateTime.now().subtract(Duration(days: 30)),
          ),
        ],
      ),
      Album(
        id: '2',
        title: 'Acoustic Soul',
        artistId: 'artist2',
        artistName: 'River Stone',
        price: 9.99,
        coverImageUrl: 'https://pixabay.com/get/ga9359d6585aa0c61393a035ee4ca1258ebe40f3646dfc71682308a667fc76eac25bc981b77c6f9f347388db82cd92dffa8df590ee6162d6f068f21e451b4ecb2_1280.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        genre: 'Acoustic',
        description: 'Heartfelt acoustic melodies that speak to the soul.',
        tracks: [
          Track(
            id: '2-1',
            title: 'Morning Coffee',
            artist: 'River Stone',
            artistId: 'artist2',
            duration: '3:28',
            albumId: '2',
            trackNumber: 1,
            price: 1.99,
            isFree: false,
            genre: 'Acoustic',
            previewUrl: 'https://www.soundjay.com/misc/sounds/magic-chime-02.wav',
            createdAt: DateTime.now().subtract(Duration(days: 15)),
          ),
          Track(
            id: '2-2',
            title: 'River Flow',
            artist: 'River Stone',
            artistId: 'artist2',
            duration: '4:12',
            albumId: '2',
            trackNumber: 2,
            price: 1.99,
            isFree: false,
            genre: 'Acoustic',
            previewUrl: 'https://www.soundjay.com/misc/sounds/clock-chimes-01.wav',
            createdAt: DateTime.now().subtract(Duration(days: 15)),
          ),
          Track(
            id: '2-3',
            title: 'Old Oak Tree',
            artist: 'River Stone',
            artistId: 'artist2',
            duration: '3:55',
            albumId: '2',
            trackNumber: 3,
            price: 1.99,
            isFree: false,
            genre: 'Acoustic',
            previewUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
            createdAt: DateTime.now().subtract(Duration(days: 15)),
          ),
        ],
      ),
      Album(
        id: '3',
        title: 'Beat Drop',
        artistId: 'artist3',
        artistName: 'DJ Thunder',
        price: 15.99,
        coverImageUrl: 'https://pixabay.com/get/g0f4cebba13c92940a112ec5a1152e25860d231994355ffc6b53cc95c80fa759499df065918c8c2242b4be699e2b928ae561c4732be50098b10351e5aec9de56c_1280.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        genre: 'EDM',
        description: 'High-energy electronic dance music to get you moving.',
        tracks: [
          Track(
            id: '3-1',
            title: 'Bass Explosion',
            artist: 'DJ Thunder',
            artistId: 'artist3',
            duration: '5:43',
            albumId: '3',
            trackNumber: 1,
            price: 2500,
            isFree: false,
            genre: 'EDM',
            previewUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
            createdAt: DateTime.now().subtract(Duration(days: 7)),
          ),
          Track(
            id: '3-2',
            title: 'Rhythm Machine',
            artist: 'DJ Thunder',
            artistId: 'artist3',
            duration: '4:28',
            albumId: '3',
            trackNumber: 2,
            price: 2500,
            isFree: false,
            genre: 'EDM',
            previewUrl: 'https://www.soundjay.com/misc/sounds/magic-chime-02.wav',
            createdAt: DateTime.now().subtract(Duration(days: 7)),
          ),
          Track(
            id: '3-3',
            title: 'Synth Wave',
            artist: 'DJ Thunder',
            artistId: 'artist3',
            duration: '6:12',
            albumId: '3',
            trackNumber: 3,
            price: 2500,
            isFree: false,
            genre: 'EDM',
            previewUrl: 'https://www.soundjay.com/misc/sounds/clock-chimes-01.wav',
            createdAt: DateTime.now().subtract(Duration(days: 7)),
          ),
          Track(
            id: '3-4',
            title: 'Dance Floor',
            artist: 'DJ Thunder',
            artistId: 'artist3',
            duration: '4:55',
            albumId: '3',
            trackNumber: 4,
            price: 2500,
            isFree: false,
            genre: 'EDM',
            previewUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
            createdAt: DateTime.now().subtract(Duration(days: 7)),
          ),
          Track(
            id: '3-5',
            title: 'Final Beat',
            artist: 'DJ Thunder',
            artistId: 'artist3',
            duration: '5:31',
            albumId: '3',
            trackNumber: 5,
            price: 2500,
            isFree: false,
            genre: 'EDM',
            previewUrl: 'https://www.soundjay.com/misc/sounds/magic-chime-02.wav',
            createdAt: DateTime.now().subtract(Duration(days: 7)),
          ),
        ],
      ),
      Album(
        id: '4',
        title: 'Jazz Nights',
        artistId: 'artist4',
        artistName: 'Smooth Quartet',
        price: 11.99,
        coverImageUrl: 'https://pixabay.com/get/gb0417116fecf002f737657f4879d6382d2812a83c3ca3e17c477b1b02fa9b1cff29751ddcb7412f4daa3c4bd6f4e2c3daa9427f90c15b38927776ee46e28af1e_1280.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        genre: 'Jazz',
        description: 'Smooth jazz compositions for elegant evenings.',
        tracks: [
          Track(
            id: '4-1',
            title: 'Blue Moon',
            artist: 'Smooth Quartet',
            artistId: 'artist4',
            duration: '6:22',
            albumId: '4',
            trackNumber: 1,
            price: 2.25,
            isFree: false,
            genre: 'Jazz',
            previewUrl: 'https://www.soundjay.com/misc/sounds/clock-chimes-01.wav',
            createdAt: DateTime.now().subtract(Duration(days: 45)),
          ),
          Track(
            id: '4-2',
            title: 'Velvet Voice',
            artist: 'Smooth Quartet',
            artistId: 'artist4',
            duration: '4:47',
            albumId: '4',
            trackNumber: 2,
            price: 2.25,
            isFree: false,
            genre: 'Jazz',
            previewUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
            createdAt: DateTime.now().subtract(Duration(days: 45)),
          ),
          Track(
            id: '4-3',
            title: 'Midnight Sax',
            artist: 'Smooth Quartet',
            artistId: 'artist4',
            duration: '5:33',
            albumId: '4',
            trackNumber: 3,
            price: 2.25,
            isFree: false,
            genre: 'Jazz',
            previewUrl: 'https://www.soundjay.com/misc/sounds/magic-chime-02.wav',
            createdAt: DateTime.now().subtract(Duration(days: 45)),
          ),
        ],
      ),
      Album(
        id: '5',
        title: 'Rock Anthem',
        artistId: 'artist5',
        artistName: 'Electric Storm',
        price: 13.99,
        coverImageUrl: 'https://pixabay.com/get/g52d4139eca0c4b144d782cb998bd0ebb012cee6fb2fd3c86f1c735842fa13b5a6d12aa1a57a51c7142f8b2ea4a09d414f118a177b96f94a245f3d157c9b2f881_1280.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 22)),
        genre: 'Rock',
        description: 'Powerful rock anthems with electrifying guitar solos.',
        tracks: [
          Track(
            id: '5-1',
            title: 'Thunder Strike',
            artist: 'Electric Storm',
            artistId: 'artist5',
            duration: '4:18',
            albumId: '5',
            trackNumber: 1,
            price: 2.99,
            isFree: false,
            genre: 'Rock',
            previewUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
            createdAt: DateTime.now().subtract(Duration(days: 22)),
          ),
          Track(
            id: '5-2',
            title: 'Lightning Bolt',
            artist: 'Electric Storm',
            artistId: 'artist5',
            duration: '3:52',
            albumId: '5',
            trackNumber: 2,
            price: 2.99,
            isFree: false,
            genre: 'Rock',
            previewUrl: 'https://www.soundjay.com/misc/sounds/magic-chime-02.wav',
            createdAt: DateTime.now().subtract(Duration(days: 22)),
          ),
          Track(
            id: '5-3',
            title: 'Storm Rising',
            artist: 'Electric Storm',
            artistId: 'artist5',
            duration: '5:07',
            albumId: '5',
            trackNumber: 3,
            price: 2.99,
            isFree: false,
            genre: 'Rock',
            previewUrl: 'https://www.soundjay.com/misc/sounds/clock-chimes-01.wav',
            createdAt: DateTime.now().subtract(Duration(days: 22)),
          ),
          Track(
            id: '5-4',
            title: 'Electric Dreams',
            artist: 'Electric Storm',
            artistId: 'artist5',
            duration: '4:44',
            albumId: '5',
            trackNumber: 4,
            price: 2.99,
            isFree: false,
            genre: 'Rock',
            previewUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
            createdAt: DateTime.now().subtract(Duration(days: 22)),
          ),
        ],
      ),
    ];

    final albumsJson = sampleAlbums.map((album) => album.toJson()).toList();
    await _prefs!.setString(_albumsKey, jsonEncode(albumsJson));
  }

  static Future<User?> getCurrentUser() async {
    final userJson = _prefs!.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> saveUser(User user) async {
    await _prefs!.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<void> setCurrentUser(String name, String email, {bool isArtist = false}) async {
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      isArtist: isArtist,
      // Add some sample purchased and downloaded albums for demo
      purchasedAlbums: ['1', '2'], // Sample purchases
      downloadedAlbums: ['1'], // Sample download
    );
    await saveUser(user);
    
    // Add corresponding purchase records
    final purchase1 = Purchase(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: user.id,
      albumId: '1',
      purchaseDate: DateTime.now().subtract(const Duration(days: 5)),
      price: 12.99,
    );
    final purchase2 = Purchase(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      userId: user.id,
      albumId: '2',
      purchaseDate: DateTime.now().subtract(const Duration(days: 3)),
      price: 9.99,
    );
    
    final purchases = await getPurchases();
    purchases.addAll([purchase1, purchase2]);
    final purchasesJson = purchases.map((purchase) => purchase.toJson()).toList();
    await _prefs!.setString(_purchasesKey, jsonEncode(purchasesJson));
  }

  static Future<List<Album>> getAlbums() async {
    final albumsJson = _prefs!.getString(_albumsKey);
    if (albumsJson != null) {
      final List<dynamic> albumsList = jsonDecode(albumsJson);
      return albumsList.map((album) => Album.fromJson(album)).toList();
    }
    return [];
  }

  static Future<void> saveAlbum(Album album) async {
    final albums = await getAlbums();
    final existingIndex = albums.indexWhere((a) => a.id == album.id);
    if (existingIndex >= 0) {
      albums[existingIndex] = album;
    } else {
      albums.add(album);
    }
    final albumsJson = albums.map((album) => album.toJson()).toList();
    await _prefs!.setString(_albumsKey, jsonEncode(albumsJson));
  }

  static Future<List<Purchase>> getPurchases() async {
    final purchasesJson = _prefs!.getString(_purchasesKey);
    if (purchasesJson != null) {
      final List<dynamic> purchasesList = jsonDecode(purchasesJson);
      return purchasesList.map((purchase) => Purchase.fromJson(purchase)).toList();
    }
    return [];
  }

  static Future<void> savePurchase(Purchase purchase) async {
    final purchases = await getPurchases();
    purchases.add(purchase);
    final purchasesJson = purchases.map((purchase) => purchase.toJson()).toList();
    await _prefs!.setString(_purchasesKey, jsonEncode(purchasesJson));

    final user = await getCurrentUser();
    if (user != null) {
      final updatedUser = user.copyWith(
        purchasedAlbums: [...user.purchasedAlbums, purchase.albumId],
      );
      await saveUser(updatedUser);
    }
  }

  static Future<bool> hasUserPurchasedAlbum(String albumId) async {
    final user = await getCurrentUser();
    return user?.purchasedAlbums.contains(albumId) ?? false;
  }

  static Future<List<Album>> getUserPurchasedAlbums() async {
    final user = await getCurrentUser();
    if (user == null || user.purchasedAlbums.isEmpty) return [];

    final allAlbums = await getAlbums();
    return allAlbums.where((album) => user.purchasedAlbums.contains(album.id)).toList();
  }

  static Future<List<Album>> getUserDownloadedAlbums() async {
    final user = await getCurrentUser();
    if (user == null || user.downloadedAlbums.isEmpty) return [];

    final allAlbums = await getAlbums();
    return allAlbums.where((album) => user.downloadedAlbums.contains(album.id)).toList();
  }

  static Future<void> markAlbumAsDownloaded(String albumId) async {
    final user = await getCurrentUser();
    if (user != null && !user.downloadedAlbums.contains(albumId)) {
      final updatedUser = user.copyWith(
        downloadedAlbums: [...user.downloadedAlbums, albumId],
      );
      await saveUser(updatedUser);
    }
  }

  static Future<void> removeAlbumFromDownloaded(String albumId) async {
    final user = await getCurrentUser();
    if (user != null && user.downloadedAlbums.contains(albumId)) {
      final downloadedAlbums = user.downloadedAlbums.where((id) => id != albumId).toList();
      final updatedUser = user.copyWith(downloadedAlbums: downloadedAlbums);
      await saveUser(updatedUser);
    }
  }

  static Future<bool> isAlbumDownloaded(String albumId) async {
    final user = await getCurrentUser();
    return user?.downloadedAlbums.contains(albumId) ?? false;
  }
}