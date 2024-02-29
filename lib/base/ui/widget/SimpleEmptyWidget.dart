import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/model/controller/SimpleGetxController.dart';

import '../../config/ColorConfig.dart';
import '../../util/GetBuilderUtil.dart';
import 'SimpleWidget.dart';

class SimpleEmptyWidget extends StatefulWidget {
  final SimpleGetxController<bool> visibleController;
  final double? width;
  final double? height;
  final String? iconRes;
  final double iconWidth;
  final double iconHeight;
  final String? message;
  final Color color;
  final Color fontColor;
  final double fonSize;

  const SimpleEmptyWidget(this.visibleController,
      {this.width,
      this.height,
      this.iconRes,
      this.message,
      this.iconWidth = 196,
      this.iconHeight = 196,
      this.color = Colors.white,
      this.fontColor = ColorConfig.gray_999999,
      this.fonSize = 16,
      super.key});

  @override
  State<StatefulWidget> createState() => _SimpleEmptyState();
}

class _SimpleEmptyState extends State<SimpleEmptyWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilderUtil.builder(
        (controller) => Visibility(
              visible: controller.data == true,
              child: SimpleWidget(
                width: widget.width ?? double.infinity,
                height: widget.height ?? double.infinity,
                alignment: Alignment.center,
                color: widget.color,
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Expanded(flex: 1, child: Text("")),
                    Image.asset(
                      widget.iconRes ??
                          "packages/yxr_flutter_basic/lib/images/status_default_empty.png",
                      width: widget.iconWidth,
                      height: widget.iconHeight,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        widget.message ?? "",
                        style: TextStyle(
                          fontSize: widget.fonSize,
                          color: widget.fontColor,
                        ),
                      ),
                    ),
                    const Expanded(flex: 1, child: Text("")),
                  ],
                ),
              ),
            ),
        init: widget.visibleController);
  }
}
