import 'package:flutter/material.dart';
import 'package:melodymarket/models/track.dart';
import 'package:melodymarket/services/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';

class TrackCard extends StatefulWidget {
  final Track track;
  final VoidCallback onTap;
  final bool showPlayButton;

  const TrackCard({
    Key? key,
    required this.track,
    required this.onTap,
    this.showPlayButton = true,
  }) : super(key: key);

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  final AudioService _audioService = AudioService();
  bool _isCurrentlyPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _audioService.onPlayerStateChanged.listen((state) {
      if (mounted && _audioService.currentTrackId == widget.track.id) {
        setState(() {
          _isCurrentlyPlaying = state == PlayerState.playing;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _isCurrentlyPlaying = false;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Cover Image
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
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.music_note,
                          size: 40,
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
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              
              // Content
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.track.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      widget.track.artist,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.track.isFree ? 'FREE' : 'UGX ${widget.track.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: widget.track.isFree ? Colors.green : Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.track.streamCount} plays',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Play Button
              if (widget.showPlayButton)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _togglePreview,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: _isLoading
                          ? Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : Icon(
                              _isCurrentlyPlaying ? Icons.pause : Icons.play_arrow,
                              color: widget.track.previewUrl != null
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                              size: 18,
                            ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePreview() async {
    if (widget.track.previewUrl == null) return;
    
    try {
      if (_isCurrentlyPlaying) {
        await _audioService.pause();
      } else {
        setState(() {
          _isLoading = true;
        });
        await _audioService.playPreview(widget.track.id, widget.track.previewUrl!);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isCurrentlyPlaying = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error playing preview'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class TrackListTile extends StatefulWidget {
  final Track track;
  final VoidCallback onTap;
  final bool showPrice;

  const TrackListTile({
    Key? key,
    required this.track,
    required this.onTap,
    this.showPrice = true,
  }) : super(key: key);

  @override
  State<TrackListTile> createState() => _TrackListTileState();
}

class _TrackListTileState extends State<TrackListTile> {
  final AudioService _audioService = AudioService();
  bool _isCurrentlyPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _audioService.onPlayerStateChanged.listen((state) {
      if (mounted && _audioService.currentTrackId == widget.track.id) {
        setState(() {
          _isCurrentlyPlaying = state == PlayerState.playing;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _isCurrentlyPlaying = false;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300],
          ),
          child: widget.track.coverImageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.track.coverImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.music_note,
                        color: Colors.grey[600],
                      );
                    },
                  ),
                )
              : Icon(
                  Icons.music_note,
                  color: Colors.grey[600],
                ),
        ),
        title: Text(
          widget.track.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.track.artist,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Text(
                  widget.track.duration,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '• ${widget.track.streamCount} plays',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.showPrice)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.track.isFree ? Colors.green : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.track.isFree ? 'FREE' : 'UGX ${widget.track.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(height: 4),
            GestureDetector(
              onTap: _togglePreview,
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : Icon(
                      _isCurrentlyPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                      color: widget.track.previewUrl != null
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      size: 24,
                    ),
            ),
          ],
        ),
        onTap: widget.onTap,
      ),
    );
  }

  void _togglePreview() async {
    if (widget.track.previewUrl == null) return;
    
    try {
      if (_isCurrentlyPlaying) {
        await _audioService.pause();
      } else {
        setState(() {
          _isLoading = true;
        });
        await _audioService.playPreview(widget.track.id, widget.track.previewUrl!);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isCurrentlyPlaying = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error playing preview'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}