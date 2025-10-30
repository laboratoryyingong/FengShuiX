import 'package:flutter/material.dart';
import 'pages/compass_page.dart';
import 'pages/tips_page.dart';
import 'pages/analysis_page.dart';
import 'pages/help_page.dart';
import 'package:fengshui_compass/models/cheat_mode.dart';

void main() {
  runApp(const FengshuiApp());
}

class FengshuiApp extends StatelessWidget {
  const FengshuiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '风水X',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: const RootTabs(),
    );
  }
}

class RootTabs extends StatefulWidget {
  const RootTabs({super.key});

  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> {
  int _currentIndex = 0;
  CheatMode _cheatMode = CheatMode.off; // ← 新的作弊状态

  void _cycleCheatMode() {
    setState(() {
      switch (_cheatMode) {
        case CheatMode.off:
          _cheatMode = CheatMode.wangCaiWangDing;
          break;
        case CheatMode.wangCaiWangDing:
          _cheatMode = CheatMode.wangCaiBuWangDing;
          break;
        case CheatMode.wangCaiBuWangDing:
          _cheatMode = CheatMode.off;
          break;
      }
    });
  }

  // 罗盘实时数据（由 CompassPage 回调上来）
  double _currentHeadingDeg = 0; // 北基准（向）
  double _currentSouthDeg = 180; // 南基准（坐）
  String _currentFacingText = '';
  String _currentSittingText = '';
  int _currentNorthIndex24 = 1; // 子
  int _currentSouthIndex24 = 13; // 午

  // 分析弹窗选的
  String _selectedDoorDir = '';
  int _selectedMoveInYear = 2025;
  String _selectedIndustry = '';

  void _onHeadingFromCompass({
    required double northDeg,
    required double southDeg,
    required String facingText,
    required String sittingText,
    required int northIndex24,
    required int southIndex24,
  }) {
    setState(() {
      _currentHeadingDeg = northDeg;
      _currentSouthDeg = southDeg;
      _currentFacingText = facingText;
      _currentSittingText = sittingText;
      _currentNorthIndex24 = northIndex24;
      _currentSouthIndex24 = southIndex24;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      CompassPage(onHeadingChanged: _onHeadingFromCompass),
      const TipsPage(),
      AnalysisPage(
        currentNorthDeg: _currentHeadingDeg,
        currentSouthDeg: _currentSouthDeg,
        currentFacingText: _currentFacingText,
        currentSittingText: _currentSittingText,
        currentNorthIndex24: _currentNorthIndex24,
        currentSouthIndex24: _currentSouthIndex24,
        doorDirection: _selectedDoorDir,
        moveInYear: _selectedMoveInYear,
        industry: _selectedIndustry,
        cheatMode: _cheatMode,
        onCycleCheatMode: _cycleCheatMode,
      ),
      HelpPage(cheatMode: _cheatMode, onCycleCheatMode: _cycleCheatMode),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (i) async {
          // 如果是“分析”，先弹框
          if (i == 2) {
            final ok = await _showAnalysisPrompt(context);
            if (!ok) return;
          }
          setState(() {
            _currentIndex = i;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: '罗盘'),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: '锦囊',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: '分析',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: '说明'),
        ],
      ),
    );
  }

  Future<bool> _showAnalysisPrompt(BuildContext context) async {
    // 用当前罗盘方位自动生成一个 8 方位作为默认大门
    final String doorFromCompass = _to8Dir(_currentHeadingDeg);

    // 弹窗里的临时变量，优先用用户上次选的，没有就用罗盘的
    String doorDir = _selectedDoorDir.isNotEmpty
        ? _selectedDoorDir
        : doorFromCompass;
    int moveInYear = _selectedMoveInYear;
    String industry = _selectedIndustry;

    final years = List<int>.generate(40, (i) => 2025 - i); // 2025~1986
    final doorOptions = ['正北', '东北', '正东', '东南', '正南', '西南', '正西', '西北'];
    final industries = [
      '住宅/自住',
      '建筑/工程/装修',
      '零售/餐饮/店面',
      '教育/培训',
      '金融/投资',
      '工厂/仓储',
      '其他',
    ];

    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.grey.shade900,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 12,
          ),
          child: StatefulBuilder(
            builder: (ctx, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Text(
                    '请选择相应的大门方位、入住年份及行业后再查看分析',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '提示：进入分析前，请把手机正对大门量一次，系统会自动把当前罗盘方位当成大门方位。',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.white54,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 大门方位
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '大门方位',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.grey.shade900,
                    value: doorDir.isNotEmpty ? doorDir : null,
                    items: doorOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    decoration: _inputDecoration(),
                    onChanged: (v) {
                      setModalState(() {
                        doorDir = v ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // 入住年份
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '入住年份',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<int>(
                    dropdownColor: Colors.grey.shade900,
                    value: moveInYear,
                    items: years
                        .map(
                          (y) => DropdownMenuItem(value: y, child: Text('$y')),
                        )
                        .toList(),
                    decoration: _inputDecoration(),
                    onChanged: (v) {
                      setModalState(() {
                        moveInYear = v ?? moveInYear;
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // 行业
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '行业',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.grey.shade900,
                    value: industry.isNotEmpty ? industry : null,
                    items: industries
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    decoration: _inputDecoration(),
                    onChanged: (v) {
                      setModalState(() {
                        industry = v ?? '';
                      });
                    },
                  ),

                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('取消'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            if (doorDir.isEmpty || moveInYear == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('请先选择大门方位和入住年份'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              _selectedDoorDir = doorDir;
                              _selectedMoveInYear = moveInYear;
                              _selectedIndustry = industry;
                            });
                            Navigator.of(ctx).pop(true);
                          },
                          child: const Text('确定'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
              );
            },
          ),
        );
      },
    );

    return result ?? false;
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.04),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
      ),
    );
  }

  /// 把 0~360° 的北基准转成 8 大方位
  String _to8Dir(double deg) {
    final dirs = ['正北', '东北', '正东', '东南', '正南', '西南', '正西', '西北'];
    int idx = ((deg + 22.5) / 45).floor() % 8;
    return dirs[idx];
  }
}
