import 'package:flutter/material.dart';
import 'package:fengshui_compass/models/fengshui_patterns.dart';

enum CheatMode { off, wangCaiWangDing, wangCaiBuWangDing }

class AnalysisPage extends StatefulWidget {
  final double currentNorthDeg;
  final double currentSouthDeg;
  final String currentFacingText;
  final String currentSittingText;
  final int currentNorthIndex24;
  final int currentSouthIndex24;

  final String doorDirection;
  final int moveInYear;
  final String industry;

  final CheatMode cheatMode;
  final VoidCallback? onCycleCheatMode;

  const AnalysisPage({
    super.key,
    required this.currentNorthDeg,
    required this.currentSouthDeg,
    required this.currentFacingText,
    required this.currentSittingText,
    required this.currentNorthIndex24,
    required this.currentSouthIndex24,
    required this.doorDirection,
    required this.moveInYear,
    required this.industry,
    this.cheatMode = CheatMode.off,
    this.onCycleCheatMode,
  });

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  int _selectedYear = 2025;

  static const List<String> _mountain24 = [
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

  final Map<int, _Year24Data> _yearData = {
    2025: _Year24Data(
      wuHuang: [16],
      erHei: [7, 8],
      taiSui: [16],
      sanSha: [0, 1, 2],
      note: '2025：西南要静，正东注意健康，可用铜/葫芦。',
    ),
    2026: _Year24Data(
      wuHuang: [7, 8],
      erHei: [10, 11],
      taiSui: [12, 13, 14],
      sanSha: [21, 22, 23],
      note: '2026：东方是大煞，南面是太岁，北坐南向的要注意别正顶太岁。',
    ),
    2027: _Year24Data(
      wuHuang: [10, 11],
      erHei: [12, 13],
      taiSui: [13, 14, 15],
      sanSha: [18, 19, 20],
      note: '2027：东南动土要慎，西面别坐背西。',
    ),
    2028: _Year24Data(
      wuHuang: [12, 13, 14],
      erHei: [16],
      taiSui: [16, 17],
      sanSha: [4, 5, 6],
      note: '2028：南方五黄又遇九运火，要防火土过旺；西南也要静。',
    ),
    2029: _Year24Data(
      wuHuang: [16, 17],
      erHei: [19, 20],
      taiSui: [19, 20],
      sanSha: [12, 13, 14],
      note: '2029：南方三煞，不要长期坐南背北；西面也不宜动。',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final currentYearInfo = _yearData[_selectedYear];

    // 1. 根据入住年份推运
    final int period = _guessPeriodByMoveIn(widget.moveInYear);

    // 2. 用模型计算四种格局
    final pattern = calcFengshuiPattern(
      period: period,
      facing24Index: widget.currentNorthIndex24,
      sitting24Index: widget.currentSouthIndex24,
      doorDirection8: widget.doorDirection,
    );
    final patternTitle = fengshuiPatternText(pattern);
    final patternDesc = fengshuiPatternRecommend(pattern);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '三元九运分析',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'assets/analysis/jiuyun_map.png',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _buildCurrentYunText(period),
              style: TextStyle(
                fontSize: 14.5,
                color: Colors.amber.shade200,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '九运主火：要光、要亮、要动，用水要谨慎。',
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
            const SizedBox(height: 14),

            // 前提
            _card(
              title: '本次分析的前提条件',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '大门方位：${widget.doorDirection.isEmpty ? '未选择/自动取当前罗盘方位' : widget.doorDirection}',
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  Text(
                    '入住年份：${widget.moveInYear}',
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  Text(
                    '行业：${widget.industry.isEmpty ? '未选择/综合' : widget.industry}',
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '说明：请在分析前，将手机正对大门测量一次；入住年份用于判断是7/8/9运；行业用于做应用场景参考。',
                    style: TextStyle(fontSize: 12.5, color: Colors.white60),
                  ),
                ],
              ),
            ),

            // 罗盘实时
            _card(
              title: '当前罗盘数据（实时）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.currentFacingText.isNotEmpty
                        ? widget.currentFacingText
                        : '向：暂未读取',
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  Text(
                    widget.currentSittingText.isNotEmpty
                        ? widget.currentSittingText
                        : '坐：暂未读取',
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '北基准：${widget.currentNorthDeg.toStringAsFixed(1)}°（${_mountain24[widget.currentNorthIndex24]}）',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.white54,
                    ),
                  ),
                  Text(
                    '南基准：${widget.currentSouthDeg.toStringAsFixed(1)}°（${_mountain24[widget.currentSouthIndex24]}）',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),

            // 风水格局
            _card(
              title: '本宅风水格局（简化玄空）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patternTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '按入住年份推算为：${period}运',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.white60,
                    ),
                  ),
                  if (widget.doorDirection.isNotEmpty)
                    Text(
                      '大门方位：${widget.doorDirection}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.white60,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    patternDesc,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.white70,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '提示：这是手机端快速判断版，要做完整玄空飞星还需起盘、看山星/向星、零正、门位/床位落宫。',
                    style: TextStyle(fontSize: 11.5, color: Colors.white38),
                  ),
                ],
              ),
            ),

            // 流年选择
            _card(
              title: '选择流年',
              child: Row(
                children: [
                  const Text('流年：', style: TextStyle(fontSize: 13.5)),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    dropdownColor: Colors.grey.shade900,
                    value: _selectedYear,
                    style: const TextStyle(color: Colors.white),
                    items: _yearData.keys.map((year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text('$year 年'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() {
                        _selectedYear = val;
                      });
                    },
                  ),
                ],
              ),
            ),

            if (currentYearInfo != null)
              _card(
                title: '$_selectedYear 年流年煞位（24 山精确匹配）',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line('五黄位', _namesFromIndex(currentYearInfo.wuHuang)),
                    _line('二黑病符', _namesFromIndex(currentYearInfo.erHei)),
                    _line('太岁位', _namesFromIndex(currentYearInfo.taiSui)),
                    _line('三煞位', _namesFromIndex(currentYearInfo.sanSha)),
                    const SizedBox(height: 6),
                    Text(
                      currentYearInfo.note,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _build24MatchResult(
                      yearInfo: currentYearInfo,
                      facingIdx: widget.currentNorthIndex24,
                      sittingIdx: widget.currentSouthIndex24,
                    ),
                  ],
                ),
              ),

            _card(
              title: '三元九运时间表',
              child: const Text(
                '1 运：1864 - 1883\n'
                '2 运：1884 - 1903\n'
                '3 运：1904 - 1923\n'
                '4 运：1924 - 1943\n'
                '5 运：1944 - 1963\n'
                '6 运：1964 - 1983\n'
                '7 运：1984 - 2003\n'
                '8 运：2004 - 2023\n'
                '9 运：2024 - 2043  ← 当前',
                style: TextStyle(fontSize: 13, height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _guessPeriodByMoveIn(int moveInYear) {
    if (moveInYear >= 2024) return 9;
    if (moveInYear >= 2004) return 8;
    return 7;
  }

  String _buildCurrentYunText(int period) {
    switch (period) {
      case 9:
        return '当前运：下元 · 九运（2024 - 2043）';
      case 8:
        return '当前运：下元 · 八运（2004 - 2023）';
      case 7:
        return '当前运：下元 · 七运（1984 - 2003）';
      default:
        return '当前运：待定';
    }
  }

  String _namesFromIndex(List<int> idxs) {
    return idxs.map((i) => _mountain24[i]).join(' / ');
  }

  Widget _build24MatchResult({
    required _Year24Data yearInfo,
    required int facingIdx,
    required int sittingIdx,
  }) {
    final bool faceHit = _isHitAny(yearInfo.allBadIndexes, facingIdx);
    final bool sitHit = _isHitAny(yearInfo.allBadIndexes, sittingIdx);

    if (!faceHit && !sitHit) {
      return const Text(
        '✅ 当前量到的向/坐没有贴着本年的五黄/二黑/太岁/三煞，可正常参考九运布局。',
        style: TextStyle(fontSize: 12.5, color: Colors.greenAccent),
      );
    }

    final List<String> warns = [];
    if (faceHit) {
      warns.add('⚠ 你的“向”落在本年重点位上，请不要在这个方向开门、动土或放水。');
    }
    if (sitHit) {
      warns.add('⚠ 你的“坐”落在本年重点位上，床/沙发/办公位尽量别正顶着这里，可微调 15°。');
    }

    return Text(
      warns.join('\n'),
      style: const TextStyle(
        fontSize: 12.5,
        color: Colors.orangeAccent,
        height: 1.35,
      ),
    );
  }

  bool _isHitAny(List<int> bads, int userIdx) {
    for (final b in bads) {
      if (_isSameOrNeighbor(b, userIdx)) return true;
    }
    return false;
  }

  bool _isSameOrNeighbor(int a, int b) {
    if (a == b) return true;
    if ((a - b).abs() == 1) return true;
    if ((a == 0 && b == 23) || (a == 23 && b == 0)) return true;
    return false;
  }

  static Widget _card({required String title, required Widget child}) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _Year24Data {
  final List<int> wuHuang;
  final List<int> erHei;
  final List<int> taiSui;
  final List<int> sanSha;
  final String note;

  const _Year24Data({
    required this.wuHuang,
    required this.erHei,
    required this.taiSui,
    required this.sanSha,
    required this.note,
  });

  List<int> get allBadIndexes => [...wuHuang, ...erHei, ...taiSui, ...sanSha];
}

class _line extends StatelessWidget {
  final String label;
  final String value;
  const _line(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white70,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
