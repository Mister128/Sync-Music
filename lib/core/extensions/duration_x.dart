extension DurationDisplay on Duration {
  String get display {
    final h = inHours;
    final m = inMinutes.remainder(60);
    final s = inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:${m.toString().padLeft(2, "0")}:$s' : '$m:$s';
  }
}
