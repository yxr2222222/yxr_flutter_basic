import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/Log.dart';

extension StringExtension on String {
  /// 字符串转uri后执行launchUrl
  Future<bool> launch() async {
    try {
      var uri = Uri.parse(this);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
    } catch (e) {
      Log.d("launchUrl error", error: e);
    }
    return false;
  }

  /// 字符串转Uri
  Future<Uri?> parseUri() async {
    try {
      return Uri.parse(this);
    } catch (e) {
      return null;
    }
  }

  /// 查找字符串中所有[keyword]的下标，返回下标集合
  List<KeyWordIndex> indexOfList(String keyword) {
    List<KeyWordIndex> occurrences = [];
    int index = 0;

    while (index < length) {
      int position = indexOf(keyword, index);
      if (position == -1) {
        break;
      }
      occurrences.add(KeyWordIndex(keyword, position));
      index = position + 1;
    }
    return occurrences;
  }

  /// 根据关键字创建关键字高亮可点击的富文本widget
  /// [keywords] 需要高亮可点击的关键字列表
  /// [textColor] 文本颜色，默认是黑色
  /// [highColor] 高亮文本颜色，默认是蓝色
  /// [fontSize] 文本的大小，默认是12
  /// [keywordFontSize] 高亮文本大小，默认是[fontSize]大小
  /// [fontWeight] 文本的字体权重，默认是[FontWeight.normal]
  /// [keywordFontWeight] 高亮文本的字体权重，默认是[fontWeight]
  /// [onKeywordTap] 高亮文本点击方法回调
  Text highLightClickableRichText(
      {required List<String> keywords,
      Color textColor = Colors.black,
      Color highColor = Colors.blue,
      double fontSize = 12,
      double? keywordFontSize,
      FontWeight fontWeight = FontWeight.normal,
      FontWeight? keywordFontWeight,
      void Function(String keyword)? onKeywordTap}) {
    keywordFontSize = keywordFontSize ?? fontSize;
    keywordFontWeight = keywordFontWeight ?? fontWeight;

    List<TextSpan> textSpanList = [];
    List<KeyWordIndex> keywordIndexList = [];

    // 找到所有关键字的下标
    for (var keyword in keywords) {
      keywordIndexList.addAll(indexOfList(keyword));
    }

    // 下标升序排序
    keywordIndexList.sort((a, b) {
      return a.index.compareTo(b.index);
    });

    int startIndex = 0;
    for (var keywordIndex in keywordIndexList) {
      var normalText = substring(startIndex, keywordIndex.index);
      textSpanList.add(TextSpan(
          text: normalText,
          style: TextStyle(
              color: textColor, fontWeight: fontWeight, fontSize: fontSize)));

      var keyword = keywordIndex.keyword;

      TapGestureRecognizer? recognizer = onKeywordTap == null
          ? null
          : (TapGestureRecognizer()
            ..onTap = () {
              onKeywordTap(keyword);
            });

      textSpanList.add(TextSpan(
          text: keyword,
          style: TextStyle(
              color: highColor,
              fontWeight: keywordFontWeight,
              fontSize: keywordFontSize),
          recognizer: recognizer));

      startIndex = startIndex + keywordIndex.keyword.length;
    }

    return Text.rich(
        textAlign: TextAlign.left, TextSpan(children: textSpanList));
  }

  int parseInt({int defaultValue = 0}) {
    try {
      return int.parse(this);
    } catch (e) {
      return defaultValue;
    }
  }

  double parseDouble({double defaultValue = 0.0}) {
    try {
      return double.parse(this);
    } catch (e) {
      return defaultValue;
    }
  }
}

class KeyWordIndex {
  final String keyword;
  final int index;

  KeyWordIndex(this.keyword, this.index);
}
