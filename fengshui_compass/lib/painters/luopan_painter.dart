import 'dart:math' as math;
import 'package:flutter/material.dart';

class LuopanPainter extends CustomPainter {
  LuopanPainter({
    this.textScale = 1.0,
    this.useTraditional = false,
    this.showCrosshair = true,
  });

  /// 字体放大倍数（外面想做老年模式就传 1.3 / 1.5）
  final double textScale;

  /// 是否使用繁體
  final bool useTraditional;

  /// 要不要画十字辅助线
  final bool showCrosshair;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // ========== 外圈 ==========
    final outerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius - 2, outerPaint);

    // 中圈（给大方向、24山用的基准）
    final midRadius = radius - 34;
    canvas.drawCircle(center, midRadius, outerPaint..strokeWidth = 1);

    // ========== 1. 24 山（脚朝心） ==========
    // 24 山本来就是这些字，简繁一样
    const mountain24 = [
      '壬',
      '子',
      '癸',
      '丑',
      '艮',
      '寅',
      '甲',
      '卯',
      '乙',
      '辰',
      '巽',
      '巳',
      '丙',
      '午',
      '丁',
      '未',
      '坤',
      '申',
      '庚',
      '酉',
      '辛',
      '戌',
      '乾',
      '亥',
    ];
    final mountainStyle = TextStyle(
      color: Colors.white,
      fontSize: 13 * textScale,
      fontWeight: FontWeight.w500,
    );

    for (int i = 0; i < 24; i++) {
      final angle = -math.pi / 2 + i * (2 * math.pi / 24);

      // 刻度
      final tickStart = Offset(
        center.dx + (midRadius + 4) * math.cos(angle),
        center.dy + (midRadius + 4) * math.sin(angle),
      );
      final tickEnd = Offset(
        center.dx + (radius - 4) * math.cos(angle),
        center.dy + (radius - 4) * math.sin(angle),
      );

      final tickPaint = Paint()
        ..color = Colors.white70
        ..strokeWidth = (i % 3 == 0) ? 1.6 : 0.9;
      canvas.drawLine(tickStart, tickEnd, tickPaint);

      // 文字半径
      final textR = radius - 22;
      final pos = Offset(
        center.dx + textR * math.cos(angle),
        center.dy + textR * math.sin(angle),
      );

      final tp = TextPainter(
        text: TextSpan(text: mountain24[i], style: mountainStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      // 字脚朝心
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(angle + math.pi / 2);
      canvas.translate(-tp.width / 2, -tp.height / 2);
      tp.paint(canvas, Offset.zero);
      canvas.restore();
    }

    // ========== 2. 8 个大方向（脚朝心） ==========
    final bigDirStyle = TextStyle(
      color: Colors.white,
      fontSize: 16 * textScale,
      fontWeight: FontWeight.w600,
    );

    // 简体
    final directionsCN = ['北', '东北', '东', '东南', '南', '西南', '西', '西北'];
    // 繁体（其实就是 东→東）
    final directionsTW = ['北', '東北', '東', '東南', '南', '西南', '西', '西北'];
    final directions = useTraditional ? directionsTW : directionsCN;

    for (int i = 0; i < 8; i++) {
      final angle = -math.pi / 2 + i * (2 * math.pi / 8);
      final textR = midRadius - 6; // 在中圈里面一点
      final pos = Offset(
        center.dx + textR * math.cos(angle),
        center.dy + textR * math.sin(angle),
      );

      final tp = TextPainter(
        text: TextSpan(text: directions[i], style: bigDirStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(angle + math.pi / 2);
      canvas.translate(-tp.width / 2, -tp.height / 2);
      tp.paint(canvas, Offset.zero);
      canvas.restore();
    }

    // ========== 3. 八卦圈 ==========
    // 放在更里面一点，比如 midRadius - 50
    final baguaRadius = midRadius - 50;
    canvas.drawCircle(center, baguaRadius, outerPaint..strokeWidth = 1);

    // 八卦顺序
    // 简体：乾、坎、艮、震、巽、离、坤、兑
    // 繁体：乾、坎、艮、震、巽、離、坤、兌
    const baguaCN = ['乾', '坎', '艮', '震', '巽', '离', '坤', '兑'];
    const baguaTW = ['乾', '坎', '艮', '震', '巽', '離', '坤', '兌'];
    final bagua = useTraditional ? baguaTW : baguaCN;

    final baguaStyle = TextStyle(
      color: Colors.white,
      fontSize: 18 * textScale,
      fontWeight: FontWeight.w700,
    );

    for (int i = 0; i < 8; i++) {
      final angle = -math.pi / 2 + i * (2 * math.pi / 8);
      final pos = Offset(
        center.dx + baguaRadius * math.cos(angle),
        center.dy + baguaRadius * math.sin(angle),
      );

      final tp = TextPainter(
        text: TextSpan(text: bagua[i], style: baguaStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      // 八卦也让脚朝心
      canvas.rotate(angle + math.pi / 2);
      canvas.translate(-tp.width / 2, -tp.height / 2);
      tp.paint(canvas, Offset.zero);
      canvas.restore();
    }

    // ========== 4. 太极图 ==========
    final taijiRadius = baguaRadius - 26; // 你可以调小/大
    _drawTaiji(canvas, center, taijiRadius);

    // ========== 5. 十字辅助线 ==========
    if (showCrosshair) {
      final crossPaint = Paint()
        ..color = Colors.white24
        ..strokeWidth = 1;
      canvas.drawLine(
        Offset(center.dx - radius, center.dy),
        Offset(center.dx + radius, center.dy),
        crossPaint,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - radius),
        Offset(center.dx, center.dy + radius),
        crossPaint,
      );
    }
  }

  /// 在 center 处画一个标准太极
  void _drawTaiji(Canvas canvas, Offset center, double r) {
    final whitePaint = Paint()..color = Colors.white;
    final blackPaint = Paint()..color = Colors.black;

    // 外圆边
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, r, borderPaint);

    // 上半黑、下半白
    final rect = Rect.fromCircle(center: center, radius: r);
    canvas.drawArc(rect, -math.pi / 2, math.pi, true, blackPaint);
    canvas.drawArc(rect, math.pi / 2, math.pi, true, whitePaint);

    // 上面的小白圆
    final smallR = r / 2;
    canvas.drawCircle(
      Offset(center.dx, center.dy - smallR),
      smallR,
      whitePaint,
    );
    // 下面的小黑圆
    canvas.drawCircle(
      Offset(center.dx, center.dy + smallR),
      smallR,
      blackPaint,
    );

    // 上面的小黑点
    canvas.drawCircle(Offset(center.dx, center.dy - smallR), r / 8, blackPaint);
    // 下面的小白点
    canvas.drawCircle(Offset(center.dx, center.dy + smallR), r / 8, whitePaint);
  }

  @override
  bool shouldRepaint(covariant LuopanPainter oldDelegate) {
    // 当 textScale / useTraditional / showCrosshair 变化时要重绘
    return oldDelegate.textScale != textScale ||
        oldDelegate.useTraditional != useTraditional ||
        oldDelegate.showCrosshair != showCrosshair;
  }
}
