import 'package:flutter/material.dart';
import 'package:melodymarket/services/storage_service.dart';
import 'package:melodymarket/models/user.dart';
import 'package:melodymarket/models/album.dart';
import 'package:melodymarket/widgets/album_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  List<Album> _userAlbums = [];
  List<Album> _purchasedAlbums = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await StorageService.getCurrentUser();
    final allAlbums = await StorageService.getAlbums();
    final purchasedAlbums = await StorageService.getUserPurchasedAlbums();
    
    setState(() {
      _currentUser = user;
      _userAlbums = allAlbums.where((album) => album.artistId == user?.id).toList();
      _purchasedAlbums = purchasedAlbums;
      _isLoading = false;
    });
  }

  Future<void> _toggleArtistMode() async {
    if (_currentUser != null) {
      final updatedUser = _currentUser!.copyWith(isArtist: !_currentUser!.isArtist);
      await StorageService.saveUser(updatedUser);
      setState(() => _currentUser = updatedUser);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            updatedUser.isArtist 
                ? 'Artist mode enabled! You can now upload music.'
                : 'Artist mode disabled.',
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white.withValues(alpha: 0.2),
                              backgroundImage: _currentUser?.profileImage != null
                                  ? NetworkImage(_currentUser!.profileImage!)
                                  : null,
                              child: _currentUser?.profileImage == null
                                  ? Icon(
                                      Icons.person_rounded,
                                      size: 40,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _currentUser?.name ?? 'User',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _currentUser?.isArtist == true 
                                          ? '🎤 Artist' 
                                          : '🎵 Music Lover',
                                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Purchased',
                          value: '${_purchasedAlbums.length}',
                          icon: Icons.library_music_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Uploaded',
                          value: '${_userAlbums.length}',
                          icon: Icons.cloud_upload_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Settings Section
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            _currentUser?.isArtist == true 
                                ? Icons.mic_rounded
                                : Icons.person_add_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            _currentUser?.isArtist == true 
                                ? 'Disable Artist Mode'
                                : 'Enable Artist Mode',
                          ),
                          subtitle: Text(
                            _currentUser?.isArtist == true 
                                ? 'Switch back to music listener mode'
                                : 'Start uploading and selling your music',
                          ),
                          trailing: Switch(
                            value: _currentUser?.isArtist == true,
                            onChanged: (_) => _toggleArtistMode(),
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                          onTap: _toggleArtistMode,
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.audio_file_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          title: const Text('Audio Quality'),
                          subtitle: const Text('High (320 kbps)'),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Audio quality settings coming soon!'),
                              ),
                            );
                          },
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.download_rounded,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          title: const Text('Auto Download'),
                          subtitle: const Text('Download purchased music automatically'),
                          trailing: Switch(
                            value: true,
                            onChanged: (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Auto download settings coming soon!'),
                                ),
                              );
                            },
                            activeColor: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.notifications_rounded,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          title: const Text('Notifications'),
                          subtitle: const Text('New releases and recommendations'),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Notification settings coming soon!'),
                              ),
                            );
                          },
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.palette_rounded,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          title: const Text('Theme'),
                          subtitle: const Text('System default'),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Theme settings coming soon!'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  if (_userAlbums.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    Text(
                      'My Uploads',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _userAlbums.length,
                      itemBuilder: (context, index) {
                        final album = _userAlbums[index];
                        return AlbumCard(
                          album: album,
                          isPurchased: true,
                          isDownloaded: false,
                          showPurchaseButton: false,
                          onTap: () {
                            // Navigate to album detail or edit
                          },
                        );
                      },
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                  
                  // About Section
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About MelodyMarket',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'A marketplace where artists can share their music and fans can discover and support their favorite musicians.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Version 1.0.0',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}