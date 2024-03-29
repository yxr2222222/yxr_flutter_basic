import 'package:yxr_flutter_basic/base/ui/widget/lifecycle/PageLifecycle.dart';

abstract interface class EventObservable<T> {
  /// 注册一个Observer，生命周期感知，自动取消订阅
  void observe(PageLifecycle lifecycle, EventObserver<T> observer);

  /// 发送消息
  void postEvent(T? event);
}

typedef EventObserver<T> = void Function(T? event);
