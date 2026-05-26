import 'package:flutter/material.dart';
import '/src/core/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  DifficultyType difficultyType = DifficultyType.MEDIUM;
  bool isTimedMode = true;
  bool includeMultiplicationDivision = true;

  final SharedPreferences sharedPreferences;

  ThemeProvider({required this.sharedPreferences}) {
    themeMode =
        ThemeMode.values[sharedPreferences.getInt(KeyUtil.IS_DARK_MODE) ?? 2];
    difficultyType =
        DifficultyType.values[sharedPreferences.getInt("difficulty") ?? 2];
    isTimedMode = sharedPreferences.getBool(KeyUtil.IS_TIMED_MODE) ?? true;
    includeMultiplicationDivision =
        sharedPreferences.getBool(KeyUtil.INCLUDE_MULTIPLICATION_DIVISION) ??
            true;
  }

  void changeTheme() async {
    if (themeMode == ThemeMode.light)
      themeMode = ThemeMode.dark;
    else
      themeMode = ThemeMode.light;
    notifyListeners();
    await sharedPreferences.setInt(KeyUtil.IS_DARK_MODE, themeMode.index);
  }

  Future<void> changeDifficulty(DifficultyType difficultyType) async {
    this.difficultyType = difficultyType;
    notifyListeners();
    await sharedPreferences.setInt("difficulty", difficultyType.index);
  }

  Future<void> changeTimedMode(bool isTimedMode) async {
    this.isTimedMode = isTimedMode;
    notifyListeners();
    await sharedPreferences.setBool(KeyUtil.IS_TIMED_MODE, isTimedMode);
  }

  Future<void> changeMultiplicationDivisionMode(
    bool includeMultiplicationDivision,
  ) async {
    this.includeMultiplicationDivision = includeMultiplicationDivision;
    notifyListeners();
    await sharedPreferences.setBool(
      KeyUtil.INCLUDE_MULTIPLICATION_DIVISION,
      includeMultiplicationDivision,
    );
  }
}
