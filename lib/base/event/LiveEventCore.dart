import 'package:yxr_flutter_basic/base/event/EventOb.dart';
import 'package:yxr_flutter_basic/base/ui/widget/lifecycle/PageLifecycle.dart';

/// 具有生命周期起的消息组件
/// 每一个消息key对应一个_EventObservable
/// 每一个_EventObservable中包含一组_PageEventObserver
/// 每一个_PageEventObserver对应一个PageLifecycle
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
  final Map<int, _PageEventObserver<T>> _observersMap = {};

  /// 注册具有生命周期的消息监听监听
  @override
  void observe(PageLifecycle lifecycle, EventObserver<T> observer) {
    var hashCode = lifecycle.hashCode;
    var pageEventObserver = _observersMap[hashCode];

    if (pageEventObserver == null) {
      pageEventObserver = _PageEventObserver<T>();
      _observersMap[hashCode] = pageEventObserver;

      PageLifecycleListener listener =
          PageLifecycleListener(onDestroy: (context) {
        pageEventObserver?.observerList.clear();
        _observersMap.remove(hashCode);
      });
      lifecycle.addListener(listener);
    }

    var observerList = pageEventObserver.observerList;
    if (!observerList.contains(observer)) {
      observerList.add(observer);
    }
  }

  /// 发送消息
  @override
  void postEvent(T? event) {
    _observersMap.forEach((key, value) {
      value.post(event);
    });
  }
}

/// 每一个PageLifecycle会对应一个_PageEventObserver
/// 每一个_PageEventObserver中会有多个EventObserver
/// 每次post消息其实是找到指定的_PageEventObserver并遍历其中所有的EventObserver
class _PageEventObserver<T> {
  final List<EventObserver<T>> _observerList = [];

  List<EventObserver<T>> get observerList => _observerList;

  _PageEventObserver();

  /// _PageEventObserver中是否包括了某个EventObserver
  bool contains(EventObserver<T> observer) {
    return _observerList.contains(observer);
  }

  /// 移除_PageEventObserver中的某个EventObserver
  bool remove(EventObserver<T> observer) {
    return _observerList.remove(observer);
  }

  /// 遍历所有的EventObserver并发送消息
  void post(T? event) {
    for (var observer in _observerList) {
      observer(event);
    }
  }
}
