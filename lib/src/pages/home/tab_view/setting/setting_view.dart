import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhentai/src/routes/routes.dart';

LinkedHashMap<String, IconData> items = LinkedHashMap.of({
  'account': Icons.account_circle,
  'EH': Icons.mood,
  'gallery': Icons.collections,
  'read': Icons.local_library,
  'download': Icons.download,
  'advanced': Icons.settings_suggest,
  'about': Icons.info,
});

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('setting'.tr),
        elevation: 1,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: items.entries
            .map(
              (entry) => ListTile(
                leading: Icon(entry.value),
                title: Text(entry.key.tr),
                onTap: () => Get.toNamed(Routes.settingPrefix + entry.key),
              ),
            )
            .toList(),
      ).paddingSymmetric(vertical: 16),
    );
  }
}
