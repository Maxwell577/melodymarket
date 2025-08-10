import 'package:flutter/material.dart';
import 'package:melodymarket/models/analytics.dart';
import 'package:melodymarket/services/analytics_service.dart';
import 'package:melodymarket/services/payment_service.dart';
import 'package:melodymarket/screens/upload_track_screen.dart';
import 'package:melodymarket/screens/withdrawal_screen.dart';

class ArtistDashboardScreen extends StatefulWidget {
  @override
  _ArtistDashboardScreenState createState() => _ArtistDashboardScreenState();
}

class _ArtistDashboardScreenState extends State<ArtistDashboardScreen> {
  ArtistAnalytics? analytics;
  bool isLoading = true;
  final String artistId = 'current_artist_id'; // Mock artist ID
  final double artistBalance = 234500.0; // Mock balance

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  void _loadAnalytics() async {
    try {
      final data = await AnalyticsService().getArtistAnalytics(artistId);
      setState(() {
        analytics = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Artist Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UploadTrackScreen(),
                ),
              ).then((_) => _loadAnalytics()); // Refresh after upload
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  isLoading = true;
                });
                _loadAnalytics();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Balance',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'UGX ${artistBalance.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WithdrawalScreen(
                                          availableBalance: artistBalance,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.account_balance_wallet, color: Theme.of(context).primaryColor),
                                  label: Text(
                                    'Withdraw',
                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Quick Stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'Total Streams',
                            value: analytics?.totalStreams.toString() ?? '0',
                            icon: Icons.play_circle_outline,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Followers',
                            value: analytics?.totalFollowers.toString() ?? '0',
                            icon: Icons.people_outline,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'Total Earnings',
                            value: 'UGX ${analytics?.totalEarnings.toStringAsFixed(0) ?? '0'}',
                            icon: Icons.monetization_on_outlined,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Active Tracks',
                            value: analytics?.topTracks.length.toString() ?? '0',
                            icon: Icons.library_music_outlined,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Monthly Performance Chart
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Streams',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 200,
                            child: _buildStreamChart(),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Top Performing Tracks
                    Text(
                      'Top Performing Tracks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    
                    if (analytics?.topTracks.isNotEmpty == true)
                      ...analytics!.topTracks.take(5).map((trackAnalytics) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              child: Icon(
                                Icons.music_note,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            title: Text(
                              'Track ${trackAnalytics.trackId.split('_').last}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${trackAnalytics.totalStreams} streams'),
                                Text('UGX ${trackAnalytics.totalEarnings.toStringAsFixed(0)} earned'),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.trending_up, color: Colors.green),
                                Text(
                                  '${trackAnalytics.totalPurchases}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    
                    SizedBox(height: 24),
                    
                    // Quick Actions
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _buildActionCard(
                          title: 'Upload Track',
                          subtitle: 'Add new music',
                          icon: Icons.upload,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadTrackScreen(),
                              ),
                            ).then((_) => _loadAnalytics());
                          },
                        ),
                        _buildActionCard(
                          title: 'View Analytics',
                          subtitle: 'Detailed insights',
                          icon: Icons.analytics,
                          onTap: () {
                            // TODO: Navigate to detailed analytics
                          },
                        ),
                        _buildActionCard(
                          title: 'Promote Track',
                          subtitle: 'Boost visibility',
                          icon: Icons.campaign,
                          onTap: () {
                            // TODO: Navigate to promotion tools
                          },
                        ),
                        _buildActionCard(
                          title: 'Edit Profile',
                          subtitle: 'Update info',
                          icon: Icons.edit,
                          onTap: () {
                            // TODO: Navigate to profile edit
                          },
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 100), // Bottom padding for navigation
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamChart() {
    if (analytics?.monthlyStreams.isEmpty == true) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    final monthlyStreams = analytics!.monthlyStreams;
    final maxStreams = monthlyStreams.values.reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: monthlyStreams.entries.map((entry) {
        final height = (entry.value / maxStreams) * 150;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${entry.value}',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Container(
              width: 30,
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 8),
            Text(
              entry.key.split('-')[1],
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 32,
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}