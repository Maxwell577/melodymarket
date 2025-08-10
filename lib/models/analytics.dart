class TrackAnalytics {
  final String trackId;
  final int totalStreams;
  final int totalPurchases;
  final double totalEarnings;
  final List<DailyAnalytics> dailyStats;
  final Map<String, int> countryStreams;
  final Map<String, int> ageGroupStreams;

  TrackAnalytics({
    required this.trackId,
    this.totalStreams = 0,
    this.totalPurchases = 0,
    this.totalEarnings = 0.0,
    this.dailyStats = const [],
    this.countryStreams = const {},
    this.ageGroupStreams = const {},
  });

  factory TrackAnalytics.fromJson(Map<String, dynamic> json) => TrackAnalytics(
    trackId: json['trackId'],
    totalStreams: json['totalStreams'] ?? 0,
    totalPurchases: json['totalPurchases'] ?? 0,
    totalEarnings: (json['totalEarnings'] ?? 0.0).toDouble(),
    dailyStats: (json['dailyStats'] as List?)
        ?.map((e) => DailyAnalytics.fromJson(e))
        .toList() ?? [],
    countryStreams: Map<String, int>.from(json['countryStreams'] ?? {}),
    ageGroupStreams: Map<String, int>.from(json['ageGroupStreams'] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    'trackId': trackId,
    'totalStreams': totalStreams,
    'totalPurchases': totalPurchases,
    'totalEarnings': totalEarnings,
    'dailyStats': dailyStats.map((e) => e.toJson()).toList(),
    'countryStreams': countryStreams,
    'ageGroupStreams': ageGroupStreams,
  };
}

class DailyAnalytics {
  final DateTime date;
  final int streams;
  final int purchases;
  final double earnings;

  DailyAnalytics({
    required this.date,
    this.streams = 0,
    this.purchases = 0,
    this.earnings = 0.0,
  });

  factory DailyAnalytics.fromJson(Map<String, dynamic> json) => DailyAnalytics(
    date: DateTime.parse(json['date']),
    streams: json['streams'] ?? 0,
    purchases: json['purchases'] ?? 0,
    earnings: (json['earnings'] ?? 0.0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'streams': streams,
    'purchases': purchases,
    'earnings': earnings,
  };
}

class ArtistAnalytics {
  final String artistId;
  final int totalFollowers;
  final int totalStreams;
  final double totalEarnings;
  final List<TrackAnalytics> topTracks;
  final Map<String, int> monthlyStreams;

  ArtistAnalytics({
    required this.artistId,
    this.totalFollowers = 0,
    this.totalStreams = 0,
    this.totalEarnings = 0.0,
    this.topTracks = const [],
    this.monthlyStreams = const {},
  });

  factory ArtistAnalytics.fromJson(Map<String, dynamic> json) => ArtistAnalytics(
    artistId: json['artistId'],
    totalFollowers: json['totalFollowers'] ?? 0,
    totalStreams: json['totalStreams'] ?? 0,
    totalEarnings: (json['totalEarnings'] ?? 0.0).toDouble(),
    topTracks: (json['topTracks'] as List?)
        ?.map((e) => TrackAnalytics.fromJson(e))
        .toList() ?? [],
    monthlyStreams: Map<String, int>.from(json['monthlyStreams'] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    'artistId': artistId,
    'totalFollowers': totalFollowers,
    'totalStreams': totalStreams,
    'totalEarnings': totalEarnings,
    'topTracks': topTracks.map((e) => e.toJson()).toList(),
    'monthlyStreams': monthlyStreams,
  };
}