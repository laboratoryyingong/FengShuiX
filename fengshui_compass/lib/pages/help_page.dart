import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fengshui_compass/models/cheat_mode.dart';

class HelpPage extends StatefulWidget {
  final CheatMode cheatMode;
  final VoidCallback? onCycleCheatMode;

  /// 新增：跟全局保持一致
  final bool useTraditional;

  /// 如果你想要这里也能用你 main 里那个 async 转换，就传这个（可选）
  final Future<String> Function(String text)? tr;

  const HelpPage({
    super.key,
    required this.cheatMode,
    this.onCycleCheatMode,
    this.useTraditional = false,
    this.tr,
  });

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  int _tapCount = 0;

  void _onTitleTap() {
    _tapCount += 1;

    if (_tapCount >= 10) {
      widget.onCycleCheatMode?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.useTraditional
                ? '已切換分析模式：${_cheatModeShort(widget.cheatMode, true)}'
                : '已切换分析模式：${_cheatModeShort(widget.cheatMode, false)}',
          ),
          duration: const Duration(seconds: 1),
        ),
      );

      _tapCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool zhTW = widget.useTraditional;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _onTitleTap,
              child: Text(
                zhTW ? '使用方法' : '使用方法',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // 1. 罗盘基本使用
            _sectionTitle(zhTW ? '1. 羅盤基本使用' : '1. 罗盘基本使用'),
            _p(
              zhTW
                  ? '（1）打開應用後，先把手機放平，慢慢旋轉，讓羅盤指向要測的方向。'
                  : '（1）打开应用后，先把手机放平，慢慢旋转，让罗盘指向要测的方向。',
            ),
            _p(
              zhTW
                  ? '（2）盡量遠離磁場干擾：音響、路由器、電梯、車庫電機、金屬櫃子都會讓電子羅盤偏轉。'
                  : '（2）尽量远离磁场干扰：音响、路由器、电梯、车库电机、金属柜子都会让电子罗盘偏转。',
            ),
            _p(
              zhTW
                  ? '（3）右上角會顯示「準確度」，如果是「普通」或「錯誤」，請按提示做幾次「8 字晃動 / ∞ 晃動」來重新校正磁感應。'
                  : '（3）右上角会显示“准确度”，如果是“普通”或“错误”，请按提示做几次“8 字晃动/∞ 晃动”来重新校正磁感应。',
            ),
            _p(
              zhTW
                  ? '（4）量大門：人站在門內，手機頂部指向大門外的方向，保持 2~3 秒讓角度穩定，再進入分析頁。'
                  : '（4）量大门：人站在门内，手机顶部指向大门外的方向，保持 2~3 秒让角度稳定，再进入分析页。',
            ),

            const SizedBox(height: 14),

            // 2. 分析页
            _sectionTitle(
              zhTW ? '2. 分析頁（三元九運 + 八宅 + 流年飛星）' : '2. 分析页（三元九运 + 八宅 + 流年飞星）',
            ),
            _p(
              zhTW
                  ? '（1）進入「分析」之前，先量一次大門，應用會把這次量到的方位當作大門方位使用。'
                  : '（1）进入“分析”之前，先量一次大门，应用会把这次量到的方位当作大门方位使用。',
            ),
            _p(
              zhTW
                  ? '（2）請選擇實際的入住年份：2004-2023 會按八運分析，2024-2043 會按九運分析。'
                  : '（2）请选择实际的入住年份：2004-2023 会按八运分析，2024-2043 会按九运分析。',
            ),
            _p(
              zhTW
                  ? '（3）分析頁會給出四種風水格局之一：【旺財旺丁】、【旺財不旺丁】、【旺丁不旺財】、【損財損丁】，這是一個簡化版的「坐向 + 當運」判斷，用來快速看大方向。'
                  : '（3）分析页会给出四种风水格局之一：【旺财旺丁】、【旺财不旺丁】、【旺丁不旺财】、【损财损丁】，这是一个简化版的“坐向+当运”判断，用来快速看大方向。',
            ),
            _p(
              zhTW
                  ? '（4）分析頁的九宮格會同時參考「八宅吉凶」與「當年流年煞位」，可以用來安排房間、床位、書房、收銀台和不常用空間。'
                  : '（4）分析页的九宫格会同时参考“八宅吉凶”与“当年流年煞位”，可以用来安排房间、床位、书房、收银台和不常用空间。',
            ),

            const SizedBox(height: 14),

            // 3. 室内九宫
            _sectionTitle(zhTW ? '3. 室內九宮怎麼對房子' : '3. 室内九宫怎么对房子'),
            _p(
              zhTW
                  ? '（1）先把你的戶型圖 / 草圖「對正北」。手機羅盤指向北，你的戶型圖的上方也當作北。'
                  : '（1）先把你的户型图/草图“对正北”。手机罗盘指向北，你的户型图的上方也当作北。',
            ),
            _p(
              zhTW
                  ? '（2）把房子劃成 3×3 九宮，分析頁裡的九宮格就可以一一對上：上排是北 / 東北一帶，中排是中宮，底排是南 / 西南一帶（以你的映射為準）。'
                  : '（2）把房子划成 3×3 九宫，分析页里的九宫格就可以一一对上：上排是北/东北一带，中排是中宫，底排是南/西南一带（以你的映射为准）。',
            ),
            _p(
              zhTW
                  ? '（3）綠色或標記為「生氣、天醫、延年、伏位」的宮，可以放主臥、書房、老闆位、收銀台、兒童房。'
                  : '（3）绿色或标记为“生气、天医、延年、伏位”的宫，可以放主卧、书房、老板位、收银台、儿童房。',
            ),
            _p(
              zhTW
                  ? '（4）紅色或標記為「五鬼、六煞、絕命、禍害」的宮，可以做雜物、儲物間、衛生間、動線或低使用率房間。'
                  : '（4）红色或标记为“五鬼、六煞、绝命、祸害”的宫，可以做杂物、储物间、卫生间、动线或低使用率房间。',
            ),
            _p(
              zhTW
                  ? '（5）如果同一宮位又是當年的五黃、二黑、太歲或三煞，請優先聽流年的提示，不要在那個宮動土或放大水。'
                  : '（5）如果同一宫位又是当年的五黄、二黑、太岁或三煞，请优先听流年的提示，不要在那个宫动土或放大水。',
            ),

            const SizedBox(height: 14),

            // 4. 锦囊
            _sectionTitle(zhTW ? '4. 「錦囊」怎麼配合分析頁' : '4. “锦囊”怎么配合分析页'),
            _p(
              zhTW
                  ? '（1）先看分析頁今年的流年結果：五黃位、二黑病符位、太歲位、三煞位。'
                  : '（1）先看分析页今年的流年结果：五黄位、二黑病符位、太岁位、三煞位。',
            ),
            _p(
              zhTW
                  ? '（2）再到「錦囊」頁裡選對應的做法：招財類 → 財位 / 明堂；化煞類 → 門口沖、見天斬、對廁所；文昌類 → 書房、孩子房、流年文昌位；流年化解類 → 五黃、二黑、太歲、三煞對應放金屬、葫蘆、鎮物等。'
                  : '（2）再到“锦囊”页里选对应的做法：招财类 → 财位 / 明堂；化煞类 → 门口冲、见天斩、对厕所；文昌类 → 书房、孩子房、流年文昌位；流年化解类 → 五黄、二黑、太岁、三煞对应放金属、葫芦、镇物等。',
            ),
            _p(
              zhTW
                  ? '（3）要特別注意：臥室、床頭、神位附近不要隨便放水、不要放太「動」的東西。'
                  : '（3）要特别注意：卧室、床头、神位附近不要随便放水、不要放太“动”的东西。',
            ),

            const SizedBox(height: 18),

            // 5. 联络大师
            _sectionTitle(zhTW ? '5. 聯絡大師' : '5. 联络大师'),
            _p(
              zhTW
                  ? '如果你需要：現場戶型圖判斷、要看外局形巒、水口、樓層差，或者要按個人年命 / 生肖做更精細的佈局，可以直接聯絡大師。'
                  : '如果你需要：现场户型图判断、要看外局形峦、水口、楼层差，或者要按个人年命/生肖做更精细的布局，可以直接联系大师。',
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.email_outlined),
                label: Text(zhTW ? '發郵件給大師' : '发邮件给大师'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  const email = 'max.gong.developer@hotmail.com';
                  final uri = Uri(
                    scheme: 'mailto',
                    path: email,
                    queryParameters: <String, String>{
                      'subject': zhTW ? '風水羅盤諮詢' : '风水罗盘咨询',
                      'body': zhTW
                          ? '大師您好，我想諮詢下面的問題：\n\n1.\n2.\n'
                          : '大师您好，我想咨询下面的问题：\n\n1.\n2.\n',
                    },
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            zhTW ? '無法打開郵件應用，請檢查裝置郵箱設定' : '无法打开邮件应用，请检查设备邮箱设置',
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),

            const SizedBox(height: 18),

            // 6. 免责声明
            _sectionTitle(zhTW ? '免責聲明' : '免责声明'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                zhTW
                    ? '本應用所提供的羅盤度數、三元九運分析、八宅吉凶、流年飛星位置及相關擺設建議，僅供學習、參考與一般性風水規劃示意使用，'
                          '不構成正式、完整或針對個案的專業風水勘察意見。\n'
                          '實際風水判斷需綜合：坐向精準實測、屋外形巒、水口走向、樓層高低、宅命（年命）、戶型開口位置、動靜分區與當年流年等多個因素，'
                          '並需現場勘查後才能下最終結論。本應用因裝置磁場干擾、使用方法不當或用戶自行修改數據等原因造成的偏差，開發者概不負責。\n'
                          '若用於商業、工程或高敏感場域，請務必諮詢合格的專業人士後再行施工或擺設。'
                    : '本应用所提供的罗盘度数、三元九运分析、八宅吉凶、流年飞星位置及相关摆设建议，仅供学习、参考与一般性风水规划示意使用，'
                          '不构成正式、完整或针对个案的专业风水勘察意见。\n'
                          '实际风水判断需综合：坐向精准实测、屋外形峦、水口走向、楼层高低、宅命（年命）、户型开口位置、动静分区与当年流年等多个因素，'
                          '并需现场勘查后才能下最终结论。本应用因装置磁场干扰、使用方法不当或用户自行修改数据等原因造成的偏差，开发者概不负责。\n'
                          '若用于商业、工程或高敏感场域，请务必咨询合格的专业人士后再行施工或摆设。',
                style: const TextStyle(
                  fontSize: 12.2,
                  height: 1.35,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  String _cheatModeShort(CheatMode mode, bool zhTW) {
    switch (mode) {
      case CheatMode.off:
        return zhTW ? '正常' : '正常';
      case CheatMode.wangCaiWangDing:
        return zhTW ? '固定旺財旺丁' : '固定旺财旺丁';
      case CheatMode.wangCaiBuWangDing:
        return zhTW ? '固定旺財不旺丁' : '固定旺财不旺丁';
    }
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.amber,
        ),
      ),
    );
  }

  Widget _p(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontSize: 13.3, height: 1.35)),
    );
  }
}
