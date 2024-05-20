import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/ui/widget/dialog/BaseDialog.dart';

class DefaultLoadingDialog extends BaseDialog {
  /// 默认的简易loading弹框
  /// [loadingTxt] loading展示的内容
  DefaultLoadingDialog(String? loadingTxt, {super.key})
      : super(
            child: Container(
          width: 72,
          height: 72,
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
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2,),
                  ),
                  Visibility(
                    visible: loadingTxt != null,
                    child: Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Text(
                          loadingTxt ?? "",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xff5c5c5c),
                          ),
                        )),
                  )
                ],
              )),
        ));
}
