import 'package:flutter/material.dart';
import '/src/core/app_constant.dart';

class TimeProvider with ChangeNotifier {
  TimeProvider({
    required TickerProvider vsync,
    required this.totalTime,
    required this.isTimed,
  }) {
    _animationController = AnimationController(
      vsync: vsync,
      value: 1.0,
      duration: Duration(seconds: totalTime),
      animationBehavior: AnimationBehavior.preserve,
    )..addStatusListener((status) {
        if (status == AnimationStatus.dismissed &&
            dialogType == DialogType.non) {
          dialogType = DialogType.over;
          timerStatus = TimerStatus.pause;
          notifyListeners();
        }
      });
  }

  final int totalTime;
  final bool isTimed;

  DialogType dialogType = DialogType.non;
  TimerStatus timerStatus = TimerStatus.restart;

  late final AnimationController _animationController;

  Animation<double> get animation => _animationController;

  void startTimer() {
    if (isTimed) {
      _animationController.reverse();
    } else {
      _animationController.value = 1.0;
    }
    timerStatus = TimerStatus.play;
    dialogType = DialogType.non;
  }

  void pauseTimer() {
    if (isTimed) {
      _animationController.stop();
    }
    timerStatus = TimerStatus.pause;
  }

  void resumeTimer() {
    if (isTimed) {
      _animationController.reverse();
    }
    timerStatus = TimerStatus.play;
  }

  void reset() {
    _animationController.value = 1.0;
  }

  void restartTimer() {
    if (isTimed) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.value = 1.0;
    }
    timerStatus = TimerStatus.play;
    dialogType = DialogType.non;
  }

  void increase() {
    if (!isTimed) {
      return;
    }
    _animationController.value = _animationController.value + 0.05;
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
