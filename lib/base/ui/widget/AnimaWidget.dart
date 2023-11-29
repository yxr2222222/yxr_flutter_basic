import 'package:flutter/material.dart';

class AnimaWidget extends StatefulWidget {
  final Duration duration;
  final Widget Function(BuildContext context, double value) onChildBuilder;
  final AnimationStatusListener? listener;
  final AnimationCtx? animationCtx;
  final double from;
  final double to;
  final double initValue;

  /// 属性动画组件
  /// [duration] 动画执行的时长
  /// [onChildBuilder] 子组件创建器
  /// [animationCtx] 动画控制器，用于控制动画
  /// [from] 开始的属性值，默认为0
  /// [to] 目标的属性值，默认为1
  /// [initValue] 初始的属性值
  /// [listener] 动画监听
  const AnimaWidget(
      {Key? key,
      required this.duration,
      required this.onChildBuilder,
      this.animationCtx,
      this.from = 0.0,
      this.to = 1.0,
      double? initValue,
      this.listener})
      : initValue = initValue ?? from,
        super(key: key);

  @override
  State<AnimaWidget> createState() => _AnimaWidgetState();
}

class _AnimaWidgetState extends State<AnimaWidget>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween(begin: widget.from, end: widget.to)
        .animate(_animationController!);

    _animationController?.value = widget.initValue;
    widget.animationCtx?._controller = _animationController;

    var listener = widget.listener;
    if (listener != null) {
      _animation?.addStatusListener(listener);
    }
  }

  @override
  void dispose() {
    widget.animationCtx?._controller = null;
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var animation = _animationController!;
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return widget.onChildBuilder(context, animation.value);
      },
    );
  }
}

class AnimationCtx {
  AnimationController? _controller;

  AnimationController? get controller => _controller;

  /// 开始动画
  void start({double? from}) {
    _controller?.forward(from: from);
  }

  /// 停止动画
  void stop({bool canceled = true}) {
    _controller?.stop(canceled: canceled);
  }

  /// 反转动画
  void reverse({double? from}) {
    _controller?.reverse(from: from);
  }

  /// 重置动画
  void reset() {
    _controller?.reset();
  }
}
