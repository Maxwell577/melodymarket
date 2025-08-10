import 'package:flutter/material.dart';
import 'package:melodymarket/models/track.dart';
import 'package:melodymarket/models/payment.dart';
import 'package:melodymarket/services/payment_service.dart';
import 'package:melodymarket/services/analytics_service.dart';
import 'package:melodymarket/services/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';

class TrackDetailScreen extends StatefulWidget {
  final Track track;

  const TrackDetailScreen({Key? key, required this.track}) : super(key: key);

  @override
  _TrackDetailScreenState createState() => _TrackDetailScreenState();
}

class _TrackDetailScreenState extends State<TrackDetailScreen> {
  bool isPreviewPlaying = false;
  bool isPurchased = false;
  bool isLoading = false;
  bool isPreviewLoading = false;
  final _phoneController = TextEditingController();
  final AudioService _audioService = AudioService();
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration(minutes: 1); // Preview is 1 minute max

  @override
  void initState() {
    super.initState();
    _checkPurchaseStatus();
    _setupAudioListeners();
  }

  void _setupAudioListeners() {
    _audioService.onPositionChanged.listen((position) {
      if (mounted && _audioService.currentTrackId == widget.track.id) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    _audioService.onPlayerStateChanged.listen((state) {
      if (mounted && _audioService.currentTrackId == widget.track.id) {
        setState(() {
          isPreviewPlaying = state == PlayerState.playing;
          isPreviewLoading = false;
        });
      }
    });

    _audioService.onDurationChanged.listen((duration) {
      if (mounted && duration != null && _audioService.currentTrackId == widget.track.id) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });
  }

  void _checkPurchaseStatus() {
    // Mock check - in real app, check if user has purchased this track
    setState(() {
      isPurchased = false; // Mock: user hasn't purchased
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.share, color: Colors.white),
            ),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              child: Stack(
                children: [
                  // Background Image
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: widget.track.coverImageUrl != null
                        ? Image.network(
                            widget.track.coverImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.music_note,
                                  size: 100,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.music_note,
                              size: 100,
                              color: Colors.grey[600],
                            ),
                          ),
                  ),
                  
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                  
                  // Content
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.track.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'by ${widget.track.artist}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.play_circle_fill, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '${widget.track.streamCount} plays',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 16),
                            Icon(Icons.access_time, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              widget.track.duration,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Section
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Genre and Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTag(widget.track.genre, isPrimary: true),
                      ...widget.track.tags.map((tag) => _buildTag(tag)),
                    ],
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Preview Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.headphones, color: Theme.of(context).primaryColor),
                            SizedBox(width: 8),
                            Text(
                              '1-Minute Preview',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: widget.track.previewUrl != null ? _togglePreview : null,
                                    icon: isPreviewLoading
                                        ? SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : Icon(
                                            isPreviewPlaying ? Icons.pause : Icons.play_arrow,
                                            color: Colors.white,
                                          ),
                                    label: Text(
                                      isPreviewLoading
                                          ? 'Loading...'
                                          : isPreviewPlaying
                                              ? 'Pause Preview'
                                              : widget.track.previewUrl != null
                                                  ? 'Play Preview'
                                                  : 'Preview Not Available',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: widget.track.previewUrl != null
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey,
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (isPreviewPlaying || _currentPosition.inSeconds > 0) ...[
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    _formatDuration(_currentPosition),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Expanded(
                                    child: Slider(
                                      value: _totalDuration.inSeconds > 0
                                          ? _currentPosition.inSeconds / _totalDuration.inSeconds
                                          : 0.0,
                                      onChanged: (value) {
                                        final position = Duration(
                                          seconds: (value * _totalDuration.inSeconds).round(),
                                        );
                                        _audioService.seek(position);
                                      },
                                      activeColor: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Text(
                                    _formatDuration(_totalDuration),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Purchase Section
                  if (!isPurchased) ...[
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.track.isFree ? 'Get This Track Free!' : 'Purchase This Track',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          if (!widget.track.isFree) ...[
                            Text(
                              'Price: UGX ${widget.track.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            TextField(
                              controller: _phoneController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'MTN Mobile Money Number',
                                labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                                hintText: '+256XXXXXXXXX',
                                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(Icons.phone, color: Colors.white.withValues(alpha: 0.8)),
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _purchaseTrack,
                                  child: isLoading
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text('Processing...'),
                                          ],
                                        )
                                      : Text(
                                          widget.track.isFree ? 'Get Free Track' : 'Purchase with MTN MoMo',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Theme.of(context).primaryColor,
                                    padding: EdgeInsets.symmetric(vertical: 16),
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
                  ] else ...[
                    // Already Purchased
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 32),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Track Purchased!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                                Text(
                                  'You can now stream and download this track',
                                  style: TextStyle(
                                    color: Colors.green[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  SizedBox(height: 24),
                  
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        icon: Icons.play_circle_outline,
                        label: 'Streams',
                        value: '${widget.track.streamCount}',
                      ),
                      _buildStatItem(
                        icon: Icons.shopping_cart_outlined,
                        label: 'Purchases',
                        value: '${widget.track.purchaseCount}',
                      ),
                      _buildStatItem(
                        icon: Icons.favorite_border,
                        label: 'Genre',
                        value: widget.track.genre,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String tag, {bool isPrimary = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPrimary ? Theme.of(context).primaryColor : Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: isPrimary ? Colors.white : Colors.black87,
          fontSize: 12,
          fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).primaryColor),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _togglePreview() async {
    if (widget.track.previewUrl == null) return;
    
    try {
      if (isPreviewPlaying) {
        await _audioService.pause();
      } else {
        setState(() {
          isPreviewLoading = true;
        });
        
        if (_audioService.currentTrackId == widget.track.id && !_audioService.isPreviewMode) {
          await _audioService.resume();
        } else {
          await _audioService.playPreview(widget.track.id, widget.track.previewUrl!);
        }
        
        // Record stream analytics
        AnalyticsService().recordStream(widget.track.id, 'current_user_id');
      }
    } catch (e) {
      setState(() {
        isPreviewLoading = false;
        isPreviewPlaying = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error playing preview: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _purchaseTrack() async {
    if (!widget.track.isFree && _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your MTN Mobile Money number')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (widget.track.isFree) {
        // Free track - just mark as purchased
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          isPurchased = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Track added to your library!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Paid track - process payment
        final payment = await PaymentService().initiateMTNMobileMoneyPayment(
          userId: 'current_user_id',
          trackId: widget.track.id,
          amount: widget.track.price,
          phoneNumber: _phoneController.text,
        );

        if (payment.status == PaymentStatus.completed) {
          setState(() {
            isPurchased = true;
          });
          
          // Record purchase analytics
          await AnalyticsService().recordPurchase(
            widget.track.id,
            'current_user_id',
            widget.track.price,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Purchase successful! Track added to your library.'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    // Stop audio if this track is currently playing
    if (_audioService.currentTrackId == widget.track.id) {
      _audioService.stop();
    }
    super.dispose();
  }
}