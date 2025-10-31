import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  final bool useTraditional;
  final Future<String> Function(String text)? tr;

  const TipsPage({super.key, this.useTraditional = false, this.tr});

  @override
  Widget build(BuildContext context) {
    final bool zhTW = useTraditional;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== 1. 招财纳福 ====================
            _GroupHeader(
              icon: Icons.savings_outlined,
              title: zhTW ? '招財納福' : '招财纳福',
              desc: zhTW ? '要進財、聚人氣、讓「好氣」進來，用這一組。' : '要进财、拉人气、让“好气”进来，用这一组。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '水（鱼缸 / 水景）',
              titleTW: '水（魚缸 / 水景）',
              image: 'assets/fengshui/water.jpg',
              effectCN: '聚财、引动财气、让好气流动。',
              effectTW: '聚財、引動財氣、讓好氣流動。',
              scenarioCN: '客厅明堂、财位、店铺门口、接待区。',
              scenarioTW: '客廳明堂、財位、店舖門口、接待區。',
              placementCN: '水要动、要干净、要常满，水口不要正对大门，可放斜对门财位。',
              placementTW: '水要動、要乾淨、要常滿，水口不要正對大門，可放斜對門財位。',
              tabooCN: '卧室、灶旁、神位前一般不放水；水脏=漏财；别放在明显病位。',
              tabooTW: '臥室、灶旁、神位前一般不放水；水髒 = 漏財；別放在明顯病位。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '大象',
              titleTW: '大象',
              image: 'assets/fengshui/elephant.jpg',
              effectCN: '纳福、吸水为财、稳宅。',
              effectTW: '納福、吸水為財、穩宅。',
              scenarioCN: '门口、窗边朝外“吸水”、客厅。',
              scenarioTW: '門口、窗邊朝外「吸水」、客廳。',
              placementCN: '象鼻向内是把好运吸进来；象鼻向外是送福，看需求放。',
              placementTW: '象鼻向內是把好運吸進來；象鼻向外是送福，看需求放。',
              tabooCN: '不要对厕所、不要对楼梯下。',
              tabooTW: '不要對廁所、不要對樓梯下。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '蟾蜍（三脚金蟾）',
              titleTW: '蟾蜍（三腳金蟾）',
              image: 'assets/fengshui/toad.jpg',
              effectCN: '招财、进宝，常见生意摆件。',
              effectTW: '招財、進寶，常見生意擺件。',
              scenarioCN: '收银台、财位、办公桌一角、前台。',
              scenarioTW: '收銀台、財位、辦公桌一角、前台。',
              placementCN: '嘴一定要向里，表示把钱叼进来；高度不要太低，可微微斜对门。',
              placementTW: '嘴一定要向內，表示把錢叼進來；高度不要太低，可微微斜對門。',
              tabooCN: '不要对着门往外吐钱；不要放卧室；不要对厕所。',
              tabooTW: '不要對著門往外吐錢；不要放臥室；不要對廁所。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '貔貅',
              titleTW: '貔貅',
              image: 'assets/fengshui/pixiu.jpg',
              effectCN: '招财、守财，还能挡煞、化小人。',
              effectTW: '招財、守財，還能擋煞、化小人。',
              scenarioCN: '客厅、门口、办公桌、公司前台、网店的办公位。',
              scenarioTW: '客廳、門口、辦公桌、公司前台、網店的辦公位。',
              placementCN: '头向来财方向（门/窗）；一对可分左右；定期擦拭保持灵性。',
              placementTW: '頭向來財方向（門 / 窗）；一對可分左右；定期擦拭保持靈性。',
              tabooCN: '不要随便给别人摸；不要正对镜子；卧室慎放。',
              tabooTW: '不要隨便給別人摸；不要正對鏡子；臥室慎放。',
            ),

            const SizedBox(height: 18),

            // ==================== 2. 化煞镇宅 ====================
            _GroupHeader(
              icon: Icons.shield_moon_outlined,
              title: zhTW ? '化煞鎮宅' : '化煞镇宅',
              desc: zhTW ? '門口沖、戶型空、病位、進門見煞，用這一組。' : '门口冲、户型空、病位、进门见煞，用这一组。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '石头（镇宅石 / 泰山石）',
              titleTW: '石頭（鎮宅石 / 泰山石）',
              image: 'assets/fengshui/stone.jpg',
              effectCN: '镇宅、压煞、补“山”气、稳住入口。',
              effectTW: '鎮宅、壓煞、補「山」氣、穩住入口。',
              scenarioCN: '大门对电梯/走廊/楼梯、门口太空、窗外见天斩煞。',
              scenarioTW: '大門對電梯 / 走廊 / 樓梯、門口太空、窗外見天斬煞。',
              placementCN: '放在进门一侧或见煞一侧，室内选中等大小天然石，户外可稍大。',
              placementTW: '放在進門一側或見煞一側，室內選中等大小天然石，戶外可稍大。',
              tabooCN: '不要用很尖的对着人；室内不要太大块；不要堵通道。',
              tabooTW: '不要用很尖的對著人；室內不要太大塊；不要堵通道。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '葫芦',
              titleTW: '葫蘆',
              image: 'assets/fengshui/hulu.jpg',
              effectCN: '收煞、化病、把杂乱的气“收进去”。',
              effectTW: '收煞、化病、把雜亂的氣「收進去」。',
              scenarioCN: '床头有人身体弱、卫生间外侧、流年病符位、医药柜附近。',
              scenarioTW: '床頭有人身體弱、衛生間外側、流年病符位、醫藥櫃附近。',
              placementCN: '葫芦嘴朝上、挂起来用，表示“收”；可贴近病位但不要藏太深。',
              placementTW: '葫蘆嘴朝上、掛起來用，表示「收」；可貼近病位但不要藏太深。',
              tabooCN: '不要葫芦口朝下；破损葫芦不要用。',
              tabooTW: '不要葫蘆口朝下；破損葫蘆不要用。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '镜子',
              titleTW: '鏡子',
              image: 'assets/fengshui/mirror.jpg',
              effectCN: '反射、挡煞、借景、放大空间。',
              effectTW: '反射、擋煞、借景、放大空間。',
              scenarioCN: '走廊直冲、电梯门、室内狭长、拐角想要“转弯”。',
              scenarioTW: '走廊直沖、電梯門、室內狹長、拐角想要「轉彎」。',
              placementCN: '侧挂、斜挂、借景都行；用来“看不到的转角”很合适。',
              placementTW: '側掛、斜掛、借景都行；用來「看不到的轉角」很合適。',
              tabooCN: '三大禁忌：不对大门、不对床、不对灶；也别对神位。',
              tabooTW: '三大禁忌：不對大門、不對床、不對灶；也別對神位。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '狮子（石狮 / 铜狮）',
              titleTW: '獅子（石獅 / 銅獅）',
              image: 'assets/fengshui/lion.jpg',
              effectCN: '镇宅、护门、挡外煞，气场强。',
              effectTW: '鎮宅、護門、擋外煞，氣場強。',
              scenarioCN: '大门口、店铺门口、公司出入口、对着大路的门洞。',
              scenarioTW: '大門口、店舖門口、公司出入口、對著大路的門洞。',
              placementCN: '一对用，面对门是左公右母；一般向外看。',
              placementTW: '一對用，面對門是左公右母；一般向外看。',
              tabooCN: '室内不要对着人坐；小户型不要放太大，容易压宅。',
              tabooTW: '室內不要對著人坐；小戶型不要放太大，容易壓宅。',
            ),

            const SizedBox(height: 18),

            // ==================== 3. 文昌 & 生气 ====================
            _GroupHeader(
              icon: Icons.menu_book_outlined,
              title: zhTW ? '文昌 & 生氣' : '文昌 & 生气',
              desc: zhTW
                  ? '讀書、考試、寫作、孩子書房、讓家裡有活氣用這一組。'
                  : '读书、考试、写作、孩子书房、让家里有活气用这一组。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '文昌塔',
              titleTW: '文昌塔',
              image: 'assets/fengshui/wenchang.jpg',
              effectCN: '催文昌、提升专注、考试/职称/写作都能用。',
              effectTW: '催文昌、提升專注、考試 / 職稱 / 寫作都能用。',
              scenarioCN: '书房、孩子房、办公桌侧边、流年文昌位。',
              scenarioTW: '書房、孩子房、辦公桌側邊、流年文昌位。',
              placementCN: '放高一点、保持干净、不要被杂物压住；最好有靠。',
              placementTW: '放高一點、保持乾淨、不要被雜物壓住；最好有靠。',
              tabooCN: '不要放厕所旁；不要当玩具；坏了要换。',
              tabooTW: '不要放廁所旁；不要當玩具；壞了要換。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '植物（绿植）',
              titleTW: '植物（綠植）',
              image: 'assets/fengshui/plant.jpg',
              effectCN: '生旺、补木、柔化直冲，让空间有活力。',
              effectTW: '生旺、補木、柔化直沖，讓空間有活力。',
              scenarioCN: '玄关、走廊尽头、书桌一角、阴冷的房间。',
              scenarioTW: '玄關、走廊盡頭、書桌一角、陰冷的房間。',
              placementCN: '光线好、通风好；办公桌用小盆栽；玄关用中等高的绿植。',
              placementTW: '光線好、通風好；辦公桌用小盆栽；玄關用中等高的綠植。',
              tabooCN: '不要放枯黄植物；卧室不要放太大；带刺植物不要对着人。',
              tabooTW: '不要放枯黃植物；臥室不要放太大；帶刺植物不要對著人。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '浴缸 / 静水',
              titleTW: '浴缸 / 靜水',
              image: 'assets/fengshui/bathtub.jpg',
              effectCN: '柔化气场、缓和、让“火太旺/气太硬”的空间软下来。',
              effectTW: '柔化氣場、緩和，讓「火太旺 / 氣太硬」的空間軟下來。',
              scenarioCN: '卫生间、Spa、主卫比较大的房子。',
              scenarioTW: '衛生間、Spa、主衛比較大的房子。',
              placementCN: '排水要顺、保持干净；不要正冲大门/财位。',
              placementTW: '排水要順、保持乾淨；不要正沖大門 / 財位。',
              tabooCN: '不要长期积脏水；不要刚好压在桃花位或财位上。',
              tabooTW: '不要長期積髒水；不要剛好壓在桃花位或財位上。',
            ),

            const SizedBox(height: 18),

            // ==================== 4. 五行补强 / 权势类 ====================
            _GroupHeader(
              icon: Icons.bolt_outlined,
              title: zhTW ? '五行補強 / 權勢類' : '五行补强 / 权势类',
              desc: zhTW
                  ? '格局太陰、要啟動、要權威、要「清氣」的時候用。'
                  : '格局太阴、要激活、要权威、要“清气”的时候用。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '火（红灯 / 蜡烛 / 小壁炉）',
              titleTW: '火（紅燈 / 蠟燭 / 小壁爐）',
              image: 'assets/fengshui/fire.jpg',
              effectCN: '升温、激活、旺南方、化水太重。',
              effectTW: '升溫、激活、旺南方、化水太重。',
              scenarioCN: '房子太阴冷、靠水太多、想旺离位(南)。',
              scenarioTW: '房子太陰冷、靠水太多、想旺離位(南)。',
              placementCN: '用灯光、红色台灯、香炉代替真火，注意安全。',
              placementTW: '用燈光、紅色檯燈、香爐代替真火，注意安全。',
              tabooCN: '火太旺会躁、会有口舌；卧室慎用；忌火命者少用。',
              tabooTW: '火太旺會躁、會有口舌；臥室慎用；忌火命者少用。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '金（金属摆件 / 铜钱 / 风铃）',
              titleTW: '金（金屬擺件 / 銅錢 / 風鈴）',
              image: 'assets/fengshui/metal.jpg',
              effectCN: '肃杀、清气、化土煞、催偏财。',
              effectTW: '肅殺、清氣、化土煞、催偏財。',
              scenarioCN: '西方位、办公室、要“清掉杂气”的角落。',
              scenarioTW: '西方位、辦公室、要「清掉雜氣」的角落。',
              placementCN: '摆在明处、保持金属光泽，可配风铃挂门口。',
              placementTW: '擺在明處、保持金屬光澤，可配風鈴掛門口。',
              tabooCN: '金多克木，儿童房/书房别放太多金属，会影响专注。',
              tabooTW: '金多剋木，兒童房 / 書房別放太多金屬，會影響專注。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '龙',
              titleTW: '龍',
              image: 'assets/fengshui/dragon.jpg',
              effectCN: '扶正、护宅、催权、提升气势。',
              effectTW: '扶正、護宅、催權、提升氣勢。',
              scenarioCN: '办公室、客厅主墙、老板位、公司前台。',
              scenarioTW: '辦公室、客廳主牆、老闆位、公司前台。',
              placementCN: '龙头向里向旺，最好见水，高度要有，不要丢地上。',
              placementTW: '龍頭向裡向旺，最好見水，高度要有，不要丟地上。',
              tabooCN: '不要冲门、冲床；生肖有冲的慎用。',
              tabooTW: '不要沖門、沖床；生肖有沖的慎用。',
            ),

            const SizedBox(height: 18),

            // ==================== 5. 流年化解 ====================
            _GroupHeader(
              icon: Icons.change_circle_outlined,
              title: zhTW ? '流年化解' : '流年化解',
              desc: zhTW
                  ? '每年方位會變的煞位、病位、太歲位，用這一組來壓、化、避。'
                  : '每年方位会变的煞位、病位、太岁位，用这一组来压、化、避。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '流年五黄位',
              titleTW: '流年五黃位',
              effectCN: '五黄属大煞，主意外、破耗、血光，要压要化。',
              effectTW: '五黃屬大煞，主意外、破耗、血光，要壓要化。',
              scenarioCN: '当年的五黄所在方位（每年位置会换，需要你在“说明”或“分析”里写出来）。',
              scenarioTW: '當年的五黃所在方位（每年位置會換，需要你在「說明」或「分析」裡寫出來）。',
              placementCN: '用金属化（土生金、金泄其势），可放铜葫芦、六帝钱、小铜钟。',
              placementTW: '用金屬化（土生金、金洩其勢），可放銅葫蘆、六帝錢、小銅鐘。',
              tabooCN: '不要动工、不要开大门、不要放红色(火会助土)、不要放水(流动会带动煞气)。',
              tabooTW: '不要動工、不要開大門、不要放紅色(火會助土)、不要放水(流動會帶動煞氣)。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '流年二黑病符位',
              titleTW: '流年二黑病符位',
              effectCN: '主疾病、慢性烦恼，可用葫芦来收、用金属来弱化。',
              effectTW: '主疾病、慢性煩惱，可用葫蘆來收、用金屬來弱化。',
              scenarioCN: '当年二黑所在的宫位，家里有老人/孕妇要特别注意。',
              scenarioTW: '當年二黑所在的宮位，家裡有老人 / 孕婦要特別注意。',
              placementCN: '放铜制葫芦、金属摆件，或者你前面说的葫芦挂件。',
              placementTW: '放銅製葫蘆、金屬擺件，或者你前面說的葫蘆掛件。',
              tabooCN: '不要放大水、不要放红火、不要当储物间乱堆(会把病气闷住)。',
              tabooTW: '不要放大水、不要放紅火、不要當儲物間亂堆(會把病氣悶住)。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '太岁 / 岁破位',
              titleTW: '太歲 / 歲破位',
              effectCN: '太岁头上不可动土，主要是“避”不是“补”。',
              effectTW: '太歲頭上不可動土，主要是「避」不是「補」。',
              scenarioCN: '当年的太岁方位（正对的反向是岁破），常见是不要在这开工/拆柜。',
              scenarioTW: '當年的太歲方位（正對的反向是歲破），常見是不要在這開工 / 拆櫃。',
              placementCN: '保持清净、少动、可以简单放一件化煞的小铜器。',
              placementTW: '保持清淨、少動、可以簡單放一件化煞的小銅器。',
              tabooCN: '不要坐着正冲太岁、不要在这敲打装修、不要长期开门对着它。',
              tabooTW: '不要坐著正沖太歲、不要在這敲打裝修、不要長期開門對著它。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '流年三煞',
              titleTW: '流年三煞',
              effectCN: '三煞主破财、小人、口舌，重点是“别冲、别犯、别坐背后”。',
              effectTW: '三煞主破財、小人、口舌，重點是「別沖、別犯、別坐背後」。',
              scenarioCN: '当年三煞的方位；办公桌、沙发尽量不要背对三煞。',
              scenarioTW: '當年三煞的方位；辦公桌、沙發盡量不要背對三煞。',
              placementCN: '可用金属风铃、葫芦、麒麟/狮子一类的挡一下。',
              placementTW: '可用金屬風鈴、葫蘆、麒麟 / 獅子一類的擋一下。',
              tabooCN: '不要在三煞位开大门、不要坐背对三煞、不要长期堆垃圾。',
              tabooTW: '不要在三煞位開大門、不要坐背對三煞、不要長期堆垃圾。',
            ),
            _ItemCard(
              useTraditional: zhTW,
              titleCN: '流年桃花位化解',
              titleTW: '流年桃花位化解',
              effectCN: '有烂桃花/感情不稳，可以把流年桃花位“管一下”。',
              effectTW: '有爛桃花 / 感情不穩，可以把流年桃花位「管一下」。',
              scenarioCN: '当年桃花位落在卧室、床边、门口时。',
              scenarioTW: '當年桃花位落在臥室、床邊、門口時。',
              placementCN: '可以用金属物件、葫芦或绿植来“正一正”，也可以干脆保持干净不要乱摆香水鞋子。',
              placementTW: '可以用金屬物件、葫蘆或綠植來「正一正」，也可以乾脆保持乾淨不要亂擺香水鞋子。',
              tabooCN: '不要在烂桃花位放红色小灯、粉色床品、香味很重的东西，会越招越乱。',
              tabooTW: '不要在爛桃花位放紅色小燈、粉色床品、香味很重的東西，會越招越亂。',
            ),

            const SizedBox(height: 60),
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
  final bool useTraditional;

  final String titleCN;
  final String titleTW;

  final String? image;

  final String effectCN;
  final String effectTW;

  final String scenarioCN;
  final String scenarioTW;

  final String placementCN;
  final String placementTW;

  final String tabooCN;
  final String tabooTW;

  const _ItemCard({
    super.key,
    required this.useTraditional,
    required this.titleCN,
    required this.titleTW,
    this.image,
    required this.effectCN,
    required this.effectTW,
    required this.scenarioCN,
    required this.scenarioTW,
    required this.placementCN,
    required this.placementTW,
    required this.tabooCN,
    required this.tabooTW,
  });

  @override
  Widget build(BuildContext context) {
    final bool zhTW = useTraditional;

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
              zhTW ? titleTW : titleCN,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            _line(zhTW ? '作用' : '作用', zhTW ? effectTW : effectCN),
            _line(zhTW ? '適用場景' : '适用场景', zhTW ? scenarioTW : scenarioCN),
            _line(zhTW ? '擺放要點' : '摆放要点', zhTW ? placementTW : placementCN),
            _line(zhTW ? '禁忌' : '禁忌', zhTW ? tabooTW : tabooCN),
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
