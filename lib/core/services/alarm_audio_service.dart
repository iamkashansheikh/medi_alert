import 'package:audioplayers/audioplayers.dart';

class AlarmAudioService {
  static final AlarmAudioService _instance = AlarmAudioService._internal();
  factory AlarmAudioService() => _instance;
  AlarmAudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> start() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(
      AssetSource('alaram_bell.mp3'),
      volume: 1.0,
    );
  }

  Future<void> stop() async {
    await _player.stop();
  }
}