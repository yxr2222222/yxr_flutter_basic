import 'package:yxr_flutter_basic/base/event/EventOb.dart';
import 'package:yxr_flutter_basic/base/ui/widget/lifecycle/PageLifecycle.dart';

class LiveEventCore {
  static final Map<String, _EventObservable<dynamic>> _eventMap = {};

  LiveEventCore._();

  /// 获取监听
  static EventObservable<T> getEvent<T>(String event) {
    var eventObservable = _eventMap[event];
    if (eventObservable == null) {
      eventObservable = _EventObservable<T>();
      _eventMap[event] = eventObservable;
    }

    return eventObservable as EventObservable<T>;
  }

  /// 移除监听
  static remove(String event) {
    _eventMap.remove(event);
  }
}

class _EventObservable<T> implements EventObservable<T> {
  final List<_PageEventObserver<T>> _observers = [];

  @override
  void observe(PageLifecycle lifecycle, EventObserver<T> observer) {
    var pageEventObserver = _findPageEventObserver(lifecycle);
    if (pageEventObserver == null) {
      var listener = _buildPageLifecycleListener(lifecycle);
      pageEventObserver = _PageEventObserver<T>(listener);
      _observers.add(pageEventObserver);
    }

    var observerList = pageEventObserver.observerList;
    if (!observerList.contains(observer)) {
      observerList.add(observer);
    }
  }

  @override
  void removeObserve(EventObserver<T> observer) {
    for (var element in _observers) {
      if (element.contains(observer)) {
        element.remove(observer);
        break;
      }
    }
  }

  @override
  void postEvent(T? event) {
    for (var observer in _observers) {
      observer.post(event);
    }
  }

  /// 构建生命周期监听
  PageLifecycleListener _buildPageLifecycleListener(PageLifecycle lifecycle) {
    PageLifecycleListener listener =
        PageLifecycleListener(onDestroy: (context) {
      var pageEventObserver = _findPageEventObserver(lifecycle);
      if (pageEventObserver != null) {
        pageEventObserver.observerList.clear();
        _observers.remove(pageEventObserver);
      }
    });
    lifecycle.addListener(listener);
    return listener;
  }

  /// 根据生命周期找到PageEventObserver
  _PageEventObserver<T>? _findPageEventObserver(PageLifecycle lifecycle) {
    for (var value in _observers) {
      if (lifecycle.contains(value.listener)) {
        return value;
      }
    }
    return null;
  }
}

class _PageEventObserver<T> {
  final List<EventObserver<T>> _observerList = [];
  final PageLifecycleListener _listener;

  List<EventObserver<T>> get observerList => _observerList;

  _PageEventObserver(this._listener);

  PageLifecycleListener get listener => _listener;

  bool contains(EventObserver<T> observer) {
    return _observerList.contains(observer);
  }

  bool remove(EventObserver<T> observer) {
    return _observerList.remove(observer);
  }

  void post(T? event) {
    for (var observer in _observerList) {
      observer(event);
    }
  }
}
