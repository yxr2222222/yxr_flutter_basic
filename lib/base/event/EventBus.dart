import 'package:yxr_flutter_basic/base/event/EventListener.dart';

class EventBus {
  static final Map<String, List<EventListener>> _eventMap = {};

  EventBus._();

  /// 注册监听
  static register(String eventKey, EventListener listener) {
    var listenerList = _eventMap[eventKey];
    if (listenerList == null) {
      listenerList = [];
      _eventMap[eventKey] = listenerList;
    }
    if (!listenerList.contains(listener)) {
      listenerList.add(listener);
    }
  }

  /// 注销监听
  static unregister(String eventKey, EventListener listener) {
    var listenerList = _eventMap[eventKey];
    if (listenerList != null) {
      listenerList.remove(listener);
    }
  }

  /// 发送消息
  static postEvent(String eventKey, dynamic event) {
    _eventMap[eventKey]?.forEach((element) {
      element.onEvent(event);
    });
  }
}
