import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_open_chinese_convert/flutter_open_chinese_convert.dart';

import 'pages/compass_page.dart';
import 'pages/tips_page.dart';
import 'pages/analysis_page.dart';
import 'pages/help_page.dart';
import 'package:fengshui_compass/models/cheat_mode.dart';

Future<void> main() async {
  // 有些时候要先确保 binding 初始化
  WidgetsFlutterBinding.ensureInitialized();
  // 这个包不需要全局 init，但提早 binding 是好的
  runApp(const FengshuiApp());
}

class FengshuiApp extends StatefulWidget {
  const FengshuiApp({super.key});

  @override
  State<FengshuiApp> createState() => _FengshuiAppState();
}

class _FengshuiAppState extends State<FengshuiApp> {
  /// true = 用繁體（S2TW）
  bool _useTraditional = false;

  /// 简 → 繁 的本地缓存，防止同一句话每次都转
  final Map<String, String> _convertCache = {};

  void _toggleLang() {
    setState(() {
      _useTraditional = !_useTraditional;
    });
  }

  /// 自动简转繁（用 flutter_open_chinese_convert）
  /// 用法：await _tr("风水罗盘")
  Future<String> _tr(String text) async {
    // 不用繁体就直接返回
    if (!_useTraditional) return text;

    // 先查缓存
    if (_convertCache.containsKey(text)) {
      return _convertCache[text]!;
    }

    // 用 S2TW（简体 → 台湾繁体）你也可以换成 S2T / S2HK / S2TWp
    final converted = await ChineseConverter.convert(text, S2TW());
    _convertCache[text] = converted;
    return converted;
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = _useTraditional
        ? const Locale('zh', 'TW')
        : const Locale('zh', 'CN');

    return MaterialApp(
      title: _useTraditional ? '風水X' : '风水X',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      debugShowCheckedModeBanner: false,

      // 把开关和转换函数往下传
      home: RootTabs(
        onToggleLang: _toggleLang,
        useTraditional: _useTraditional,
        tr: _tr,
      ),

      builder: (context, child) {
        // 全局放大
        Widget body = MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.5),
          child: child!,
        );

        // 强制用 zh_TW / zh_CN（路线 C）
        body = Localizations.override(
          context: context,
          locale: currentLocale,
          child: body,
        );

        return body;
      },

      // 本地化
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('zh', 'TW'),
        Locale('zh', 'HK'),
        Locale('en'),
      ],
    );
  }
}

class RootTabs extends StatefulWidget {
  const RootTabs({
    super.key,
    required this.onToggleLang,
    required this.useTraditional,
    required this.tr,
  });

  final VoidCallback onToggleLang;
  final bool useTraditional;
  // 这是上面传下来的自动转换函数（async）
  final Future<String> Function(String text) tr;

  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> {
  int _currentIndex = 0;
  CheatMode _cheatMode = CheatMode.off;

  // 罗盘实时数据（保持你原来的）
  double _currentHeadingDeg = 0;
  double _currentSouthDeg = 180;
  String _currentFacingText = '';
  String _currentSittingText = '';
  int _currentNorthIndex24 = 1;
  int _currentSouthIndex24 = 13;

  // 分析弹窗选的
  String _selectedDoorDir = '';
  int _selectedMoveInYear = 2025;
  String _selectedIndustry = '';

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
    // ① 先来个同步的，用于我们已经知道繁体怎么写的情况
    String t(String zhCN, String zhTW) => widget.useTraditional ? zhTW : zhCN;

    // ② 下面四个页面
    final pages = [
      CompassPage(
        onHeadingChanged: _onHeadingFromCompass,
        useTraditional: widget.useTraditional,
        tr: widget.tr, // 如果你想把 async 转换也带下来
      ),
      TipsPage(useTraditional: widget.useTraditional, tr: widget.tr),
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
        useTraditional: widget.useTraditional, // ← 新增
        tr: widget.tr, // ← 如果你 main 里有转函数的话
      ),
      HelpPage(
        cheatMode: _cheatMode,
        onCycleCheatMode: _cycleCheatMode,
        useTraditional: widget.useTraditional,
        tr: widget.tr, // 要是你想用 async 转的也可以传
      ),
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
          if (i == 2) {
            final ok = await _showAnalysisPrompt(context);
            if (!ok) return;
          }
          setState(() {
            _currentIndex = i;
          });
        },
        // 这里我们用“同步”的繁体（写死的），因为 BottomNavigationBar 不适合等 Future
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: t('罗盘', '羅盤'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.lightbulb_outline),
            label: t('锦囊', '錦囊'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics_outlined),
            label: t('分析', '分析'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.info_outline),
            label: t('说明', '說明'),
          ),
        ],
      ),

      // 右下角切换 简 / 繁
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: widget.onToggleLang,
        child: Text(
          widget.useTraditional ? '简' : '繁',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<bool> _showAnalysisPrompt(BuildContext context) async {
    // 假设你在 RootTabs 里已经有这个开关
    final bool useTraditional = false; // ← 如果你有 _useTraditional 就用那个

    // 1. 根据当前语言准备下拉选项
    final doorOptions = useTraditional
        ? ['正北', '東北', '正東', '東南', '正南', '西南', '正西', '西北']
        : ['正北', '东北', '正东', '东南', '正南', '西南', '正西', '西北'];

    final industries = useTraditional
        ? ['住宅/自住', '建築/工程/裝修', '零售/餐飲/店面', '教育/培訓', '金融/投資', '工廠/倉儲', '其他']
        : ['住宅/自住', '建筑/工程/装修', '零售/餐饮/店面', '教育/培训', '金融/投资', '工厂/仓储', '其他'];

    // 用当前罗盘方位自动生成一个 8 方位作为默认大门
    final String doorFromCompass = _to8Dir(_currentHeadingDeg, useTraditional);

    // 2. 取你之前存的值
    String doorDir = _selectedDoorDir.isNotEmpty
        ? _selectedDoorDir
        : doorFromCompass;
    int moveInYear = _selectedMoveInYear;
    String industry = _selectedIndustry;

    // 3. 【关键】如果之前存的是简体，现在切成繁体，items 里找不到，就置空
    if (!doorOptions.contains(doorDir)) {
      doorDir = '';
    }
    if (!industries.contains(industry)) {
      industry = '';
    }

    final years = List<int>.generate(40, (i) => 2025 - i); // 2025~1986

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
                  Text(
                    useTraditional
                        ? '请选择相应的大门方位、入住年份及行业后再查看分析'
                        : '請選擇相應的大門方位、入住年份及行業後再查看分析',
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    useTraditional
                        ? '提示：进入分析前，请把手机正对大门量一次，系统会自动把当前罗盘方位当成大门方位。'
                        : '提示：進入分析前，請把手機正對大門量一次，系統會自動把當前羅盤方位當成大門方位。',
                    style: const TextStyle(
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
                      useTraditional ? '大門方位' : '大门方位',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.grey.shade900,
                    // 【关键】只在包含时才给 value
                    value: doorOptions.contains(doorDir) ? doorDir : null,
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
                      useTraditional ? '入住年份' : '入住年份',
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
                      useTraditional ? '行業' : '行业',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.grey.shade900,
                    // 【关键】这里也要这样
                    value: industries.contains(industry) ? industry : null,
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
                          child: Text(useTraditional ? '取消' : '取消'),
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
                                SnackBar(
                                  content: Text(
                                    useTraditional
                                        ? '请先选择大门方位和入住年份'
                                        : '請先選擇大門方位和入住年份',
                                  ),
                                  duration: const Duration(seconds: 1),
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
                          child: Text(useTraditional ? '确定' : '確定'),
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

    if (result == true) {
      setState(() {
        _selectedDoorDir = doorDir;
        _selectedMoveInYear = moveInYear;
        _selectedIndustry = industry;
      });
    }

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

  String _to8Dir(double deg, bool useTraditional) {
    final dirs = useTraditional
        ? ['正北', '東北', '正東', '東南', '正南', '西南', '正西', '西北']
        : ['正北', '东北', '正东', '东南', '正南', '西南', '正西', '西北'];
    int idx = ((deg + 22.5) / 45).floor() % 8;
    return dirs[idx];
  }
}
