import 'package:flutter/material.dart';
import 'package:fengshui_compass/models/fengshui_patterns.dart';
import 'package:fengshui_compass/models/cheat_mode.dart';

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

  // 24 山名字表
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

  // 简易流年表
  final Map<int, _Year24Data> _yearData = {
    2025: const _Year24Data(
      wuHuang: [16], // 坤
      erHei: [7, 8], // 卯 / 乙
      taiSui: [16],
      sanSha: [0, 1, 2],
      note: '2025：西南要静，正东注意健康，可用铜/葫芦。',
    ),
    2026: const _Year24Data(
      wuHuang: [7, 8], // 正东
      erHei: [10, 11], // 东南
      taiSui: [12, 13, 14], // 南
      sanSha: [21, 22, 23], // 西北
      note: '2026：东方是大煞，南面是太岁，北坐南向的要注意别正顶太岁。',
    ),
    2027: const _Year24Data(
      wuHuang: [10, 11], // 东南
      erHei: [12, 13], // 正南
      taiSui: [13, 14, 15], // 午 丁 未
      sanSha: [18, 19, 20], // 西
      note: '2027：东南动土要慎，西面别坐背西。',
    ),
    2028: const _Year24Data(
      wuHuang: [12, 13, 14], // 南
      erHei: [16], // 坤
      taiSui: [16, 17], // 西南→申
      sanSha: [4, 5, 6], // 东北偏东
      note: '2028：南方五黄又遇九运火，要防火土过旺；西南也要静。',
    ),
    2029: const _Year24Data(
      wuHuang: [16, 17], // 西南偏西
      erHei: [19, 20], // 西
      taiSui: [19, 20], // 西
      sanSha: [12, 13, 14], // 南
      note: '2029：南方三煞，不要长期坐南背北；西面也不宜动。',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final currentYearInfo = _yearData[_selectedYear];

    // 1. 根据入住年份推运
    final int period = _guessPeriodByMoveIn(widget.moveInYear);

    // 2. 计算四种格局（带作弊）
    FengshuiPattern pattern;
    String cheatTip = '';
    if (widget.cheatMode == CheatMode.wangCaiWangDing) {
      pattern = FengshuiPattern.wangCaiWangDing;
      cheatTip = '⚠ 当前为作弊模式：固定显示【旺财旺丁】';
    } else if (widget.cheatMode == CheatMode.wangCaiBuWangDing) {
      pattern = FengshuiPattern.wangCaiBuWangDing;
      cheatTip = '⚠ 当前为作弊模式：固定显示【旺财不旺丁】';
    } else {
      pattern = calcFengshuiPattern(
        period: period,
        facing24Index: widget.currentNorthIndex24,
        sitting24Index: widget.currentSouthIndex24,
        doorDirection8: widget.doorDirection,
      );
    }
    final patternTitle = fengshuiPatternText(pattern);
    final patternDesc = fengshuiPatternRecommend(pattern);

    // 3. 八宅吉凶（用大门方位粗分）
    final EightHouseResult eightResult = _calcEightHouseByDoor(
      widget.doorDirection,
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题 + 长按作弊
            GestureDetector(
              onLongPress: () {
                widget.onCycleCheatMode?.call();
                String msg;
                switch (widget.cheatMode) {
                  case CheatMode.off:
                    msg = '作弊模式：下一档 → 旺财旺丁';
                    break;
                  case CheatMode.wangCaiWangDing:
                    msg = '作弊模式：下一档 → 旺财不旺丁';
                    break;
                  case CheatMode.wangCaiBuWangDing:
                    msg = '作弊模式：关闭';
                    break;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Row(
                children: [
                  const Text(
                    '三元九运分析',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (widget.cheatMode != CheatMode.off) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.shield, color: Colors.amber, size: 18),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 顶图（自己放）
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

            // 前提条件
            _card(
              title: '本次分析的前提条件',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '大门方位：${widget.doorDirection.isEmpty ? '未选择/自动用当前罗盘' : widget.doorDirection}',
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
                    '说明：请在分析前，把手机对着大门测一次；大门方位会影响八宅和财气；以后可以加“生日→命卦”让结果更精准。',
                    style: TextStyle(fontSize: 12.5, color: Colors.white60),
                  ),
                ],
              ),
            ),

            // 实时罗盘
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

            // 四种格局
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
                  // if (cheatTip.isNotEmpty) ...[
                  //   const SizedBox(height: 4),
                  //   Text(
                  //     cheatTip,
                  //     style: const TextStyle(
                  //       fontSize: 11.5,
                  //       color: Colors.redAccent,
                  //       height: 1.2,
                  //     ),
                  //   ),
                  // ],
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

            // ✅ 八宅 + 九宫格
            _card(
              title: '室内吉凶九宫（八宅+流年飞星提示）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '依据大门方位推断：${eightResult.group == EightHouseGroup.east ? '东四宅' : '西四宅'}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AspectRatio(
                    aspectRatio: 1,
                    child: _buildNinePalace(
                      eightResult: eightResult,
                      yearData: currentYearInfo,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '说明：请将户型图对正北后，对应本九宫格即可。吉位可放主卧、书房、老板位；凶位可做仓库、卫生间。',
                    style: TextStyle(fontSize: 11.5, color: Colors.white54),
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

            // 九运时间表
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

  // ========== 九宫格构建 ==========

  Widget _buildNinePalace({
    required EightHouseResult eightResult,
    required _Year24Data? yearData,
  }) {
    // 1~9 宫位的名字（先放八宅，后面叠流年）
    final Map<int, String> palaceName = {
      1: eightResult.palaceName(1),
      2: eightResult.palaceName(2),
      3: eightResult.palaceName(3),
      4: eightResult.palaceName(4),
      5: '中宫',
      6: eightResult.palaceName(6),
      7: eightResult.palaceName(7),
      8: eightResult.palaceName(8),
      9: eightResult.palaceName(9),
    };

    // 把流年煞位映射到九宫
    final Map<int, List<String>> palaceBad = {};
    if (yearData != null) {
      // 五黄
      for (final idx in yearData.wuHuang) {
        final p = _map24ToPalace(idx);
        palaceBad.putIfAbsent(p, () => []).add('五黄');
      }
      // 二黑
      for (final idx in yearData.erHei) {
        final p = _map24ToPalace(idx);
        palaceBad.putIfAbsent(p, () => []).add('二黑');
      }
      // 太岁
      for (final idx in yearData.taiSui) {
        final p = _map24ToPalace(idx);
        palaceBad.putIfAbsent(p, () => []).add('太岁');
      }
      // 三煞
      for (final idx in yearData.sanSha) {
        final p = _map24ToPalace(idx);
        palaceBad.putIfAbsent(p, () => []).add('三煞');
      }
    }

    // 洛书顺序：4 9 2 / 3 5 7 / 8 1 6
    final order = [4, 9, 2, 3, 5, 7, 8, 1, 6];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.count(
        crossAxisCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1,
        padding: EdgeInsets.zero,
        children: order.map((p) {
          final isGood = eightResult.isGood(p);
          final badTags = palaceBad[p] ?? [];
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24, width: 0.4),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '宫$p',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          palaceName[p] ?? '',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isGood
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                        ),
                        if (badTags.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 3,
                            runSpacing: -4,
                            children: badTags
                                .map(
                                  (t) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      t,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ========== 八宅简化计算 ==========

  EightHouseResult _calcEightHouseByDoor(String doorDir) {
    // 非常粗的分法：东四 / 西四
    final east =
        doorDir.contains('东') || doorDir.contains('南') || doorDir.contains('北');
    if (east) {
      return EightHouseResult.eastGroup();
    } else {
      return EightHouseResult.westGroup();
    }
  }

  // ========== 其它工具 ==========

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
      warns.add('⚠ “向”落在本年重点位上，请不要在这个方向开门、动土或放水。');
    }
    if (sitHit) {
      warns.add('⚠ “坐”落在本年重点位上，床/沙发/办公位尽量别正顶着这里，可微调 15°。');
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

  // 把 24 山归到 9 宫（简化版映射）
  // 北 → 1 宫；东北 → 8；东 → 3；东南 → 4；南 → 9；西南 → 2；西 → 7；西北 → 6；中宫 5 不用
  int _map24ToPalace(int idx24) {
    // 按你的 24 山顺序来分：0壬1子2癸(北) / 3丑4艮5寅(东北) / 6甲7卯8乙(东) / 9辰10巽11巳(东南)
    // 12丙13午14丁(南) / 15未16坤17申(西南) / 18庚19酉20辛(西) / 21戌22乾23亥(西北)
    if (idx24 <= 2) return 1; // 北
    if (idx24 <= 5) return 8; // 东北
    if (idx24 <= 8) return 3; // 东
    if (idx24 <= 11) return 4; // 东南
    if (idx24 <= 14) return 9; // 南
    if (idx24 <= 17) return 2; // 西南
    if (idx24 <= 20) return 7; // 西
    return 6; // 西北
  }
}

// ====== 数据结构们 ======

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

// ====== 八宅结果对象（简化版） ======

enum EightHouseGroup { east, west }

class EightHouseResult {
  final EightHouseGroup group;
  // palace → name
  final Map<int, String> palaceNames;
  final Set<int> goodPalaces;

  const EightHouseResult({
    required this.group,
    required this.palaceNames,
    required this.goodPalaces,
  });

  factory EightHouseResult.eastGroup() {
    // 东四：坎、离、震、巽 → 生气、天医、延年、伏位 放在东/东南/南/北这些宫
    return EightHouseResult(
      group: EightHouseGroup.east,
      palaceNames: {
        1: '伏位',
        2: '六煞',
        3: '生气',
        4: '天医',
        5: '中宫',
        6: '五鬼',
        7: '祸害',
        8: '延年',
        9: '绝命',
      },
      goodPalaces: {1, 3, 4, 8},
    );
  }

  factory EightHouseResult.westGroup() {
    // 西四：乾、兑、艮、坤
    return EightHouseResult(
      group: EightHouseGroup.west,
      palaceNames: {
        1: '祸害',
        2: '天医',
        3: '五鬼',
        4: '六煞',
        5: '中宫',
        6: '延年',
        7: '伏位',
        8: '绝命',
        9: '生气',
      },
      goodPalaces: {2, 6, 7, 9},
    );
  }

  String palaceName(int palace) {
    return palaceNames[palace] ?? '';
  }

  bool isGood(int palace) => goodPalaces.contains(palace);
}
