import 'package:flutter/material.dart';
import 'package:melodymarket/services/storage_service.dart';
import 'package:melodymarket/models/album.dart';
import 'package:melodymarket/models/user.dart';
import 'package:melodymarket/widgets/bottom_nav_bar.dart';
import 'package:melodymarket/widgets/album_card.dart';
import 'package:melodymarket/screens/library_screen.dart';
import 'package:melodymarket/screens/artist_upload_screen.dart';
import 'package:melodymarket/screens/profile_screen.dart';
import 'package:melodymarket/screens/album_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Album> _albums = [];
  User? _currentUser;
  bool _isLoading = true;
  String _selectedGenre = 'All';

  final List<String> _genres = ['All', 'Electronic', 'Acoustic', 'EDM', 'Jazz', 'Rock'];

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await StorageService.init();
    await _loadData();
    setState(() => _isLoading = false);
  }

  Future<void> _loadData() async {
    final albums = await StorageService.getAlbums();
    final user = await StorageService.getCurrentUser();
    
    if (user == null) {
      await StorageService.setCurrentUser('Music Lover', 'user@example.com');
      final newUser = await StorageService.getCurrentUser();
      setState(() {
        _currentUser = newUser;
        _albums = albums;
      });
    } else {
      setState(() {
        _currentUser = user;
        _albums = albums;
      });
    }
  }

  List<Album> get _filteredAlbums {
    if (_selectedGenre == 'All') return _albums;
    return _albums.where((album) => album.genre == _selectedGenre).toList();
  }

  Widget _buildDiscoverScreen() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover Music 🎵',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                'Find your next favorite album',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Genres',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _genres.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final genre = _genres[index];
                      final isSelected = _selectedGenre == genre;
                      return FilterChip(
                        label: Text(
                          genre,
                          style: TextStyle(
                            color: isSelected 
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedGenre = genre);
                        },
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        selectedColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected 
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final album = _filteredAlbums[index];
                return AlbumCard(
                  album: album,
                  isPurchased: _currentUser?.purchasedAlbums.contains(album.id) ?? false,
                  isDownloaded: _currentUser?.downloadedAlbums.contains(album.id) ?? false,
                  onTap: () => _navigateToAlbumDetail(album),
                  onPurchase: () => _purchaseAlbum(album),
                );
              },
              childCount: _filteredAlbums.length,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToAlbumDetail(Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlbumDetailScreen(album: album),
      ),
    ).then((_) => _loadData());
  }

  Future<void> _purchaseAlbum(Album album) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase Album'),
        content: Text('Purchase "${album.title}" for ${album.formattedPrice}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text('Purchase'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final purchase = album.toPurchase(_currentUser!.id);
      await StorageService.savePurchase(purchase);
      await _loadData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully purchased "${album.title}"!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildDiscoverScreen(),
            LibraryScreen(),
            ArtistUploadScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}