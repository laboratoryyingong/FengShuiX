import 'dart:math' as math;
import 'package:flutter/material.dart';

class LuopanPainter extends CustomPainter {
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
    const mountainStyle = TextStyle(
      color: Colors.white,
      fontSize: 13,
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
    const bigDirStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    final directions = ['北', '东北', '东', '东南', '南', '西南', '西', '西北'];

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
    // 我们放在更里面一点，比如 midRadius - 50
    final baguaRadius = midRadius - 50;
    canvas.drawCircle(center, baguaRadius, outerPaint..strokeWidth = 1);

    // 八卦顺序（从正北开始逆时针/顺时针都有人用，这里我们沿用常见顺时针一圈）
    // 这里我选顺时针：乾、坎、艮、震、巽、离、坤、兑
    // 起点还是从正上方
    const bagua = ['乾', '坎', '艮', '震', '巽', '离', '坤', '兑'];
    const baguaStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
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
    // 太极放在最里面：半径设小一点
    final taijiRadius = baguaRadius - 26; // 你可以调小/大
    _drawTaiji(canvas, center, taijiRadius);

    // ========== 5. 十字辅助线 ==========
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

    // 上半黑、下半白（也可以反过来）
    final rect = Rect.fromCircle(center: center, radius: r);
    // 上半圆弧(黑)
    canvas.drawArc(rect, -math.pi / 2, math.pi, true, blackPaint);
    // 下半圆弧(白)
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
