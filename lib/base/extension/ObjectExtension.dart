import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

extension ObjectExtension on Object {
  bool isAndroid() {
    return !kIsWeb && Platform.isAndroid;
  }

  bool isIOS() {
    return !kIsWeb && Platform.isIOS;
  }

  bool isWeb() {
    return kIsWeb;
  }

  bool isMacOS() {
    return !kIsWeb && Platform.isMacOS;
  }

  bool isWindows() {
    return !kIsWeb && Platform.isWindows;
  }

  bool isLinux() {
    return !kIsWeb && Platform.isLinux;
  }

  bool isFuchsia() {
    return !kIsWeb && Platform.isFuchsia;
  }

  bool isLateInitialization() {
    try {
      hashCode;
      return true;
    } catch (e) {
      var message = e.toString();
      return !message.startsWith("LateInitializationError");
    }
  }

  /// 获取下载路径
  /// [filename] 文件的名字，需要带上后缀(例如: eg.png)
  Future<File> getDownloadPath({required String filename}) async {
    try {
      Future<Directory> future;
      String? directory = "downloads";
      if (isAndroid()) {
        var externalCacheDirectories = await getExternalCacheDirectories();
        var externalCacheDirectory = externalCacheDirectories?.firstOrNull;
        if (externalCacheDirectory == null) {
          future = getTemporaryDirectory();
        } else {
          future = Future.value(externalCacheDirectory);
        }
      } else {
        var downloadDir = await getDownloadsDirectory();
        if (downloadDir == null) {
          future = getTemporaryDirectory();
        } else {
          directory = null;
          future = Future.value(downloadDir);
        }
      }
      var dir = await future;
      return _getFile(dir, directory, filename);
    } catch (e) {
      return File(filename);
    }
  }

  /// 获取缓存路径
  /// [filename] 文件的名字，需要带上后缀(例如: eg.png)
  /// [directory] 二级子目录，不要带/
  Future<File> getCachePath(
      {required String filename, String? directory}) async {
    try {
      var dir = await getApplicationCacheDirectory();
      return _getFile(dir, directory, filename);
    } catch (e) {
      return File(filename);
    }
  }

  File _getFile(Directory dir, String? directory, String filename) {
    return directory?.isNotEmpty == true
        ? File('${dir.path}/$directory/$filename')
        : File('${dir.path}/$filename');
  }
}

typedef OnException = void Function(Exception exception);
