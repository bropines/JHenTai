import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhentai/src/model/read_page_info.dart';
import 'package:jhentai/src/pages/read/layout/vertical_list/vertical_list_layout_state.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:zoom_view/zoom_view.dart';

import '../../../../setting/read_setting.dart';
import '../../../../utils/screen_size_util.dart';
import '../../../../widget/eh_wheel_speed_controller_for_read_page.dart';
import '../base/base_layout.dart';
import 'vertical_list_layout_logic.dart';

class ScrollOffsetToScrollController extends ScrollController {
  ScrollOffsetToScrollController({required this.scrollOffsetController});

  final ScrollOffsetController scrollOffsetController;

  @override
  ScrollPosition get position => scrollOffsetController.position;

  @override
  void jumpTo(double value) {
    scrollOffsetController.jumpTo(value: value);
  }
}

class VerticalListLayout extends BaseLayout {
  VerticalListLayout({Key? key}) : super(key: key);

  @override
  final VerticalListLayoutLogic logic = Get.put<VerticalListLayoutLogic>(VerticalListLayoutLogic(), permanent: true);
  final VerticalListLayoutState state = Get.find<VerticalListLayoutLogic>().state;

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder<VerticalListLayoutLogic>(
      id: logic.verticalLayoutId,
      builder: (_) => ZoomView(
        controller: ScrollOffsetToScrollController(scrollOffsetController: state.scrollOffsetController),
        child: EHWheelSpeedControllerForReadPage(
          scrollOffsetController: state.scrollOffsetController,
          child: ScrollablePositionedList.separated(
            physics: const ClampingScrollPhysics(),
            minCacheExtent: readPageState.readPageInfo.mode == ReadMode.online
                ? readSetting.preloadDistance * screenHeight * 1
                : readSetting.preloadDistanceLocal * screenHeight * 1,
            initialScrollIndex: readPageState.readPageInfo.initialIndex,
            itemCount: readPageState.readPageInfo.pageCount,
            itemScrollController: state.itemScrollController,
            itemPositionsListener: state.itemPositionsListener,
            scrollOffsetController: state.scrollOffsetController,
            itemBuilder: _imageBuilder,
            separatorBuilder: (_, __) => Obx(() => SizedBox(height: readSetting.imageSpace.value.toDouble())),
          ),
        ),
      ),
    );
  }

  Widget _imageBuilder(context, index) {
    Widget child = Row(
      children: [
        Expanded(
          flex: 100 - readSetting.imageRegionWidthRatio.value,
          child: const SizedBox(),
        ),
        Expanded(
          flex: readSetting.imageRegionWidthRatio.value * 2,
          child: readPageState.readPageInfo.mode == ReadMode.online ? buildItemInOnlineMode(context, index) : buildItemInLocalMode(context, index),
        ),
        Expanded(
          flex: 100 - readSetting.imageRegionWidthRatio.value,
          child: const SizedBox(),
        ),
      ],
    );

    if (GetPlatform.isMobile && index == 0) {
      return Obx(() => child.marginOnly(top: readSetting.notchOptimization.isTrue ? MediaQuery.of(context).padding.top : 0));
    }

    return child;
  }
}
