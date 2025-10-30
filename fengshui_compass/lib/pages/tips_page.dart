import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // ==================== 1. 招财纳福 ====================
            _GroupHeader(
              icon: Icons.savings_outlined,
              title: '招财纳福',
              desc: '要进财、拉人气、让“好气”进来，用这一组。',
            ),
            _ItemCard(
              title: '水（鱼缸 / 水景）',
              image: 'assets/fengshui/water.jpg',
              effect: '聚财、引动财气、让好气流动。',
              scenario: '客厅明堂、财位、店铺门口、接待区。',
              placement: '水要动、要干净、要常满，水口不要正对大门，可放斜对门财位。',
              taboo: '卧室、灶旁、神位前一般不放水；水脏=漏财；别放在明显病位。',
            ),
            _ItemCard(
              title: '大象',
              image: 'assets/fengshui/elephant.jpg',
              effect: '纳福、吸水为财、稳宅。',
              scenario: '门口、窗边朝外“吸水”、客厅。',
              placement: '象鼻向内是把好运吸进来；象鼻向外是送福，看需求放。',
              taboo: '不要对厕所、不要对楼梯下。',
            ),
            _ItemCard(
              title: '蟾蜍（三脚金蟾）',
              image: 'assets/fengshui/toad.jpg',
              effect: '招财、进宝，常见生意摆件。',
              scenario: '收银台、财位、办公桌一角、前台。',
              placement: '嘴一定要向里，表示把钱叼进来；高度不要太低，可微微斜对门。',
              taboo: '不要对着门往外吐钱；不要放卧室；不要对厕所。',
            ),
            _ItemCard(
              title: '貔貅',
              image: 'assets/fengshui/pixiu.jpg',
              effect: '招财、守财，还能挡煞、化小人。',
              scenario: '客厅、门口、办公桌、公司前台、网店的办公位。',
              placement: '头向来财方向（门/窗）；一对可分左右；定期擦拭保持灵性。',
              taboo: '不要随便给别人摸；不要正对镜子；卧室慎放。',
            ),

            SizedBox(height: 18),

            // ==================== 2. 化煞镇宅 ====================
            _GroupHeader(
              icon: Icons.shield_moon_outlined,
              title: '化煞镇宅',
              desc: '门口冲、户型空、病位、进门见煞，用这一组。',
            ),
            _ItemCard(
              title: '石头（镇宅石 / 泰山石）',
              image: 'assets/fengshui/stone.jpg',
              effect: '镇宅、压煞、补“山”气、稳住入口。',
              scenario: '大门对电梯/走廊/楼梯、门口太空、窗外见天斩煞。',
              placement: '放在进门一侧或见煞一侧，室内选中等大小天然石，户外可稍大。',
              taboo: '不要用很尖的对着人；室内不要太大块；不要堵通道。',
            ),
            _ItemCard(
              title: '葫芦',
              image: 'assets/fengshui/hulu.jpg',
              effect: '收煞、化病、把杂乱的气“收进去”。',
              scenario: '床头有人身体弱、卫生间外侧、流年病符位、医药柜附近。',
              placement: '葫芦嘴朝上、挂起来用，表示“收”；可贴近病位但不要藏太深。',
              taboo: '不要葫芦口朝下；破损葫芦不要用。',
            ),
            _ItemCard(
              title: '镜子',
              image: 'assets/fengshui/mirror.jpg',
              effect: '反射、挡煞、借景、放大空间。',
              scenario: '走廊直冲、电梯门、室内狭长、拐角想要“转弯”。',
              placement: '侧挂、斜挂、借景都行；用来“看不到的转角”很合适。',
              taboo: '三大禁忌：不对大门、不对床、不对灶；也别对神位。',
            ),
            _ItemCard(
              title: '狮子（石狮 / 铜狮）',
              image: 'assets/fengshui/lion.jpg',
              effect: '镇宅、护门、挡外煞，气场强。',
              scenario: '大门口、店铺门口、公司出入口、对着大路的门洞。',
              placement: '一对用，面对门是左公右母；一般向外看。',
              taboo: '室内不要对着人坐；小户型不要放太大，容易压宅。',
            ),

            SizedBox(height: 18),

            // ==================== 3. 文昌 & 生气 ====================
            _GroupHeader(
              icon: Icons.menu_book_outlined,
              title: '文昌 & 生气',
              desc: '读书、考试、写作、孩子书房、让家里有活气用这一组。',
            ),
            _ItemCard(
              title: '文昌塔',
              image: 'assets/fengshui/wenchang.jpg',
              effect: '催文昌、提升专注、考试/职称/写作都能用。',
              scenario: '书房、孩子房、办公桌侧边、流年文昌位。',
              placement: '放高一点、保持干净、不要被杂物压住；最好有靠。',
              taboo: '不要放厕所旁；不要当玩具；坏了要换。',
            ),
            _ItemCard(
              title: '植物（绿植）',
              image: 'assets/fengshui/plant.jpg',
              effect: '生旺、补木、柔化直冲，让空间有活力。',
              scenario: '玄关、走廊尽头、书桌一角、阴冷的房间。',
              placement: '光线好、通风好；办公桌用小盆栽；玄关用中等高的绿植。',
              taboo: '不要放枯黄植物；卧室不要放太大；带刺植物不要对着人。',
            ),
            _ItemCard(
              title: '浴缸 / 静水',
              image: 'assets/fengshui/bathtub.jpg',
              effect: '柔化气场、缓和、让“火太旺/气太硬”的空间软下来。',
              scenario: '卫生间、Spa、主卫比较大的房子。',
              placement: '排水要顺、保持干净；不要正冲大门/财位。',
              taboo: '不要长期积脏水；不要刚好压在桃花位或财位上。',
            ),

            SizedBox(height: 18),

            // ==================== 4. 五行补强 / 权势类 ====================
            _GroupHeader(
              icon: Icons.bolt_outlined,
              title: '五行补强 / 权势类',
              desc: '格局太阴、要激活、要权威、要“清气”的时候用。',
            ),
            _ItemCard(
              title: '火（红灯 / 蜡烛 / 小壁炉）',
              image: 'assets/fengshui/fire.jpg',
              effect: '升温、激活、旺南方、化水太重。',
              scenario: '房子太阴冷、靠水太多、想旺离位(南)。',
              placement: '用灯光、红色台灯、香炉代替真火，注意安全。',
              taboo: '火太旺会躁、会有口舌；卧室慎用；忌火命者少用。',
            ),
            _ItemCard(
              title: '金（金属摆件 / 铜钱 / 风铃）',
              image: 'assets/fengshui/metal.jpg',
              effect: '肃杀、清气、化土煞、催偏财。',
              scenario: '西方位、办公室、要“清掉杂气”的角落。',
              placement: '摆在明处、保持金属光泽，可配风铃挂门口。',
              taboo: '金多克木，儿童房/书房别放太多金属，会影响专注。',
            ),
            _ItemCard(
              title: '龙',
              image: 'assets/fengshui/dragon.jpg',
              effect: '扶正、护宅、催权、提升气势。',
              scenario: '办公室、客厅主墙、老板位、公司前台。',
              placement: '龙头向里向旺，最好见水，高度要有，不要丢地上。',
              taboo: '不要冲门、冲床；生肖有冲的慎用。',
            ),

            SizedBox(height: 18),

            // ==================== 5. 流年化解 ====================
            _GroupHeader(
              icon: Icons.change_circle_outlined,
              title: '流年化解',
              desc: '每年方位会变的煞位、病位、太岁位，用这一组来压、化、避。',
            ),
            _ItemCard(
              title: '流年五黄位',
              effect: '五黄属大煞，主意外、破耗、血光，要压要化。',
              scenario: '当年的五黄所在方位（每年位置会换，需要你在“说明”或“分析”里写出来）。',
              placement: '用金属化（土生金、金泄其势），可放铜葫芦、六帝钱、小铜钟。',
              taboo: '不要动工、不要开大门、不要放红色(火会助土)、不要放水(流动会带动煞气)。',
            ),
            _ItemCard(
              title: '流年二黑病符位',
              effect: '主疾病、慢性烦恼，可用葫芦来收、用金属来弱化。',
              scenario: '当年二黑所在的宫位，家里有老人/孕妇要特别注意。',
              placement: '放铜制葫芦、金属摆件，或者你前面说的葫芦挂件。',
              taboo: '不要放大水、不要放红火、不要当储物间乱堆(会把病气闷住)。',
            ),
            _ItemCard(
              title: '太岁 / 岁破位',
              effect: '太岁头上不可动土，主要是“避”不是“补”。',
              scenario: '当年的太岁方位（正对的反向是岁破），常见是不要在这开工/拆柜。',
              placement: '保持清净、少动、可以简单放一件化煞的小铜器。',
              taboo: '不要坐着正冲太岁、不要在这敲打装修、不要长期开门对着它。',
            ),
            _ItemCard(
              title: '流年三煞',
              effect: '三煞主破财、小人、口舌，重点是“别冲、别犯、别坐背后”。',
              scenario: '当年三煞的方位；办公桌、沙发尽量不要背对三煞。',
              placement: '可用金属风铃、葫芦、麒麟/狮子一类的挡一下。',
              taboo: '不要在三煞位开大门、不要坐背对三煞、不要长期堆垃圾。',
            ),
            _ItemCard(
              title: '流年桃花位化解',
              effect: '有烂桃花/感情不稳，可以把流年桃花位“管一下”。',
              scenario: '当年桃花位落在卧室、床边、门口时。',
              placement: '可以用金属物件、葫芦或绿植来“正一正”，也可以干脆保持干净不要乱摆香水鞋子。',
              taboo: '不要在烂桃花位放红色小灯、粉色床品、香味很重的东西，会越招越乱。',
            ),

            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  const _GroupHeader({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 20),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 12.5, color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String title;
  final String? image;
  final String effect;
  final String scenario;
  final String placement;
  final String taboo;

  const _ItemCard({
    required this.title,
    this.image,
    required this.effect,
    required this.scenario,
    required this.placement,
    required this.taboo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image!,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
            ],
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            _line('作用', effect),
            _line('适用场景', scenario),
            _line('摆放要点', placement),
            _line('禁忌', taboo),
          ],
        ),
      ),
    );
  }

  Widget _line(String label, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
