import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:just_audio/just_audio.dart';

void main() => runApp(const TrinityApp());

class TrinityApp extends StatefulWidget {
  const TrinityApp({super.key});
  @override State<TrinityApp> createState() => _TrinityAppState();
}

class _TrinityAppState extends State<TrinityApp> {
  final player = AudioPlayer();
  double bpm = 60.0;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((event) {
      final g = event.x.abs() + event.y.abs() + event.z.abs();
      final newBpm = 60 + (g * 15).clamp(0, 120);
      if ((newBpm - bpm).abs() > 2) {
        setState(() => bpm = newBpm);
        triggerPulse(newBpm);
      }
    });
    triggerPulse(60);
  }

  void triggerPulse(double bpm) async {
    final freq = 220.0 + (bpm - 60) * 3.5;
    await player.setAsset('assets/pulse/trinity_pulse.wav');
    await player.setPitch(freq / 440.0);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            '${bpm.toStringAsFixed(1)} BPM',
            style: const TextStyle(
              color: Color(0xFFCC0000),
              fontSize: 48,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ),
    );
  }
}
