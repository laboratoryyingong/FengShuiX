class LuopanRing {
  final double radiusOffset; // 相对最大半径往里缩多少
  final double fontSize;
  final List<String> segments;
  final bool showTicks;

  LuopanRing({
    required this.radiusOffset,
    required this.fontSize,
    required this.segments,
    this.showTicks = true,
  });
}
