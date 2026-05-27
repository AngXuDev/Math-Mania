import 'dart:async';
import 'package:flutter/cupertino.dart';
import '/src/data/models/number_pyramid.dart';
import '/src/core/app_constant.dart';

import '/src/ui/app/game_provider.dart';

class NumberPyramidProvider extends GameProvider<NumberPyramid> {
  final DifficultyType difficultyType;

  NumberPyramidProvider({
    required TickerProvider vsync,
    required this.difficultyType,
  }) : super(
          vsync: vsync,
          gameCategoryType: GameCategoryType.NUMBER_PYRAMID,
          difficultyType: difficultyType,
        ) {
    startGame();
  }

  void pyramidBoxSelection(NumPyramidCellModel model) {
    if (model.isHint) {
      // you can't select/edit hint cell
      return;
    }
    //first find previously selected index
    var previouslySelectedCell =
        currentState.list.indexWhere((cell) => cell.isActive == true);
    if (!previouslySelectedCell.isNegative) {
      currentState.list[previouslySelectedCell].isActive = false;
    }
    currentState.list[model.id - 1].isActive = true;

    notifyListeners();
  }

  void pyramidBoxInputValue(String value) {
    if (value == "Clear") {
      clearWrongValues();
      return;
    }

    var currentActiveCellIndex =
        currentState.list.indexWhere((cell) => cell.isActive == true);
    if (currentActiveCellIndex == -1) {
      return;
    }
    if (value == "Back") {
      // if clear is pressed then empty existing text value and return
      _clearCell(currentState.list[currentActiveCellIndex]);
      notifyListeners();
      return;
    }
    var listOfCellWithValues =
        currentState.list.where((cell) => cell.text.isNotEmpty);

    if (value == "Done") {
      if (listOfCellWithValues.length == currentState.remainingCell) {
        checkCorrectValues();
        return;
      } else {
        return;
      }
    }

    var currentCellValue = currentState.list[currentActiveCellIndex].text;
    if (currentCellValue.isNotEmpty) {
      // check if already have value, then append
      var length = currentState.list[currentActiveCellIndex].text.length;
      if (length == 3) {
        // can't have more then 3 digits
        return;
      }
      currentState.list[currentActiveCellIndex].text = currentCellValue + value;
    } else {
      // fresh value
      currentState.list[currentActiveCellIndex].text = value;
    }

    _updateCellFeedback(currentState.list[currentActiveCellIndex]);
    notifyListeners();
  }

  void clearWrongValues() {
    for (final cell in currentState.list) {
      if (!cell.isHint && cell.isDone && !cell.isCorrect) {
        _clearCell(cell);
      }
    }
    notifyListeners();
  }

  Future<void> checkCorrectValues() async {
    for (int i = 0; i < currentState.list.length; i++) {
      if (!currentState.list[i].isHint) {
        if (!(currentState.list[i].numberOnCell ==
            int.parse(currentState.list[i].text))) {
          currentState.list[i].isCorrect = false;
          currentState.list[i].isDone = true;
        } else {
          currentState.list[i].isCorrect = true;
          currentState.list[i].isDone = true;
        }
      }
    }
    var correctVal = currentState.list.where((cell) => cell.isCorrect == true);

    if (correctVal.length == currentState.remainingCell) {
      await Future.delayed(Duration(milliseconds: 300));
      loadNewDataIfRequired();
      if (timerStatus != TimerStatus.pause) {
        restartTimer();
      }
      notifyListeners();
    }
  }

  void _updateCellFeedback(NumPyramidCellModel cell) {
    final expectedValue = cell.numberOnCell.toString();
    if (cell.text.length < expectedValue.length) {
      cell.isDone = false;
      cell.isCorrect = false;
      return;
    }

    cell.isDone = true;
    cell.isCorrect = cell.text == expectedValue;
  }

  void _clearCell(NumPyramidCellModel cell) {
    cell.text = "";
    cell.isDone = false;
    cell.isCorrect = false;
  }
}
