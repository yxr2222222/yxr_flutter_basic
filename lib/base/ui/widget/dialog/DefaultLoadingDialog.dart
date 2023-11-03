import 'package:flutter/material.dart';

class DefaultLoadingDialog extends Dialog {
  /// 默认的简易loading弹框
  /// [loadingTxt] loading展示的内容
  DefaultLoadingDialog(String? loadingTxt, {super.key})
      : super(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: Container(
                width: 96,
                height: 96,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xffcccccc),
                          offset: Offset(-1, -1),
                          blurRadius: 20,
                          spreadRadius: 5)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        ),
                        Visibility(
                          visible: loadingTxt != null,
                          child: Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: Text(
                                loadingTxt ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xff5c5c5c)),
                              )),
                        )
                      ],
                    )),
              ),
            ));
}
