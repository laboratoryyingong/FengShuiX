import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fengshui_compass/models/cheat_mode.dart';

class HelpPage extends StatefulWidget {
  final CheatMode cheatMode;
  final VoidCallback? onCycleCheatMode;

  const HelpPage({super.key, required this.cheatMode, this.onCycleCheatMode});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  int _tapCount = 0;

  void _onTitleTap() {
    // 连点计数
    _tapCount += 1;

    if (_tapCount >= 10) {
      // 触发切换
      widget.onCycleCheatMode?.call();

      // 给你一个很轻的提示；要是你真的想 100% 隐藏，就把这几行删掉
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已切换分析模式：${_cheatModeShort(widget.cheatMode)}'),
          duration: const Duration(seconds: 1),
        ),
      );

      // 重置计数
      _tapCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cheatText = _cheatModeShort(widget.cheatMode);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _onTitleTap,
              child: const Text(
                '使用方法',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 14),

            // 1. 罗盘基本使用
            _sectionTitle('1. 罗盘基本使用'),
            _p('（1）打开应用后，先把手机放平，慢慢旋转，让罗盘指向要测的方向。'),
            _p('（2）尽量远离磁场干扰：音响、路由器、电梯、车库电机、金属柜子都会让电子罗盘偏转。'),
            _p('（3）右上角会显示“准确度”，如果是“普通”或“错误”，请按提示做几次“8 字晃动/∞ 晃动”来重新校正磁感应。'),
            _p('（4）量大门：人站在门内，手机顶部指向大门外的方向，保持 2~3 秒让角度稳定，再进入分析页。'),

            const SizedBox(height: 14),

            // 2. 分析页
            _sectionTitle('2. 分析页（三元九运 + 八宅 + 流年飞星）'),
            _p('（1）进入“分析”之前，先量一次大门，应用会把这次量到的方位当作大门方位使用。'),
            _p('（2）请选择实际的入住年份：2004-2023 会按八运分析，2024-2043 会按九运分析。'),
            _p(
              '（3）分析页会给出四种风水格局之一：'
              '【旺财旺丁】、【旺财不旺丁】、【旺丁不旺财】、【损财损丁】，这是一个简化版的“坐向+当运”判断，用来快速看大方向。',
            ),
            _p('（4）分析页的九宫格会同时参考“八宅吉凶”与“当年流年煞位”，可以用来安排房间、床位、书房、收银台和不常用空间。'),

            const SizedBox(height: 14),

            // 3. 室内九宫
            _sectionTitle('3. 室内九宫怎么对房子'),
            _p('（1）先把你的户型图/草图“对正北”。手机罗盘指向北，你的户型图的上方也当作北。'),
            _p(
              '（2）把房子划成 3×3 九宫，分析页里的九宫格就可以一一对上：上排是北/东北一带，中排是中宫，底排是南/西南一带（以你的映射为准）。',
            ),
            _p('（3）绿色或标记为“生气、天医、延年、伏位”的宫，可以放主卧、书房、老板位、收银台、儿童房。'),
            _p('（4）红色或标记为“五鬼、六煞、绝命、祸害”的宫，可以做杂物、储物间、卫生间、动线或低使用率房间。'),
            _p('（5）如果同一宫位又是当年的五黄、二黑、太岁或三煞，请优先听流年的提示，不要在那个宫动土或放大水。'),

            const SizedBox(height: 14),

            // 4. 锦囊
            _sectionTitle('4. “锦囊”怎么配合分析页'),
            _p('（1）先看分析页今年的流年结果：五黄位、二黑病符位、太岁位、三煞位。'),
            _p(
              '（2）再到“锦囊”页里选对应的做法：招财类 → 财位 / 明堂；化煞类 → 门口冲、见天斩、对厕所；'
              '文昌类 → 书房、孩子房、流年文昌位；流年化解类 → 五黄、二黑、太岁、三煞对应放金属、葫芦、镇物等。',
            ),
            _p('（3）要特别注意：卧室、床头、神位附近不要随便放水、不要放太“动”的东西。'),

            const SizedBox(height: 18),

            // 5. 联络大师
            _sectionTitle('5. 联络大师'),
            _p('如果你需要：现场户型图判断、要看外局形峦、水口、楼层差，或者要按个人年命/生肖做更精细的布局，可以直接联系大师。'),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.email_outlined),
                label: const Text('发邮件给大师'),
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
                      'subject': '风水罗盘咨询',
                      'body': '大师您好，我想咨询下面的问题：\n\n1.\n2.\n',
                    },
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    // 万一没有邮件客户端
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('无法打开邮件应用，请检查设备邮箱设置')),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 18),

            // 6. 免责声明
            _sectionTitle('免责声明'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '本应用所提供的罗盘度数、三元九运分析、八宅吉凶、流年飞星位置及相关摆设建议，仅供学习、参考与一般性风水规划示意使用，'
                '不构成正式、完整或针对个案的专业风水勘察意见。\n'
                '实际风水判断需综合：坐向精准实测、屋外形峦、水口走向、楼层高低、宅命（年命）、户型开口位置、动静分区与当年流年等多个因素，'
                '并需现场勘查后才能下最终结论。本应用因装置磁场干扰、使用方法不当或用户自行修改数据等原因造成的偏差，开发者概不负责。\n'
                '若用于商业、工程或高敏感场域，请务必咨询合格的专业人士后再行施工或摆设。',
                style: TextStyle(
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

  String _cheatModeShort(CheatMode mode) {
    switch (mode) {
      case CheatMode.off:
        return '正常';
      case CheatMode.wangCaiWangDing:
        return '固定旺财旺丁';
      case CheatMode.wangCaiBuWangDing:
        return '固定旺财不旺丁';
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
