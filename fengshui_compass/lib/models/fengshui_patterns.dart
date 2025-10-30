// lib/models/fengshui_patterns.dart

/// 四种风水格局
enum FengshuiPattern {
  wangCaiWangDing, // 旺财旺丁
  wangCaiBuWangDing, // 旺财不旺丁
  wangDingBuWangCai, // 旺丁不旺财
  sunCaiSunDing, // 损财损丁
}

/// 文案标题
String fengshuiPatternText(FengshuiPattern p) {
  switch (p) {
    case FengshuiPattern.wangCaiWangDing:
      return '【旺财旺丁】';
    case FengshuiPattern.wangCaiBuWangDing:
      return '【旺财不旺丁】';
    case FengshuiPattern.wangDingBuWangCai:
      return '【旺丁不旺财】';
    case FengshuiPattern.sunCaiSunDing:
      return '【损财损丁】';
  }
}

/// 推荐说明
String fengshuiPatternRecommend(FengshuiPattern p) {
  switch (p) {
    case FengshuiPattern.wangCaiWangDing:
      return '坐星和向星都吃到当运的气，财路、人气、家人状态都容易上来；保持门口整洁、适当做点光火、避开流年五黄/二黑即可。可作为住宅或店面核心。';
    case FengshuiPattern.wangCaiBuWangDing:
      return '向得令、山不够：来钱、业务、客流有势，但家人健康/学习要多关照。建议在山位/床位/靠山位置做实体靠山或五行补丁，并避免病符位动土。';
    case FengshuiPattern.wangDingBuWangCai:
      return '山得令、向不够：人丁、人和、稳定性好，但赚钱可能慢。建议把“动的、亮的、水的、客户入口”放在当运向位或流年吉方，增加财星发动。';
    case FengshuiPattern.sunCaiSunDing:
      return '坐向都没吃到当运之气，建议先做流年化解（五黄、二黑、太岁、三煞），再考虑调整大门/动线到当运方向，必要时重做布局。';
  }
}

/// 主计算函数
FengshuiPattern calcFengshuiPattern({
  required int period, // 7 / 8 / 9
  required int facing24Index, // 向：0~23
  required int sitting24Index, // 坐：0~23
  String? doorDirection8, // 正东/正南/... 可选
}) {
  final rule = _periodRule(period);

  final bool facingIsWang = _match24(facing24Index, rule.wangFacing24Indexes);
  final bool sittingIsWang = _match24(
    sitting24Index,
    rule.wangSitting24Indexes,
  );

  bool doorHelpsCai = false;
  if (doorDirection8 != null && doorDirection8.isNotEmpty) {
    doorHelpsCai = _doorHelpsThisPeriod(doorDirection8, period);
  }

  final bool finalCai = facingIsWang || doorHelpsCai;
  final bool finalDing = sittingIsWang;

  if (finalCai && finalDing) {
    return FengshuiPattern.wangCaiWangDing;
  } else if (finalCai && !finalDing) {
    return FengshuiPattern.wangCaiBuWangDing;
  } else if (!finalCai && finalDing) {
    return FengshuiPattern.wangDingBuWangCai;
  } else {
    return FengshuiPattern.sunCaiSunDing;
  }
}

class _PeriodRule {
  final List<int> wangFacing24Indexes;
  final List<int> wangSitting24Indexes;
  const _PeriodRule({
    required this.wangFacing24Indexes,
    required this.wangSitting24Indexes,
  });
}

/// period → 对应运的旺向/旺山
_PeriodRule _periodRule(int period) {
  // 9 运：离 → 南
  if (period == 9) {
    final facing = <int>[11, 12, 13, 14, 15]; // 巳 丙 午 丁 未
    final sitting = <int>[4, 15, 16, 17]; // 艮 未 坤 申
    return _PeriodRule(
      wangFacing24Indexes: facing,
      wangSitting24Indexes: sitting,
    );
  }

  // 8 运：艮 → 东北
  if (period == 8) {
    final facing = <int>[4, 5, 6, 16]; // 艮 寅 甲 坤(给点)
    final sitting = <int>[4, 15, 16]; // 艮 未 坤
    return _PeriodRule(
      wangFacing24Indexes: facing,
      wangSitting24Indexes: sitting,
    );
  }

  // 7 运：兑 → 西
  if (period == 7) {
    final facing = <int>[18, 19, 20, 21]; // 庚 酉 辛 戌
    final sitting = <int>[18, 19, 20];
    return _PeriodRule(
      wangFacing24Indexes: facing,
      wangSitting24Indexes: sitting,
    );
  }

  return const _PeriodRule(wangFacing24Indexes: [], wangSitting24Indexes: []);
}

/// 允许 ±1 山的容差
bool _match24(int idx, List<int> targets) {
  for (final t in targets) {
    if (_sameOrNeighbor(idx, t)) return true;
  }
  return false;
}

bool _sameOrNeighbor(int a, int b) {
  if (a == b) return true;
  if ((a - b).abs() == 1) return true;
  if ((a == 0 && b == 23) || (a == 23 && b == 0)) return true;
  return false;
}

/// 大门方位对财的加权
bool _doorHelpsThisPeriod(String doorDir, int period) {
  if (period == 9) {
    // 南、东南、西南都给点
    return doorDir.contains('南');
  }
  if (period == 8) {
    return (doorDir.contains('东') && doorDir.contains('北')) ||
        doorDir.contains('西南'); // 东北 or 西南
  }
  if (period == 7) {
    return doorDir.contains('西') || doorDir.contains('西北');
  }
  return false;
}
