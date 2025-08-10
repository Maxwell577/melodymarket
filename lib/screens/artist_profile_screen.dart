import 'package:flutter/material.dart';
import 'package:melodymarket/models/user.dart';
import 'package:melodymarket/models/track.dart';
import 'package:melodymarket/widgets/track_card.dart';
import 'package:melodymarket/screens/track_detail_screen.dart';

class ArtistProfileScreen extends StatefulWidget {
  final User artist;

  const ArtistProfileScreen({Key? key, required this.artist}) : super(key: key);

  @override
  _ArtistProfileScreenState createState() => _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends State<ArtistProfileScreen> {
  bool isFollowing = false;
  List<Track> artistTracks = [];

  @override
  void initState() {
    super.initState();
    _loadArtistTracks();
    _checkFollowStatus();
  }

  void _loadArtistTracks() {
    // Mock artist tracks - in real app, fetch from backend
    setState(() {
      artistTracks = [
        Track(
          id: 'track_artist_1',
          title: 'Sunset Vibes',
          artist: widget.artist.name,
          artistId: widget.artist.id,
          duration: '3:45',
          price: 2000,
          isFree: false,
          streamCount: 15420,
          genre: 'Afrobeats',
          coverImageUrl: 'https://picsum.photos/300/300?random=21',
          previewUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          tags: ['trending', 'afrobeats', 'dance'],
        ),
        Track(
          id: 'track_artist_2',
          title: 'City Lights',
          artist: widget.artist.name,
          artistId: widget.artist.id,
          duration: '4:12',
          price: 1500,
          isFree: false,
          streamCount: 12890,
          genre: 'R&B',
          coverImageUrl: 'https://picsum.photos/300/300?random=22',
          previewUrl: 'https://www.soundjay.com/misc/sounds/magic-chime-02.wav',
          createdAt: DateTime.now().subtract(Duration(days: 5)),
          tags: ['chill', 'r&b', 'smooth'],
        ),
        Track(
          id: 'track_artist_3',
          title: 'Dance All Night',
          artist: widget.artist.name,
          artistId: widget.artist.id,
          duration: '3:28',
          price: 0,
          isFree: true,
          streamCount: 8756,
          genre: 'Dancehall',
          coverImageUrl: 'https://picsum.photos/300/300?random=23',
          previewUrl: 'https://www.soundjay.com/misc/sounds/clock-chimes-01.wav',
          createdAt: DateTime.now().subtract(Duration(days: 10)),
          tags: ['free', 'dancehall', 'party'],
        ),
      ];
    });
  }

  void _checkFollowStatus() {
    // Mock follow status - in real app, check if current user follows this artist
    setState(() {
      isFollowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Artist Header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image/Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  
                  // Artist Info
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Image
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: widget.artist.profileImage != null
                                ? Image.network(
                                    widget.artist.profileImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.grey[600],
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Artist Name
                        Text(
                          widget.artist.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        
                        // Stats
                        Text(
                          '${widget.artist.followers.length} followers • ${artistTracks.length} tracks',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bio and Follow Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Follow Button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _toggleFollow,
                          icon: Icon(
                            isFollowing ? Icons.check : Icons.person_add,
                            color: isFollowing ? Colors.white : Theme.of(context).primaryColor,
                          ),
                          label: Text(
                            isFollowing ? 'Following' : 'Follow',
                            style: TextStyle(
                              color: isFollowing ? Colors.white : Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFollowing 
                                ? Theme.of(context).primaryColor 
                                : Colors.white,
                            side: BorderSide(color: Theme.of(context).primaryColor),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      IconButton(
                        onPressed: () {
                          // TODO: Share artist profile
                        },
                        icon: Icon(Icons.share),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          padding: EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Bio
                  if (widget.artist.bio != null) ...[
                    Text(
                      'About',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.artist.bio!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                  
                  // Popular Tracks
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Tracks',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Show all tracks
                        },
                        child: Text('See All'),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
          
          // Track Grid
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final track = artistTracks[index];
                  return TrackCard(
                    track: track,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackDetailScreen(track: track),
                        ),
                      );
                    },
                  );
                },
                childCount: artistTracks.length,
              ),
            ),
          ),
          
          // Latest Releases Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Latest Releases',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
          
          // Track List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final track = artistTracks[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
              childCount: artistTracks.length,
            ),
          ),
          
          // Bottom Padding
          SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  void _toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFollowing 
              ? 'You are now following ${widget.artist.name}' 
              : 'Unfollowed ${widget.artist.name}',
        ),
        duration: Duration(seconds: 2),
        backgroundColor: isFollowing ? Colors.green : Colors.grey[600],
      ),
    );
  }
}