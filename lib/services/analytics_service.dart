import 'package:melodymarket/models/analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  Future<ArtistAnalytics> getArtistAnalytics(String artistId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock analytics data
    final now = DateTime.now();
    final monthlyStreams = <String, int>{};
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';
      monthlyStreams[monthKey] = (1000 + (i * 200) + (DateTime.now().millisecond % 500));
    }

    return ArtistAnalytics(
      artistId: artistId,
      totalFollowers: 1247,
      totalStreams: 15672,
      totalEarnings: 234500.0,
      monthlyStreams: monthlyStreams,
      topTracks: [
        TrackAnalytics(
          trackId: 'track_001',
          totalStreams: 5420,
          totalPurchases: 89,
          totalEarnings: 89000.0,
          dailyStats: _generateDailyStats(30),
          countryStreams: {
            'Uganda': 3200,
            'Kenya': 1100,
            'Tanzania': 800,
            'Rwanda': 320,
          },
          ageGroupStreams: {
            '18-25': 2800,
            '26-35': 1900,
            '36-45': 520,
            '46+': 200,
          },
        ),
        TrackAnalytics(
          trackId: 'track_002',
          totalStreams: 3890,
          totalPurchases: 67,
          totalEarnings: 67000.0,
          dailyStats: _generateDailyStats(25),
        ),
        TrackAnalytics(
          trackId: 'track_003',
          totalStreams: 2340,
          totalPurchases: 45,
          totalEarnings: 45000.0,
          dailyStats: _generateDailyStats(20),
        ),
      ],
    );
  }

  Future<TrackAnalytics> getTrackAnalytics(String trackId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    return TrackAnalytics(
      trackId: trackId,
      totalStreams: 5420,
      totalPurchases: 89,
      totalEarnings: 89000.0,
      dailyStats: _generateDailyStats(30),
      countryStreams: {
        'Uganda': 3200,
        'Kenya': 1100,
        'Tanzania': 800,
        'Rwanda': 320,
        'Others': 0,
      },
      ageGroupStreams: {
        '18-25': 2800,
        '26-35': 1900,
        '36-45': 520,
        '46+': 200,
      },
    );
  }

  List<DailyAnalytics> _generateDailyStats(int days) {
    final stats = <DailyAnalytics>[];
    final now = DateTime.now();
    
    for (int i = days; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final baseStreams = 50 + (DateTime.now().millisecond + i) % 100;
      final purchases = (baseStreams * 0.02).round();
      
      stats.add(DailyAnalytics(
        date: date,
        streams: baseStreams,
        purchases: purchases,
        earnings: purchases * 1000.0,
      ));
    }
    
    return stats;
  }

  Future<void> recordStream(String trackId, String userId) async {
    // In real app, this would update backend analytics
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> recordPurchase(String trackId, String userId, double amount) async {
    // In real app, this would update backend analytics
    await Future.delayed(const Duration(milliseconds: 100));
  }
}