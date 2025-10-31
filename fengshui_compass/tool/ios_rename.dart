import 'dart:io';

/// 要改成的名字（图标下面那个）
const newDisplayName = '風水乂';

/// 要改成的 Bundle Id（要和你 Apple Developer 里的一样）
const newBundleId = 'com.app.fengshui.gong';

Future<void> main() async {
  await _updateInfoPlist();
  await _updatePbxproj();
  print('✅ iOS name & bundle id updated.');
}

Future<void> _updateInfoPlist() async {
  final file = File('ios/Runner/Info.plist');
  if (!await file.exists()) {
    throw Exception('Info.plist not found');
  }
  var content = await file.readAsString();

  final hasDisplayName = content.contains('CFBundleDisplayName');

  if (hasDisplayName) {
    // 情况 1：原来就有 CFBundleDisplayName → 直接替换
    content = content.replaceAll(
      RegExp(r'<key>CFBundleDisplayName<\/key>\s*<string>.*?<\/string>'),
      '<key>CFBundleDisplayName</key>\n\t<string>$newDisplayName</string>',
    );
  } else {
    // 情况 2：没有，就插到 CFBundleName 后面
    content = content.replaceFirstMapped(
      RegExp(r'<key>CFBundleName<\/key>\s*<string>.*?<\/string>'),
      (match) {
        return '${match.group(0)}\n\t<key>CFBundleDisplayName</key>\n\t<string>$newDisplayName</string>';
      },
    );
  }

  await file.writeAsString(content);
  print('✅ Info.plist updated (CFBundleDisplayName = $newDisplayName)');
}

Future<void> _updatePbxproj() async {
  final file = File('ios/Runner.xcodeproj/project.pbxproj');
  if (!await file.exists()) {
    throw Exception('project.pbxproj not found');
  }
  var content = await file.readAsString();

  // 把所有 PRODUCT_BUNDLE_IDENTIFIER 都换成新的
  final regex = RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = ([^;]+);');
  content = content.replaceAllMapped(regex, (m) {
    return 'PRODUCT_BUNDLE_IDENTIFIER = $newBundleId;';
  });

  await file.writeAsString(content);
  print('✅ project.pbxproj updated (PRODUCT_BUNDLE_IDENTIFIER = $newBundleId)');
}
