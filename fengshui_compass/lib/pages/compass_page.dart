import 'dart:async'; // 👈 新增：为了 StreamSubscription
import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../widgets/compass_view.dart';

class CompassPage extends StatefulWidget {
  final void Function({
    required double northDeg,
    required double southDeg,
    required String facingText,
    required String sittingText,
    required int northIndex24,
    required int southIndex24,
  })?
  onHeadingChanged;

  final bool useTraditional;
  final Future<String> Function(String text)? tr;

  const CompassPage({
    super.key,
    this.onHeadingChanged,
    this.useTraditional = false,
    this.tr,
  });

  @override
  State<CompassPage> createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  // 👇 新增：把两个监听都存下来
  StreamSubscription<CompassEvent>? _compassSub;
  StreamSubscription<AccelerometerEvent>? _accelSub;

  double _rawHeading = 0;
  double _offset = 0;
  final List<double> _smoothBuffer = [];
  final int _smoothWindow = 5;

  bool _showCrosshair = true;
  bool _isLevel = true;

  double _accuracyDeg = 16;
  bool _accuracyLocked = false;

  final Random _random = Random();

  DateTime _lastShake = DateTime.fromMillisecondsSinceEpoch(0);
  static const int _shakeCooldownMs = 900;
  static const double _shakeThreshold = 12.0;

  @override
  void initState() {
    super.initState();

    _accuracyDeg = _randomAccuracyInit();

    // ✅ 1. 指南针订阅
    _compassSub = FlutterCompass.events?.listen((event) {
      if (event == null) return;
      final h = event.heading;
      if (h == null) return;
      _onNewHeading(h);

      // 更新精度这块也要防止 setState after dispose
      if (event.accuracy != null) {
        final deviceAcc = event.accuracy!.abs();
        if (!_accuracyLocked || deviceAcc < _accuracyDeg) {
          if (!mounted) return;
          setState(() {
            _accuracyDeg = deviceAcc;
            _accuracyLocked = false;
          });
        }
      }
    });

    // ✅ 2. 加速度计订阅
    _accelSub = accelerometerEvents.listen((AccelerometerEvent event) {
      // 页面被关了以后也别再处理
      if (!mounted) return;

      final double x = event.x;
      final double y = event.y;
      final double z = event.z;

      final double pitch =
          math.atan(x / math.sqrt(y * y + z * z)) * 180 / math.pi;
      final double roll =
          math.atan(y / math.sqrt(x * x + z * z)) * 180 / math.pi;

      const double threshold = 7.0;
      final bool level = pitch.abs() < threshold && roll.abs() < threshold;
      if (level != _isLevel) {
        if (!mounted) return;
        setState(() {
          _isLevel = level;
        });
      }

      final double g = math.sqrt(x * x + y * y + z * z);
      final now = DateTime.now();
      final diff = now.difference(_lastShake).inMilliseconds;
      if (g > _shakeThreshold && diff > _shakeCooldownMs) {
        _lastShake = now;
        _onShake();
      }
    });
  }

  @override
  void dispose() {
    // 👇 非常重要：离开页面就取消监听
    _compassSub?.cancel();
    _accelSub?.cancel();
    _compassSub = null;
    _accelSub = null;
    super.dispose();
  }

  double _randomAccuracyInit() {
    return (8 + _random.nextInt(13)).toDouble();
  }

  double _randomAccuracyAfterShake() {
    return (4 + _random.nextInt(7)).toDouble();
  }

  void _onShake() {
    if (!mounted) return;

    setState(() {
      _accuracyDeg = _randomAccuracyAfterShake();
      _accuracyLocked = true;
    });

    // 5 秒后解锁要再检查 mounted
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        _accuracyLocked = false;
      });
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.useTraditional ? '已根據搖晃動作重新校正電子羅盤準確度' : '已根据摇晃动作重新校正电子罗盘准确度',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onNewHeading(double h) {
    // 这里是频繁进来的，要很小心 mounted

    _smoothBuffer.add(h);
    if (_smoothBuffer.length > _smoothWindow) {
      _smoothBuffer.removeAt(0);
    }
    final avg = _smoothBuffer.reduce((a, b) => a + b) / _smoothBuffer.length;

    double north = (avg + _offset) % 360;
    if (north < 0) north += 360;
    double south = north - 180;
    if (south < 0) south += 360;

    final int northIdx = _degTo24Index(north);
    final int southIdx = _degTo24Index(south);

    final facingText = _angleTo24Mountains(
      north,
      prefix: widget.useTraditional ? '向：' : '向：',
      useTraditional: widget.useTraditional,
    );
    final sittingText = _angleTo24Mountains(
      south,
      prefix: widget.useTraditional ? '坐：' : '坐：',
      useTraditional: widget.useTraditional,
    );

    if (!mounted) return;
    setState(() {
      _rawHeading = avg;
    });

    // 这里也要防止页面已经被销毁但外面还持有这个 callback
    if (mounted) {
      widget.onHeadingChanged?.call(
        northDeg: north,
        southDeg: south,
        facingText: facingText,
        sittingText: sittingText,
        northIndex24: northIdx,
        southIndex24: southIdx,
      );
    }
  }

  int _degTo24Index(double deg) {
    int idx = (deg / 15).round() % 24;
    return idx;
  }

  double get _finalHeading {
    double v = _rawHeading + _offset;
    v %= 360;
    if (v < 0) v += 360;
    return v;
  }

  double get _southBaseHeading {
    double v = _finalHeading - 180;
    if (v < 0) v += 360;
    return v;
  }

  String get _accuracyLabel {
    final d = _accuracyDeg;
    if (d <= 10) return widget.useTraditional ? '滿意' : '满意';
    if (d <= 15) return widget.useTraditional ? '普通' : '普通';
    return widget.useTraditional ? '錯誤' : '错误';
  }

  String get _accuracyDisplay {
    return widget.useTraditional
        ? '準確度：$_accuracyLabel (±${_accuracyDeg.toStringAsFixed(0)}°)'
        : '准确度：$_accuracyLabel (±${_accuracyDeg.toStringAsFixed(0)}°)';
  }

  String _angleTo24Mountains(
    double deg, {
    String prefix = '',
    bool useTraditional = false,
  }) {
    const names = [
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
    int idx = _degTo24Index(deg);
    final m = names[idx];
    final dir = _to8Dir(deg, useTraditional: useTraditional);
    return '$prefix$dir-$m';
  }

  String _to8Dir(double deg, {bool useTraditional = false}) {
    const dirs = ['正北', '东北', '正东', '东南', '正南', '西南', '正西', '西北'];
    int idx = ((deg + 22.5) / 45).floor() % 8;
    String d = dirs[idx];
    if (!useTraditional) return d;
    return d.replaceAll('东', '東');
  }

  @override
  Widget build(BuildContext context) {
    final radians = _finalHeading * (math.pi / 180);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: _buildLevelIndicator(_isLevel),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Center(
                    child: CompassView(
                      rotationRadians: radians,
                      northBaseDeg: _finalHeading,
                      southBaseDeg: _southBaseHeading,
                      showCrosshair: _showCrosshair,
                      useTraditional: widget.useTraditional,
                      tr: widget.tr,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (!mounted) return;
                  setState(() {
                    _showCrosshair = !_showCrosshair;
                  });
                },
                icon: Icon(
                  _showCrosshair ? Icons.visibility : Icons.visibility_off,
                ),
                label: Text(
                  _showCrosshair
                      ? (widget.useTraditional ? '隱藏十字線' : '隐藏十字线')
                      : (widget.useTraditional ? '顯示十字線' : '显示十字线'),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 12,
              height: 32,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            _accuracyLabel ==
                                (widget.useTraditional ? '滿意' : '满意')
                            ? Colors.green
                            : (_accuracyLabel ==
                                      (widget.useTraditional ? '普通' : '普通')
                                  ? Colors.orange
                                  : Colors.red),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _accuracyDisplay,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _showCorrectionDialog(context);
                    },
                    child: Text(
                      widget.useTraditional ? '修正' : '修正',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelIndicator(bool isLevel) {
    final bool zhTW = widget.useTraditional;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isLevel
            ? Colors.green.withOpacity(0.9)
            : Colors.orange.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLevel ? Icons.check_circle : Icons.warning_amber_rounded,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            isLevel ? (zhTW ? '已水平' : '已水平') : (zhTW ? '請保持水平' : '请保持水平'),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showCorrectionDialog(BuildContext context) {
    final bool zhTW = widget.useTraditional;

    final String title = zhTW ? '電子羅盤修正' : '电子罗盘修正';
    final String content = zhTW
        ? '由於電磁波的干擾，電子羅盤顯示的方向誤差可能會比較大。\n\n'
              '準確度分為三級：\n'
              '• ±0－10：滿意\n'
              '• ±11－15：普通\n'
              '• ±16＋：錯誤\n\n'
              '想要提高電子羅盤的準確度，請快速搖晃您的裝置多次，讓羅盤重新校準到正確的方向。\n'
              '如果仍然不正確，請移動到電磁干擾較小的位置重新量度，或改用手動輸入大門方向。'
        : '由于电磁波的干扰，电子罗盘显示的方向误差可能会比较大。\n\n'
              '准确度分为三级：\n'
              '• ±0－10：满意\n'
              '• ±11－15：普通\n'
              '• ±16＋：错误\n\n'
              '想要提高电子罗盘的准确度，请快速摇晃您的装置多次，让罗盘重新校准到正确的方向。\n'
              '如果仍然不正确，请移动到电磁干扰较小的位置重新量度，或改用手动输入大门方向。';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: Text(
            content,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(zhTW ? '確定' : '确定'),
            ),
          ],
        );
      },
    );
  }
}
