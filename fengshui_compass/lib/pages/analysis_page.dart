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

  /// 新增：是否繁體
  final bool useTraditional;

  /// 新增：可選的異步轉換（你如果要用 flutter_open_chinese_convert，就從上面 RootTabs 傳進來）
  final Future<String> Function(String text)? tr;

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
    this.useTraditional = false,
    this.tr,
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

  // 简易流年表（简/繁都放这）
  late final Map<int, _Year24Data> _yearData = {
    2025: _Year24Data(
      wuHuang: const [16], // 坤
      erHei: const [7, 8], // 卯 / 乙
      taiSui: const [16],
      sanSha: const [0, 1, 2],
      noteCN: '2025：西南要静，正东注意健康，可用铜/葫芦。',
      noteTW: '2025：西南要靜，正東注意健康，可用銅 / 葫蘆。',
    ),
    2026: _Year24Data(
      wuHuang: const [7, 8], // 正东
      erHei: const [10, 11], // 东南
      taiSui: const [12, 13, 14], // 南
      sanSha: const [21, 22, 23], // 西北
      noteCN: '2026：东方是大煞，南面是太岁，北坐南向的要注意别正顶太岁。',
      noteTW: '2026：東方是大煞，南面是太歲，北坐南向的要注意別正頂太歲。',
    ),
    2027: _Year24Data(
      wuHuang: const [10, 11], // 东南
      erHei: const [12, 13], // 正南
      taiSui: const [13, 14, 15], // 午 丁 未
      sanSha: const [18, 19, 20], // 西
      noteCN: '2027：东南动土要慎，西面别坐背西。',
      noteTW: '2027：東南動土要慎，西面別坐背西。',
    ),
    2028: _Year24Data(
      wuHuang: const [12, 13, 14], // 南
      erHei: const [16], // 坤
      taiSui: const [16, 17], // 西南→申
      sanSha: const [4, 5, 6], // 东北偏东
      noteCN: '2028：南方五黄又遇九运火，要防火土过旺；西南也要静。',
      noteTW: '2028：南方五黃又遇九運火，要防火土過旺；西南也要靜。',
    ),
    2029: _Year24Data(
      wuHuang: const [16, 17], // 西南偏西
      erHei: const [19, 20], // 西
      taiSui: const [19, 20], // 西
      sanSha: const [12, 13, 14], // 南
      noteCN: '2029：南方三煞，不要长期坐南背北；西面也不宜动。',
      noteTW: '2029：南方三煞，不要長期坐南背北；西面也不宜動。',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final bool zhTW = widget.useTraditional;
    final currentYearInfo = _yearData[_selectedYear];

    // 1. 根据入住年份推运
    final int period = _guessPeriodByMoveIn(widget.moveInYear);

    // 2. 计算四种格局（带作弊）
    FengshuiPattern pattern;
    String cheatTip = '';
    if (widget.cheatMode == CheatMode.wangCaiWangDing) {
      pattern = FengshuiPattern.wangCaiWangDing;
      cheatTip = zhTW ? '⚠ 當前為作弊模式：固定顯示【旺財旺丁】' : '⚠ 当前为作弊模式：固定显示【旺财旺丁】';
    } else if (widget.cheatMode == CheatMode.wangCaiBuWangDing) {
      pattern = FengshuiPattern.wangCaiBuWangDing;
      cheatTip = zhTW ? '⚠ 當前為作弊模式：固定顯示【旺財不旺丁】' : '⚠ 当前为作弊模式：固定显示【旺财不旺丁】';
    } else {
      pattern = calcFengshuiPattern(
        period: period,
        facing24Index: widget.currentNorthIndex24,
        sitting24Index: widget.currentSouthIndex24,
        doorDirection8: widget.doorDirection,
      );
    }

    // 原函数是简体的，这里包一层
    final patternTitle = _patternTitleLocalized(pattern, zhTW);
    final patternDesc = _patternDescLocalized(pattern, zhTW);

    // 3. 八宅吉凶（用大门方位粗分）
    final EightHouseResult eightResult = _calcEightHouseByDoor(
      widget.doorDirection,
      zhTW,
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
                    msg = zhTW ? '作弊模式：下一檔 → 旺財旺丁' : '作弊模式：下一档 → 旺财旺丁';
                    break;
                  case CheatMode.wangCaiWangDing:
                    msg = zhTW ? '作弊模式：下一檔 → 旺財不旺丁' : '作弊模式：下一档 → 旺财不旺丁';
                    break;
                  case CheatMode.wangCaiBuWangDing:
                    msg = zhTW ? '作弊模式：關閉' : '作弊模式：关闭';
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
                  Text(
                    zhTW ? '三元九運分析' : '三元九运分析',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.cheatMode != CheatMode.off) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.shield, color: Colors.amber, size: 18),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 顶图
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
              _buildCurrentYunText(period, zhTW),
              style: TextStyle(
                fontSize: 14.5,
                color: Colors.amber.shade200,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              zhTW ? '九運主火：要光、要亮、要動，用水要謹慎。' : '九运主火：要光、要亮、要动，用水要谨慎。',
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
            const SizedBox(height: 14),

            // 前提条件
            _card(
              title: zhTW ? '本次分析的前提條件' : '本次分析的前提条件',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zhTW
                        ? '大門方位：${widget.doorDirection.isEmpty ? '未選擇/自動用當前羅盤' : widget.doorDirection}'
                        : '大门方位：${widget.doorDirection.isEmpty ? '未选择/自动用当前罗盘' : widget.doorDirection}',
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  Text(
                    zhTW
                        ? '入住年份：${widget.moveInYear}'
                        : '入住年份：${widget.moveInYear}',
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  Text(
                    zhTW
                        ? '行業：${widget.industry.isEmpty ? '未選擇/綜合' : widget.industry}'
                        : '行业：${widget.industry.isEmpty ? '未选择/综合' : widget.industry}',
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    zhTW
                        ? '說明：請在分析前，把手機對著大門測一次；大門方位會影響八宅和財氣；以後可以加「生日→命卦」讓結果更精準。'
                        : '说明：请在分析前，把手机对着大门测一次；大门方位会影响八宅和财气；以后可以加“生日→命卦”让结果更精准。',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),

            // 实时罗盘
            _card(
              title: zhTW ? '當前羅盤數據（實時）' : '当前罗盘数据（实时）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.currentFacingText.isNotEmpty
                        ? widget.currentFacingText
                        : (zhTW ? '向：暫未讀取' : '向：暂未读取'),
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  Text(
                    widget.currentSittingText.isNotEmpty
                        ? widget.currentSittingText
                        : (zhTW ? '坐：暫未讀取' : '坐：暂未读取'),
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (zhTW ? '北基準：' : '北基准：') +
                        '${widget.currentNorthDeg.toStringAsFixed(1)}°'
                            '（${_mountain24[widget.currentNorthIndex24]}）',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.white54,
                    ),
                  ),
                  Text(
                    (zhTW ? '南基準：' : '南基准：') +
                        '${widget.currentSouthDeg.toStringAsFixed(1)}°'
                            '（${_mountain24[widget.currentSouthIndex24]}）',
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
              title: zhTW ? '本宅風水格局（簡化玄空）' : '本宅风水格局（简化玄空）',
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
                    zhTW ? '按入住年份推算為：${period}運' : '按入住年份推算为：${period}运',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.white60,
                    ),
                  ),
                  if (widget.doorDirection.isNotEmpty)
                    Text(
                      (zhTW ? '大門方位：' : '大门方位：') + widget.doorDirection,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.white60,
                      ),
                    ),
                  if (cheatTip.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      cheatTip,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.redAccent,
                        height: 1.2,
                      ),
                    ),
                  ],
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
                  Text(
                    zhTW
                        ? '提示：這是手機端快速判斷版，要做完整玄空飛星還需起盤、看山星/向星、零正、門位/床位落宮。'
                        : '提示：这是手机端快速判断版，要做完整玄空飞星还需起盘、看山星/向星、零正、门位/床位落宫。',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ 八宅 + 九宫格
            _card(
              title: zhTW ? '室內吉凶九宮（八宅+流年飛星提示）' : '室内吉凶九宫（八宅+流年飞星提示）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (zhTW ? '依據大門方位推斷：' : '依据大门方位推断：') +
                        (eightResult.group == EightHouseGroup.east
                            ? (zhTW ? '東四宅' : '东四宅')
                            : (zhTW ? '西四宅' : '西四宅')),
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
                      useTraditional: zhTW,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    zhTW
                        ? '說明：請將戶型圖對正北後，對應本九宮格即可。吉位可放主臥、書房、老闆位；凶位可做倉庫、衛生間。'
                        : '说明：请将户型图对正北后，对应本九宫格即可。吉位可放主卧、书房、老板位；凶位可做仓库、卫生间。',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),

            // 流年选择
            _card(
              title: zhTW ? '選擇流年' : '选择流年',
              child: Row(
                children: [
                  Text(
                    zhTW ? '流年：' : '流年：',
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    dropdownColor: Colors.grey.shade900,
                    value: _selectedYear,
                    style: const TextStyle(color: Colors.white),
                    items: _yearData.keys.map((year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(zhTW ? '$year 年' : '$year 年'),
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
                title: zhTW
                    ? '$_selectedYear 年流年煞位（24 山精確匹配）'
                    : '$_selectedYear 年流年煞位（24 山精确匹配）',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(
                      zhTW ? '五黃位' : '五黄位',
                      _namesFromIndex(currentYearInfo.wuHuang),
                      useTraditional: zhTW,
                    ),
                    _line(
                      zhTW ? '二黑病符' : '二黑病符',
                      _namesFromIndex(currentYearInfo.erHei),
                      useTraditional: zhTW,
                    ),
                    _line(
                      zhTW ? '太歲位' : '太岁位',
                      _namesFromIndex(currentYearInfo.taiSui),
                      useTraditional: zhTW,
                    ),
                    _line(
                      zhTW ? '三煞位' : '三煞位',
                      _namesFromIndex(currentYearInfo.sanSha),
                      useTraditional: zhTW,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      currentYearInfo.note(zhTW),
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
                      useTraditional: zhTW,
                    ),
                  ],
                ),
              ),

            // 九运时间表
            _card(
              title: zhTW ? '三元九運時間表' : '三元九运时间表',
              child: Text(
                zhTW
                    ? '1 運：1864 - 1883\n'
                          '2 運：1884 - 1903\n'
                          '3 運：1904 - 1923\n'
                          '4 運：1924 - 1943\n'
                          '5 運：1944 - 1963\n'
                          '6 運：1964 - 1983\n'
                          '7 運：1984 - 2003\n'
                          '8 運：2004 - 2023\n'
                          '9 運：2024 - 2043  ← 當前'
                    : '1 运：1864 - 1883\n'
                          '2 运：1884 - 1903\n'
                          '3 运：1904 - 1923\n'
                          '4 运：1924 - 1943\n'
                          '5 运：1944 - 1963\n'
                          '6 运：1964 - 1983\n'
                          '7 运：1984 - 2003\n'
                          '8 运：2004 - 2023\n'
                          '9 运：2024 - 2043  ← 当前',
                style: const TextStyle(fontSize: 13, height: 1.35),
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
    required bool useTraditional,
  }) {
    // 1~9 宫位的名字（先放八宅，后面叠流年）
    final Map<int, String> palaceName = {
      1: eightResult.palaceName(1),
      2: eightResult.palaceName(2),
      3: eightResult.palaceName(3),
      4: eightResult.palaceName(4),
      5: useTraditional ? '中宮' : '中宫',
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
        palaceBad.putIfAbsent(p, () => []).add(useTraditional ? '五黃' : '五黄');
      }
      // 二黑
      for (final idx in yearData.erHei) {
        final p = _map24ToPalace(idx);
        palaceBad.putIfAbsent(p, () => []).add(useTraditional ? '二黑' : '二黑');
      }
      // 太岁
      for (final idx in yearData.taiSui) {
        final p = _map24ToPalace(idx);
        palaceBad.putIfAbsent(p, () => []).add(useTraditional ? '太歲' : '太岁');
      }
      // 三煞
      for (final idx in yearData.sanSha) {
        final p = _map24ToPalace(idx);
        palaceBad.putIfAbsent(p, () => []).add(useTraditional ? '三煞' : '三煞');
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
                          useTraditional ? '宮$p' : '宫$p',
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

  EightHouseResult _calcEightHouseByDoor(String doorDir, bool zhTW) {
    // doorDir 可能是 正东 / 東南 / 东南 / 正南 ... 要兼容简/繁
    final hasEastLike =
        doorDir.contains('东') ||
        doorDir.contains('東') ||
        doorDir.contains('南') ||
        doorDir.contains('北');

    if (hasEastLike) {
      return EightHouseResult.eastGroup(zhTW: zhTW);
    } else {
      return EightHouseResult.westGroup(zhTW: zhTW);
    }
  }

  // ========== 其它工具 ==========

  int _guessPeriodByMoveIn(int moveInYear) {
    if (moveInYear >= 2024) return 9;
    if (moveInYear >= 2004) return 8;
    return 7;
  }

  String _buildCurrentYunText(int period, bool zhTW) {
    switch (period) {
      case 9:
        return zhTW ? '當前運：下元 · 九運（2024 - 2043）' : '当前运：下元 · 九运（2024 - 2043）';
      case 8:
        return zhTW ? '當前運：下元 · 八運（2004 - 2023）' : '当前运：下元 · 八运（2004 - 2023）';
      case 7:
        return zhTW ? '當前運：下元 · 七運（1984 - 2003）' : '当前运：下元 · 七运（1984 - 2003）';
      default:
        return zhTW ? '當前運：待定' : '当前运：待定';
    }
  }

  String _namesFromIndex(List<int> idxs) {
    return idxs.map((i) => _mountain24[i]).join(' / ');
  }

  Widget _build24MatchResult({
    required _Year24Data yearInfo,
    required int facingIdx,
    required int sittingIdx,
    required bool useTraditional,
  }) {
    final bool faceHit = _isHitAny(yearInfo.allBadIndexes, facingIdx);
    final bool sitHit = _isHitAny(yearInfo.allBadIndexes, sittingIdx);

    if (!faceHit && !sitHit) {
      return Text(
        useTraditional
            ? '✅ 當前量到的向 / 坐沒有貼著本年的五黃 / 二黑 / 太歲 / 三煞，可正常參考九運佈局。'
            : '✅ 当前量到的向/坐没有贴着本年的五黄/二黑/太岁/三煞，可正常参考九运布局。',
        style: const TextStyle(fontSize: 12.5, color: Colors.greenAccent),
      );
    }

    final List<String> warns = [];
    if (faceHit) {
      warns.add(
        useTraditional
            ? '⚠ 「向」落在本年重點位上，請不要在這個方向開門、動土或放水。'
            : '⚠ “向”落在本年重点位上，请不要在这个方向开门、动土或放水。',
      );
    }
    if (sitHit) {
      warns.add(
        useTraditional
            ? '⚠ 「坐」落在本年重點位上，床 / 沙發 / 辦公位盡量別正頂著這裡，可微調 15°。'
            : '⚠ “坐”落在本年重点位上，床/沙发/办公位尽量别正顶着这里，可微调 15°。',
      );
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
    if (idx24 <= 2) return 1; // 北
    if (idx24 <= 5) return 8; // 东北
    if (idx24 <= 8) return 3; // 东
    if (idx24 <= 11) return 4; // 东南
    if (idx24 <= 14) return 9; // 南
    if (idx24 <= 17) return 2; // 西南
    if (idx24 <= 20) return 7; // 西
    return 6; // 西北
  }

  // 把简体四种格局翻成繁体
  String _patternTitleLocalized(FengshuiPattern p, bool zhTW) {
    final cn = fengshuiPatternText(p);
    if (!zhTW) return cn;
    switch (p) {
      case FengshuiPattern.wangCaiWangDing:
        return '【旺財旺丁】';
      case FengshuiPattern.wangCaiBuWangDing:
        return '【旺財不旺丁】';
      case FengshuiPattern.wangDingBuWangCai:
        return '【旺丁不旺財】';
      case FengshuiPattern.sunCaiSunDing:
        return '【損財損丁】';
    }
  }

  String _patternDescLocalized(FengshuiPattern p, bool zhTW) {
    final cn = fengshuiPatternRecommend(p);
    if (!zhTW) return cn;
    // 這裡我簡單做一點替換，保持語氣
    return cn
        .replaceAll('财', '財')
        .replaceAll('丁', '丁')
        .replaceAll('门', '門')
        .replaceAll('户型', '戶型')
        .replaceAll('布局', '佈局')
        .replaceAll('煞', '煞');
  }
}

// ====== 数据结构们 ======

class _Year24Data {
  final List<int> wuHuang;
  final List<int> erHei;
  final List<int> taiSui;
  final List<int> sanSha;
  final String noteCN;
  final String noteTW;

  _Year24Data({
    required this.wuHuang,
    required this.erHei,
    required this.taiSui,
    required this.sanSha,
    required this.noteCN,
    required this.noteTW,
  });

  List<int> get allBadIndexes => [...wuHuang, ...erHei, ...taiSui, ...sanSha];

  String note(bool zhTW) => zhTW ? noteTW : noteCN;
}

class _line extends StatelessWidget {
  final String label;
  final String value;
  final bool useTraditional;
  const _line(this.label, this.value, {super.key, this.useTraditional = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  factory EightHouseResult.eastGroup({bool zhTW = false}) {
    // 东四：坎、离、震、巽 → 生气、天医、延年、伏位
    return EightHouseResult(
      group: EightHouseGroup.east,
      palaceNames: zhTW
          ? {
              1: '伏位',
              2: '六煞',
              3: '生氣',
              4: '天醫',
              5: '中宮',
              6: '五鬼',
              7: '禍害',
              8: '延年',
              9: '絕命',
            }
          : {
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

  factory EightHouseResult.westGroup({bool zhTW = false}) {
    // 西四：乾、兑、艮、坤
    return EightHouseResult(
      group: EightHouseGroup.west,
      palaceNames: zhTW
          ? {
              1: '禍害',
              2: '天醫',
              3: '五鬼',
              4: '六煞',
              5: '中宮',
              6: '延年',
              7: '伏位',
              8: '絕命',
              9: '生氣',
            }
          : {
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
