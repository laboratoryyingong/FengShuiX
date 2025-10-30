import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '说明',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                '由于电磁波的干扰，电子罗盘显示的方向误差可能有很大。\n\n'
                '准确度分为三级：\n'
                '• ±0－10：满意\n'
                '• ±11－15：普通\n'
                '• ±16＋：错误\n\n'
                '如想提高电子罗盘的准确度，请快速摇晃您的装置多次，让罗盘移到正确的方向。\n'
                '如果仍然不正确，请转换到其他低电磁波干扰的位置重新量度，或改用手动输入大门方向。',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                '提示：\n- 部分设备的电子罗盘需要开启定位 / 权限才能工作；\n- 如果一直显示“错误”，请远离金属、车内、音箱、电脑主机；\n- 也可以考虑加一个“手动输入度数”的入口。',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
