import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '使用方法',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),

            // 1. 基本使用
            _sectionTitle('1. 罗盘基本使用'),
            _p(
              '打开应用后，保持手机水平，慢慢旋转，让罗盘指向要测的方向。'
              '建议远离强磁场（音响、路由器、电梯、车库大门电机）以减少干扰。',
            ),
            _p(
              '右上角的“准确度/修正”可以在出现“普通/错误”时做一次8字晃动，让电子罗盘重新校正。',
            ),
            _p(
              '要量大门时，人站在门内、手机指向大门外方向，等角度稳定后再记录。',
            ),

            const SizedBox(height: 14),

            // 2. 分析页使用
            _sectionTitle('2. 分析页（三元九运 + 八宅 + 流年飞星）'),
            _p(
              '底部点“分析”前，请先把手机对着大门量一次，弹窗会自动把当前罗盘方位当作大门方位。',
            ),
            _p(
              '入住年份用来判断是第几运：2004-2023 为八运，2024-2043 为九运；'
              '行业选项用于给出更贴近实际场景的建议。',
            ),
            _p(
              '分析页会显示：①三元九运下的四种风水格局 ②室内九宫（八宅吉凶）③本年流年煞位（五黄、二黑、太岁、三煞）。',
            ),

            const SizedBox(height: 14),

            // 3. 室内九宫怎么用
            _sectionTitle('3. 室内九宫怎么对户型'),
            _p(
              '先把你家的平面图“对正北”（手机罗盘指北，对着图的上方），再按九宫格 3×3 切开。',
            ),
            _p(
              '分析页里标绿色/吉的宫位，可以用来放主卧、书房、老板位、收银台、进门动线；'
              '红色/凶的宫位，可以安排卫生间、储物间、杂物间或不常用的空间。',
            ),
            _p(
              '如果本年“五黄、二黑、太岁、三煞”也落在某个宫位，请优先听流年，不要在该宫动土、开大门或放大水。',
            ),

            const SizedBox(height: 14),

            // 4. 锦囊怎么用
            _sectionTitle('4. “锦囊”怎么用'),
            _p(
              '“锦囊”里分了招财、化煞、文昌、生气、流年化解几大类，可以先看分析页里的当年煞位，再到锦囊里挑对应的做法或摆设。',
            ),
            _p(
              '招财类适合客厅明堂、收银台、店铺门口；化煞类适合门口直冲、见天斩、对厕所；文昌类适合书房、孩子房；'
              '流年类要跟当年五黄/二黑实际位置一起用。',
            ),

            const SizedBox(height: 18),

            // 5. 联络大师
            _sectionTitle('5. 联络大师'),
            _p('如果你想要更精细的排盘、按生日起命卦、或者要看外局形峦，可以直接发邮件给大师。'),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.email_outlined),
                label: const Text('发邮件给大师'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  const email = 'max.gong.developer@hotmail.com';
                  final uri = Uri(
                    scheme: 'mailto',
                    path: email,
                    queryParameters: {
                      'subject': '风水罗盘咨询',
                      'body': '大师您好，我想咨询一下：\n',
                    },
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    // 如果打不开，就给个提示
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('找不到可以发送邮件的应用')),
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
                '本程序所提供之罗盘度数、三元九运分析、八宅吉凶、流年飞星位置及相关摆设建议，仅用于学习、参考与一般性风水规划示意，'
                '不构成专业风水勘察或建筑/室内设计意见。\n'
                '实际风水判断需结合：坐向精准实测、屋外形峦、水口、楼层、宅命（年命）、实际户型、动静分区及当年流年等多项因素，'
                '并须现场勘查后作综合判断。本程序因装置磁场干扰、使用方法不当、或用户自行修改数据所导致之误差，开发者概不负责。\n'
                '若用于商业、大型工程或高敏感场域，请咨询专业人士后再行施工或摆设。',
                style: TextStyle(fontSize: 12.2, height: 1.35, color: Colors.white),
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
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
      child: Text(
        text,
        style: const TextStyle(fontSize: 13.3, height: 1.35),
      ),
    );
  }
}
