import 'package:flutter/cupertino.dart';

class PageLifecycle {
  final List<PageLifecycleListener> _pageLifecycleListener = [];

  List<PageLifecycleListener> get pageLifecycleListener =>
      _pageLifecycleListener;

  void addListener(PageLifecycleListener listener) {
    if (!_pageLifecycleListener.contains(listener)) {
      _pageLifecycleListener.add(listener);
    }
  }

  void removeListener(PageLifecycleListener listener) {
    _pageLifecycleListener.remove(listener);
  }
}

class PageLifecycleListener {
  final OnLifecycle? onCreate;
  final OnLifecycle? onResume;
  final OnLifecycle? onPause;
  final OnLifecycle? onDestroy;

  PageLifecycleListener(
      {this.onCreate, this.onResume, this.onPause, this.onDestroy});

  void onLifecycle(BuildContext context, OnLifecycle? onLifecycle) {
    if (onLifecycle != null) {
      onLifecycle(context);
    }
  }
}

typedef OnLifecycle = void Function(BuildContext context);
