import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_open_chinese_convert/flutter_open_chinese_convert.dart';

import 'pages/compass_page.dart';
import 'pages/tips_page.dart';
import 'pages/analysis_page.dart';
import 'pages/help_page.dart';
import 'package:fengshui_compass/models/cheat_mode.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const FengshuiApp());
}

class FengshuiApp extends StatefulWidget {
  const FengshuiApp({super.key});

  // 全局 analytics 实例（你原来就这样写的）
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  State<FengshuiApp> createState() => _FengshuiAppState();
}

class _FengshuiAppState extends State<FengshuiApp> {
  // ← 在 state 里建一个 observer，这样只建一次
  late final FirebaseAnalyticsObserver _observer = FirebaseAnalyticsObserver(
    analytics: FengshuiApp.analytics,
  );

  /// true = 用繁體（S2TW）
  bool _useTraditional = false;

  /// 简 → 繁 的本地缓存
  final Map<String, String> _convertCache = {};

  void _toggleLang() {
    setState(() {
      _useTraditional = !_useTraditional;
    });
  }

  Future<String> _tr(String text) async {
    if (!_useTraditional) return text;

    if (_convertCache.containsKey(text)) {
      return _convertCache[text]!;
    }

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

      // ✅ 这里用我们刚刚建好的 observer
      navigatorObservers: [_observer],

      home: RootTabs(
        onToggleLang: _toggleLang,
        useTraditional: _useTraditional,
        tr: _tr,
      ),

      builder: (context, child) {
        Widget body = MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.5),
          child: child!,
        );

        body = Localizations.override(
          context: context,
          locale: currentLocale,
          child: body,
        );

        return body;
      },

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
  final Future<String> Function(String text) tr;

  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> {
  int _currentIndex = 0;
  CheatMode _cheatMode = CheatMode.off;

  double _currentHeadingDeg = 0;
  double _currentSouthDeg = 180;
  String _currentFacingText = '';
  String _currentSittingText = '';
  int _currentNorthIndex24 = 1;
  int _currentSouthIndex24 = 13;

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
    String t(String zhCN, String zhTW) => widget.useTraditional ? zhTW : zhCN;

    final pages = [
      CompassPage(
        onHeadingChanged: _onHeadingFromCompass,
        useTraditional: widget.useTraditional,
        tr: widget.tr,
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
        useTraditional: widget.useTraditional,
        tr: widget.tr,
      ),
      HelpPage(
        cheatMode: _cheatMode,
        onCycleCheatMode: _cycleCheatMode,
        useTraditional: widget.useTraditional,
        tr: widget.tr,
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
    // 这里你原来写死了 false，我先给你保留原样
    final bool useTraditional = false;

    final doorOptions = useTraditional
        ? ['正北', '東北', '正東', '東南', '正南', '西南', '正西', '西北']
        : ['正北', '东北', '正东', '东南', '正南', '西南', '正西', '西北'];

    final industries = useTraditional
        ? ['住宅/自住', '建築/工程/裝修', '零售/餐飲/店面', '教育/培訓', '金融/投資', '工廠/倉儲', '其他']
        : ['住宅/自住', '建筑/工程/装修', '零售/餐饮/店面', '教育/培训', '金融/投资', '工厂/仓储', '其他'];

    final String doorFromCompass = _to8Dir(_currentHeadingDeg, useTraditional);

    String doorDir = _selectedDoorDir.isNotEmpty
        ? _selectedDoorDir
        : doorFromCompass;
    int moveInYear = _selectedMoveInYear;
    String industry = _selectedIndustry;

    if (!doorOptions.contains(doorDir)) {
      doorDir = '';
    }
    if (!industries.contains(industry)) {
      industry = '';
    }

    final years = List<int>.generate(40, (i) => 2025 - i);

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
                  const SizedBox(height: 184),
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
