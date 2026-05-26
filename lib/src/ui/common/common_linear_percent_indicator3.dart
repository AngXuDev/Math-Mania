import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/game_provider.dart';

class CommonLinearPercentIndicator<T extends GameProvider>
    extends StatelessWidget {
  final double lineHeight;
  final LinearGradient linearGradient;
  final Color backgroundColor;

  CommonLinearPercentIndicator({
    this.lineHeight = 5.0,
    required this.linearGradient,
    this.backgroundColor = Colors.black12,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<T>(context);
    if (!model.isTimed) {
      return Container(
        height: lineHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: linearGradient,
        ),
        child: Text(
          "UNTIMED",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: model.animation,
      builder: (context, child) {
        return Container(
          height: lineHeight,
          color: backgroundColor,
          child: Transform(
            transform: Matrix4.diagonal3Values(model.animation.value, 1.0, 1.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: linearGradient,
              ),
            ),
          ),
        );
      },
    );
  }
}
