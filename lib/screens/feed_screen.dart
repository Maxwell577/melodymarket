import 'package:flutter/material.dart';
import 'package:melodymarket/models/track.dart';
import 'package:melodymarket/models/user.dart';
import 'package:melodymarket/widgets/track_card.dart';
import 'package:melodymarket/widgets/artist_card.dart';
import 'package:melodymarket/screens/track_detail_screen.dart';
import 'package:melodymarket/screens/artist_profile_screen.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String selectedGenre = 'All';
  final genres = ['All', 'Afrobeats', 'Hip Hop', 'R&B', 'Pop', 'Dancehall', 'Gospel'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Discover Music',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // TODO: Implement search
                },
              ),
            ],
          ),
          
          // Genre Filter
          SliverToBoxAdapter(
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: genres.length,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final genre = genres[index];
                  final isSelected = selectedGenre == genre;
                  
                  return Container(
                    margin: EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(genre),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedGenre = genre;
                        });
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Trending Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Trending Now',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _getTrendingTracks().length,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final track = _getTrendingTracks()[index];
                  return Container(
                    width: 160,
                    margin: EdgeInsets.only(right: 16),
                    child: TrackCard(
                      track: track,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrackDetailScreen(track: track),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Top Artists Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Top Artists',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _getTopArtists().length,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final artist = _getTopArtists()[index];
                  return Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 16),
                    child: ArtistCard(
                      artist: artist,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArtistProfileScreen(artist: artist),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Latest Releases
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Latest Releases',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final track = _getLatestTracks()[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TrackListTile(
                    track: track,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackDetailScreen(track: track),
                        ),
                      );
                    },
                  ),
                );
              },
              childCount: _getLatestTracks().length,
            ),
          ),
        ],
      ),
    );
  }

  List<Track> _getTrendingTracks() {
    return [
      Track(
        id: 'track_trending_1',
        title: 'Sunset Vibes',
        artist: 'Kenzo Williams',
        artistId: 'artist_1',
        duration: '3:45',
        price: 2000,
        isFree: false,
        streamCount: 15420,
        genre: 'Afrobeats',
        coverImageUrl: 'https://picsum.photos/300/300?random=1',
        previewUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        tags: ['trending', 'afrobeats', 'dance'],
      ),
      Track(
        id: 'track_trending_2',
        title: 'City Lights',
        artist: 'Sarah Melody',
        artistId: 'artist_2',
        duration: '4:12',
        price: 1500,
        isFree: false,
        streamCount: 12890,
        genre: 'R&B',
        coverImageUrl: 'https://picsum.photos/300/300?random=2',
        previewUrl: 'https://www.soundjay.com/misc/sounds/magic-chime-02.wav',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        tags: ['trending', 'r&b', 'smooth'],
      ),
      Track(
        id: 'track_trending_3',
        title: 'Mountain High',
        artist: 'Echo Sounds',
        artistId: 'artist_3',
        duration: '3:28',
        price: 0,
        isFree: true,
        streamCount: 8756,
        genre: 'Pop',
        coverImageUrl: 'https://picsum.photos/300/300?random=3',
        previewUrl: 'https://www.soundjay.com/misc/sounds/clock-chimes-01.wav',
        createdAt: DateTime.now().subtract(Duration(days: 3)),
        tags: ['free', 'pop', 'uplifting'],
      ),
    ];
  }

  List<User> _getTopArtists() {
    return [
      User(
        id: 'artist_1',
        name: 'Kenzo Williams',
        email: 'kenzo@example.com',
        isArtist: true,
        profileImage: 'https://picsum.photos/200/200?random=10',
        followers: ['user1', 'user2', 'user3'],
        bio: 'Afrobeats sensation from Kampala',
      ),
      User(
        id: 'artist_2',
        name: 'Sarah Melody',
        email: 'sarah@example.com',
        isArtist: true,
        profileImage: 'https://picsum.photos/200/200?random=11',
        followers: ['user1', 'user4', 'user5'],
        bio: 'R&B and Soul artist',
      ),
      User(
        id: 'artist_3',
        name: 'Echo Sounds',
        email: 'echo@example.com',
        isArtist: true,
        profileImage: 'https://picsum.photos/200/200?random=12',
        followers: ['user2', 'user3', 'user6'],
        bio: 'Pop music producer and artist',
      ),
    ];
  }

  List<Track> _getLatestTracks() {
    return [
      Track(
        id: 'track_latest_1',
        title: 'New Day Rising',
        artist: 'Fresh Beats',
        artistId: 'artist_4',
        duration: '3:55',
        price: 2500,
        isFree: false,
        streamCount: 1240,
        genre: 'Hip Hop',
        coverImageUrl: 'https://picsum.photos/300/300?random=4',
        previewUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
        createdAt: DateTime.now().subtract(Duration(hours: 12)),
        tags: ['new', 'hip-hop', 'energy'],
      ),
      Track(
        id: 'track_latest_2',
        title: 'Peaceful Mind',
        artist: 'Calm Waters',
        artistId: 'artist_5',
        duration: '4:30',
        price: 0,
        isFree: true,
        streamCount: 890,
        genre: 'Gospel',
        coverImageUrl: 'https://picsum.photos/300/300?random=5',
        previewUrl: 'https://www.soundjay.com/misc/sounds/magic-chime-02.wav',
        createdAt: DateTime.now().subtract(Duration(hours: 6)),
        tags: ['free', 'gospel', 'peaceful'],
      ),
      Track(
        id: 'track_latest_3',
        title: 'Dance Floor Heat',
        artist: 'DJ Rhythm',
        artistId: 'artist_6',
        duration: '3:20',
        price: 1800,
        isFree: false,
        streamCount: 2340,
        genre: 'Dancehall',
        coverImageUrl: 'https://picsum.photos/300/300?random=6',
        previewUrl: 'https://www.soundjay.com/misc/sounds/clock-chimes-01.wav',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        tags: ['new', 'dancehall', 'party'],
      ),
    ];
  }
}