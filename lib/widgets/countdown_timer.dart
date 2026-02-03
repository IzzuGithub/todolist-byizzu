import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime deadline;
  const CountdownTimerWidget({Key? key, required this.deadline}) : super(key: key);
  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}
class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Timer _timer;
  Duration _remaining = Duration.zero;
  @override
  void initState() { super.initState(); _calculateTime(); _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _calculateTime()); }
  @override
  void dispose() { _timer.cancel(); super.dispose(); }
  void _calculateTime() {
    final now = DateTime.now();
    if (now.isAfter(widget.deadline)) { _timer.cancel(); if(mounted) setState(() => _remaining = Duration.zero); }
    else { if(mounted) setState(() => _remaining = widget.deadline.difference(now)); }
  }
  @override
  Widget build(BuildContext context) {
    if (_remaining == Duration.zero) return const Text("Waktu Habis", style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold));
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return Text("${twoDigits(_remaining.inHours)}:${twoDigits(_remaining.inMinutes.remainder(60))}:${twoDigits(_remaining.inSeconds.remainder(60))}", style: const TextStyle(fontSize: 11, color: Colors.blueAccent, fontWeight: FontWeight.bold, fontFeatures: [FontFeature.tabularFigures()]));
  }
}