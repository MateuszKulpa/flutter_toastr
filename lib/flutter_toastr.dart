library flutter_toastr;

import 'package:flutter/material.dart';
import 'package:flutter_toastr/notification_type.dart';
export 'package:flutter_toastr/notification_type.dart';

const _defaultDuration = Duration(seconds: 2);
const _defaultAlignment = Alignment.bottomCenter;

class Toastr {
  static void show({
    @required BuildContext context,
    @required NotificationType type,
    @required Widget child,
    Duration duration = _defaultDuration,
    Alignment alignment = _defaultAlignment,
  }) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = new OverlayEntry(
      builder: (BuildContext context) => _ToastWidget(
            duration: duration,
            type: type,
            child: child,
            alignment: alignment,
          ),
    );
    overlayState.insert(overlayEntry);

    //TODO remove overlay
  }

  static void success(
      {@required BuildContext context,
      @required Widget child,
      Duration duration,
      Alignment alignment}) {
    show(
      context: context,
      child: child,
      type: NotificationType.success,
      duration: duration = _defaultDuration,
      alignment: alignment = _defaultAlignment,
    );
  }

  static void info(
      {@required BuildContext context,
      @required Widget child,
      Duration duration,
      Alignment alignment}) {
    show(
      context: context,
      child: child,
      type: NotificationType.info,
      duration: duration = _defaultDuration,
      alignment: alignment = _defaultAlignment,
    );
  }

  static void warning(
      {@required BuildContext context,
      @required Widget child,
      Duration duration,
      Alignment alignment}) {
    show(
      context: context,
      child: child,
      type: NotificationType.warning,
      duration: duration = _defaultDuration,
      alignment: alignment = _defaultAlignment,
    );
  }

  static void error(
      {@required BuildContext context,
      @required Widget child,
      Duration duration,
      Alignment alignment}) {
    show(
      context: context,
      child: child,
      type: NotificationType.error,
      duration: duration = _defaultDuration,
      alignment: alignment = _defaultAlignment,
    );
  }
}

class _ToastWidget extends StatefulWidget {
  final Widget child;
  final Alignment alignment;
  final Duration duration;
  final NotificationType type;

  const _ToastWidget({
    Key key,
    this.alignment,
    this.duration,
    this.type,
    this.child,
  }) : super(key: key);

  @override
  _ToastWidgetState createState() => new _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(widget.duration + Duration(milliseconds: 200), () {
            _controller.reverse();
          });
        }
      });

    _scale = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Align(
        alignment: widget.alignment,
        child: ScaleTransition(
          scale: _scale,
          child: IgnorePointer(
            child: Material(
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: _getColorByToastType(widget.type),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 8.0,
                            offset: Offset(0, 6),
                            spreadRadius: 0.5)
                      ]),
                  margin: EdgeInsets.all(24.0),
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: widget.child),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorByToastType(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.error:
        return Colors.red;
      default: 
        throw ArgumentError('Cannot match notification color');
    }
  }
}
