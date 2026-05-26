import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/src/core/app_constant.dart';
import '/src/core/app_routes.dart';
import '/src/core/app_theme.dart';
import '/src/ui/app/theme_provider.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  final String fontFamily = "Montserrat";

  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Consumer<ThemeProvider>(
        builder: (context, ThemeProvider provider, child) {
      return MaterialApp(
        title: 'Math Mania',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        darkTheme: AppTheme.darkTheme,
        themeMode: provider.themeMode,
        initialRoute: KeyUtil.splash,
        routes: appRoutes,
        builder: (context, child) => _BrowserViewport(child: child),
      );
    });
  }
}

class _BrowserViewport extends StatelessWidget {
  const _BrowserViewport({required this.child});

  final Widget? child;

  static const _phoneAspectRatio = 390 / 844;
  static const _maxPhoneWidth = 430.0;

  @override
  Widget build(BuildContext context) {
    final isDesktopTarget = kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;

    if (!isDesktopTarget || child == null) {
      return child ?? const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        var phoneWidth = math.min(_maxPhoneWidth, availableWidth);
        var phoneHeight = phoneWidth / _phoneAspectRatio;

        if (phoneHeight > availableHeight) {
          phoneHeight = availableHeight;
          phoneWidth = phoneHeight * _phoneAspectRatio;
        }

        final mediaQuery = MediaQuery.of(context);

        return ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Center(
            child: SizedBox(
              width: phoneWidth,
              height: phoneHeight,
              child: MediaQuery(
                data: mediaQuery.copyWith(
                  size: Size(phoneWidth, phoneHeight),
                  padding: EdgeInsets.zero,
                  viewPadding: EdgeInsets.zero,
                  viewInsets: EdgeInsets.zero,
                ),
                child: child!,
              ),
            ),
          ),
        );
      },
    );
  }
}
