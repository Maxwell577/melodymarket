import 'package:flutter/material.dart';
import 'package:melodymarket/models/track.dart';

class UploadTrackScreen extends StatefulWidget {
  @override
  _UploadTrackScreenState createState() => _UploadTrackScreenState();
}

class _UploadTrackScreenState extends State<UploadTrackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  
  String selectedGenre = 'Afrobeats';
  bool isFree = false;
  bool isUploading = false;
  String? selectedAudioFile;
  String? selectedCoverImage;
  List<String> tags = [];
  final _tagController = TextEditingController();

  final genres = [
    'Afrobeats',
    'Hip Hop',
    'R&B',
    'Pop',
    'Dancehall',
    'Gospel',
    'Jazz',
    'Reggae',
    'Electronic',
    'Country',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Track'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 64,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Upload Your Track',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Supported formats: MP3, WAV, FLAC (Max 50MB)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _selectAudioFile,
                      icon: Icon(Icons.audio_file),
                      label: Text(selectedAudioFile ?? 'Choose Audio File'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              // Cover Image Section
              Text(
                'Cover Image',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: _selectCoverImage,
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: selectedCoverImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            selectedCoverImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 32,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Add Cover Image',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Track Details
              Text(
                'Track Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Track Title',
                  hintText: 'Enter track title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.music_note),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a track title';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duration',
                  hintText: 'e.g., 3:45',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the track duration';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Genre Dropdown
              DropdownButtonFormField<String>(
                value: selectedGenre,
                decoration: InputDecoration(
                  labelText: 'Genre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.category),
                ),
                items: genres.map((genre) {
                  return DropdownMenuItem(
                    value: genre,
                    child: Text(genre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGenre = value!;
                  });
                },
              ),
              
              SizedBox(height: 24),
              
              // Pricing Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pricing',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Checkbox(
                          value: isFree,
                          onChanged: (value) {
                            setState(() {
                              isFree = value!;
                              if (isFree) {
                                _priceController.clear();
                              }
                            });
                          },
                        ),
                        Text('Make this track free'),
                      ],
                    ),
                    
                    if (!isFree) ...[
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Price (UGX)',
                          hintText: 'Enter price in Ugandan Shillings',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(Icons.monetization_on),
                        ),
                        validator: (value) {
                          if (!isFree && (value == null || value.isEmpty)) {
                            return 'Please enter a price or make the track free';
                          }
                          if (!isFree && double.tryParse(value!) == null) {
                            return 'Please enter a valid price';
                          }
                          return null;
                        },
                      ),
                    ],
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              // Tags Section
              Text(
                'Tags',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Add tags to help listeners discover your music',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        hintText: 'Add a tag',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onFieldSubmitted: _addTag,
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _addTag(_tagController.text),
                    icon: Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              if (tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () {
                        setState(() {
                          tags.remove(tag);
                        });
                      },
                      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    );
                  }).toList(),
                ),
              
              SizedBox(height: 32),
              
              // Upload Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isUploading ? null : _uploadTrack,
                  child: isUploading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Uploading...'),
                          ],
                        )
                      : Text(
                          'Upload Track',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _selectAudioFile() {
    // Mock file selection - in real app, use file_picker package
    setState(() {
      selectedAudioFile = 'awesome_track.mp3';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Audio file selected: awesome_track.mp3')),
    );
  }

  void _selectCoverImage() {
    // Mock image selection - in real app, use image_picker package
    setState(() {
      selectedCoverImage = 'cover_image.jpg'; // This would be the actual file path
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cover image selected')),
    );
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !tags.contains(tag.toLowerCase())) {
      setState(() {
        tags.add(tag.toLowerCase());
        _tagController.clear();
      });
    }
  }

  void _uploadTrack() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedAudioFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an audio file'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      // Mock upload process
      await Future.delayed(Duration(seconds: 3));
      
      // Create mock track
      final track = Track(
        id: 'track_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text,
        artist: 'Current Artist', // Would get from user session
        artistId: 'current_artist_id',
        duration: _durationController.text,
        price: isFree ? 0.0 : double.parse(_priceController.text),
        isFree: isFree,
        genre: selectedGenre,
        createdAt: DateTime.now(),
        tags: tags,
        coverImageUrl: selectedCoverImage != null ? 'https://picsum.photos/300/300?random=${DateTime.now().millisecond}' : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Track uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back after successful upload
      Navigator.pop(context, track);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _tagController.dispose();
    super.dispose();
  }
}