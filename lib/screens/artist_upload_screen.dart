import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:melodymarket/services/storage_service.dart';
import 'package:melodymarket/models/album.dart';
import 'package:melodymarket/models/track.dart';
import 'package:melodymarket/models/user.dart';

class ArtistUploadScreen extends StatefulWidget {
  const ArtistUploadScreen({super.key});

  @override
  State<ArtistUploadScreen> createState() => _ArtistUploadScreenState();
}

class _ArtistUploadScreenState extends State<ArtistUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _genreController = TextEditingController();
  
  User? _currentUser;
  String? _selectedImageUrl;
  String _selectedGenre = 'Pop';
  List<Track> _tracks = [];
  
  final List<String> _genres = [
    'Pop', 'Rock', 'Jazz', 'Electronic', 'Hip Hop', 'R&B', 'Country', 
    'Classical', 'Blues', 'Folk', 'Reggae', 'EDM', 'Acoustic'
  ];

  final List<String> _sampleImages = [
    'https://pixabay.com/get/gb223fd4f7b017d2ccaafa9d8905ee83ec85ccfc09c554239fa23c70d96abfa494a203ce5640fd59147fb96e648b3ecf9357a01279b142616e36b6a6d436ccaf5_1280.jpg',
    'https://pixabay.com/get/gc23f1bfbe4bf6bea30c0867ea843240fc00f7fe7ae1a8c3f79c23ed0e2dc02f408252402460bd52ad8a390c738085554f3482be5b29976d27ba94c78eba42188_1280.jpg',
    'https://pixabay.com/get/g52d4139eca0c4b144d782cb998bd0ebb012cee6fb2fd3c86f1c735842fa13b5a6d12aa1a57a51c7142f8b2ea4a09d414f118a177b96f94a245f3d157c9b2f881_1280.jpg',
    'https://pixabay.com/get/g3cfc22cfb32693f7974e9ef4372153aacbfc04e40b29c624ad5d79d2212ab4be9490bbb4a4ce3b9a034c78239b53d29e2e5e2986439b518c2a842f433f2956eb_1280.jpg',
    'https://pixabay.com/get/gb53028d3c8dfc73984bfb28fd81a84024572523e308bb33929066e7d46dd0f912f51160d76c2cf230cd0289d43d1fc449902ffee4871bb47112c611bce19c1b1_1280.jpg',
    'https://pixabay.com/get/ga9359d6585aa0c61393a035ee4ca1258ebe40f3646dfc71682308a667fc76eac25bc981b77c6f9f347388db82cd92dffa8df590ee6162d6f068f21e451b4ecb2_1280.jpg',
    'https://pixabay.com/get/g0f4cebba13c92940a112ec5a1152e25860d231994355ffc6b53cc95c80fa759499df065918c8c2242b4be699e2b928ae561c4732be50098b10351e5aec9de56c_1280.jpg',
    'https://pixabay.com/get/gb0417116fecf002f737657f4879d6382d2812a83c3ca3e17c477b1b02fa9b1cff29751ddcb7412f4daa3c4bd6f4e2c3daa9427f90c15b38927776ee46e28af1e_1280.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _selectedImageUrl = _sampleImages.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    final user = await StorageService.getCurrentUser();
    setState(() => _currentUser = user);
  }

  void _addTrack() {
    showDialog(
      context: context,
      builder: (context) => _TrackDialog(
        onSave: (track) {
          setState(() => _tracks.add(track));
        },
        trackNumber: _tracks.length + 1,
        albumId: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
  }

  void _removeTrack(int index) {
    setState(() => _tracks.removeAt(index));
  }

  void _selectCoverImage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Album Cover',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _sampleImages.length,
                itemBuilder: (context, index) {
                  final imageUrl = _sampleImages[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedImageUrl = imageUrl);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedImageUrl == imageUrl
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.image,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadAlbum() async {
    if (!_formKey.currentState!.validate() || _tracks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and add at least one track')),
      );
      return;
    }

    final albumId = DateTime.now().millisecondsSinceEpoch.toString();
    final album = Album(
      id: albumId,
      title: _titleController.text.trim(),
      artistId: _currentUser?.id ?? 'unknown',
      artistName: _currentUser?.name ?? 'Unknown Artist',
      price: double.parse(_priceController.text.trim()),
      coverImageUrl: _selectedImageUrl!,
      tracks: _tracks.map((track) => Track(
        id: track.id,
        title: track.title,
        artist: _currentUser?.name ?? 'Unknown Artist',
        artistId: _currentUser?.id ?? 'unknown',
        duration: track.duration,
        albumId: albumId,
        trackNumber: track.trackNumber,
        genre: _selectedGenre,
        createdAt: DateTime.now(),
      )).toList(),
      createdAt: DateTime.now(),
      genre: _selectedGenre,
      description: _descriptionController.text.trim(),
    );

    await StorageService.saveAlbum(album);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Album "${album.title}" uploaded successfully!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Clear form
      _titleController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() {
        _tracks.clear();
        _selectedImageUrl = _sampleImages.first;
        _selectedGenre = 'Pop';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.close_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            actions: [
              TextButton(
                onPressed: _uploadAlbum,
                child: Text(
                  'Publish',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Album 🎤',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Share your creativity with the world',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress Indicator
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Fill in the details below to create your album. All fields marked with * are required.',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Album Cover
                    Text(
                      'Album Cover *',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _selectCoverImage,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedImageUrl != null 
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                                width: _selectedImageUrl != null ? 2 : 1,
                              ),
                            ),
                            child: _selectedImageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: Image.network(
                                      _selectedImageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: Theme.of(context).colorScheme.primaryContainer,
                                        child: Icon(
                                          Icons.add_photo_alternate_rounded,
                                          size: 40,
                                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.add_photo_alternate_rounded,
                                    size: 40,
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Choose a cover image',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Select an eye-catching image that represents your album. This will be the first thing listeners see.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: _selectCoverImage,
                                icon: const Icon(Icons.image_rounded, size: 18),
                                label: Text(_selectedImageUrl != null ? 'Change Image' : 'Select Image'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Theme.of(context).colorScheme.primary,
                                  side: BorderSide(color: Theme.of(context).colorScheme.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Album Title
                    Text(
                      'Album Title *',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Enter album title',
                        prefixIcon: const Icon(Icons.album_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                      validator: (value) => value?.isEmpty == true ? 'Title is required' : null,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Genre
                    Text(
                      'Genre *',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedGenre,
                      onChanged: (value) => setState(() => _selectedGenre = value!),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.category_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                      items: _genres.map((genre) => DropdownMenuItem(
                        value: genre,
                        child: Text(genre),
                      )).toList(),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Price
                    Text(
                      'Price (USD) *',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: '9.99',
                        prefixText: '\$',
                        prefixIcon: const Icon(Icons.attach_money_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Price is required';
                        if (double.tryParse(value!) == null) return 'Invalid price';
                        if (double.parse(value) < 0) return 'Price cannot be negative';
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Description
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Describe your album...',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 40),
                          child: Icon(Icons.description_rounded),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Tracks Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tracks (${_tracks.length}) *',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _addTrack,
                          icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
                          label: Text(
                            'Add Track',
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    if (_tracks.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.music_note_outlined,
                              size: 48,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No tracks added yet',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Add at least one track to create your album',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _tracks.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final track = _tracks[index];
                          return Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                child: Text(
                                  '${track.trackNumber}',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                track.title,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                'Duration: ${track.duration}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () => _removeTrack(index),
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    
                    const SizedBox(height: 32),
                    
                    // Upload Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _uploadAlbum,
                        icon: Icon(
                          Icons.cloud_upload_rounded,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        label: Text(
                          'Publish Album',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Terms and conditions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 16,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Publishing Guidelines',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '• Ensure you own all rights to the music you upload\n'
                            '• Albums will be reviewed before going live\n'
                            '• You can edit pricing and details after publishing\n'
                            '• Earnings are available for withdrawal after 24 hours',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackDialog extends StatefulWidget {
  final Function(Track) onSave;
  final int trackNumber;
  final String albumId;

  const _TrackDialog({
    required this.onSave,
    required this.trackNumber,
    required this.albumId,
  });

  @override
  State<_TrackDialog> createState() => _TrackDialogState();
}

class _TrackDialogState extends State<_TrackDialog> {
  final _titleController = TextEditingController();
  final _durationController = TextEditingController(text: '3:30');

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Add Track ${widget.trackNumber}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Track Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _durationController,
            decoration: const InputDecoration(
              labelText: 'Duration (mm:ss)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.trim().isNotEmpty) {
              final track = Track(
                id: 'track_${DateTime.now().millisecondsSinceEpoch}',
                title: _titleController.text.trim(),
                artist: 'Unknown Artist', // This would come from user session
                artistId: 'unknown',
                duration: _durationController.text.trim(),
                albumId: widget.albumId,
                trackNumber: widget.trackNumber,
                genre: 'Unknown',
                createdAt: DateTime.now(),
              );
              widget.onSave(track);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}