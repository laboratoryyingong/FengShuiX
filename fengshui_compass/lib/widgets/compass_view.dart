import 'package:flutter/material.dart';
import '../painters/luopan_painter.dart';

class CompassView extends StatelessWidget {
  final double rotationRadians; // 盘要转的角度(弧度)
  final double northBaseDeg; // 当前北基准度数
  final double southBaseDeg; // 当前南基准度数
  final bool showCrosshair; // 显示/隐藏十字线

  /// 新增：是不是用繁體
  final bool useTraditional;

  /// （可选）如果你想这里也用 flutter_open_chinese_convert，就传进来
  /// 但这几个字我们其实可以手写，不传也行
  final Future<String> Function(String text)? tr;

  const CompassView({
    super.key,
    required this.rotationRadians,
    required this.northBaseDeg,
    required this.southBaseDeg,
    this.showCrosshair = true,
    this.useTraditional = false,
    this.tr,
  });

  @override
  Widget build(BuildContext context) {
    // 向：用北基准
    final String facingText = _buildFacingText(northBaseDeg, useTraditional);
    // 坐：北基准+180
    final double sittingDeg = (northBaseDeg + 180) % 360;
    final String sittingText = _buildSittingText(sittingDeg, useTraditional);

    return SizedBox(
      width: 320,
      // 给上下留一点空间
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ===== 上面两行 =====
          _infoChip(facingText),
          const SizedBox(height: 6),
          _infoChip(
            useTraditional
                ? '當前角度(北基準):${northBaseDeg.toStringAsFixed(1)}°'
                : '当前角度(北基准):${northBaseDeg.toStringAsFixed(1)}°',
          ),
          const SizedBox(height: 8),

          // ===== 中间罗盘，不被遮挡 =====
          SizedBox(
            width: 320,
            height: 320,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. 可旋转的盘
                Transform.rotate(
                  angle: -rotationRadians,
                  child: CustomPaint(
                    size: const Size(320, 320),
                    painter: LuopanPainter(
                      textScale: 1.2, // 老年模式
                      useTraditional: useTraditional, // 从上面传下来的
                      showCrosshair: false, // 如果你想画师傅那种干净的盘
                    ),
                  ),
                ),

                // 2. 固定十字线
                if (showCrosshair) const _Crosshair(),

                // 3. 中心点
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ===== 下面两行 =====
          _infoChip(
            useTraditional
                ? '當前角度(南基準):${southBaseDeg.toStringAsFixed(1)}°'
                : '当前角度(南基准):${southBaseDeg.toStringAsFixed(1)}°',
          ),
          const SizedBox(height: 6),
          _infoChip(sittingText),
        ],
      ),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white30),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  /// “向：正东-甲” / “向：正東-甲”
  String _buildFacingText(double deg, bool useTraditional) {
    final String major = _majorDirection(deg, useTraditional);
    final String mountain = _mountain24(deg); // 24山本来就是这些字，简繁一样
    return useTraditional ? '向：$major-$mountain' : '向：$major-$mountain';
  }

  /// “坐：正西-庚” / “坐：正西-庚”
  String _buildSittingText(double deg, bool useTraditional) {
    final String major = _majorDirection(deg, useTraditional);
    final String mountain = _mountain24(deg);
    return useTraditional ? '坐：$major-$mountain' : '坐：$major-$mountain';
  }

  /// 8 个大方向
  /// 简体：正北 东北 正东 东南 正南 西南 正西 西北
  /// 繁体：正北 東北 正東 東南 正南 西南 正西 西北  （其实就“东→東”）
  String _majorDirection(double deg, bool useTraditional) {
    deg = deg % 360;
    if (deg < 0) deg += 360;

    // 先按简体算出方向
    String dir;
    if (deg >= 337.5 || deg < 22.5) {
      dir = '正北';
    } else if (deg < 67.5) {
      dir = '东北';
    } else if (deg < 112.5) {
      dir = '正东';
    } else if (deg < 157.5) {
      dir = '东南';
    } else if (deg < 202.5) {
      dir = '正南';
    } else if (deg < 247.5) {
      dir = '西南';
    } else if (deg < 292.5) {
      dir = '正西';
    } else {
      dir = '西北';
    }

    if (!useTraditional) return dir;

    // 简单替换成繁体（够用了）
    return dir.replaceAll('东', '東').replaceAll('风', '風'); // 这里其实没有“风”，备个手
  }

  /// 24 山，和 painter 里一致
  String _mountain24(double deg) {
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

    deg = deg % 360;
    if (deg < 0) deg += 360;

    // 每 15° 一格，加 7.5° 让它更贴近视觉位置
    int index = ((deg + 7.5) ~/ 15) % 24;
    return mountain24[index];
  }
}

/// 十字线
class _Crosshair extends StatelessWidget {
  const _Crosshair();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        children: [
          // 垂直红线
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 3,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // 水平红线
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 3,
              width: 280,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
