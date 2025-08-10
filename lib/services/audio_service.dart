import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  String? _currentTrackId;
  bool _isPreviewMode = false;

  bool get isPlaying => _player.state == PlayerState.playing;
  String? get currentTrackId => _currentTrackId;
  bool get isPreviewMode => _isPreviewMode;

  Stream<Duration> get onPositionChanged => _player.onPositionChanged;
  Stream<Duration?> get onDurationChanged => _player.onDurationChanged;
  Stream<PlayerState> get onPlayerStateChanged => _player.onPlayerStateChanged;

  Future<void> playPreview(String trackId, String previewUrl) async {
    try {
      // Stop any current playback
      await stop();
      
      _currentTrackId = trackId;
      _isPreviewMode = true;
      
      await _player.play(UrlSource(previewUrl));
      
      // Auto-stop after 1 minute for preview
      Future.delayed(Duration(minutes: 1), () {
        if (_isPreviewMode && _currentTrackId == trackId) {
          stop();
        }
      });
    } catch (e) {
      print('Error playing preview: $e');
      _resetState();
    }
  }

  Future<void> playFullTrack(String trackId, String trackUrl) async {
    try {
      // Stop any current playback
      await stop();
      
      _currentTrackId = trackId;
      _isPreviewMode = false;
      
      await _player.play(UrlSource(trackUrl));
    } catch (e) {
      print('Error playing track: $e');
      _resetState();
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.resume();
  }

  Future<void> stop() async {
    await _player.stop();
    _resetState();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  void _resetState() {
    _currentTrackId = null;
    _isPreviewMode = false;
  }

  void dispose() {
    _player.dispose();
  }
}