import 'package:flutter_test/flutter_test.dart';
import 'package:math_mania/src/core/app_constant.dart';
import 'package:math_mania/src/data/models/picture_puzzle.dart';
import 'package:math_mania/src/data/repository/picture_puzzle_repository.dart';
import 'package:math_mania/src/utility/math_util.dart';

void main() {
  bool hasMultiplicationOrDivision(Expression expression) {
    return expression.operator1 == '*' ||
        expression.operator1 == '/' ||
        expression.operator2 == '*' ||
        expression.operator2 == '/';
  }

  test('expression generator can exclude multiplication and division', () {
    for (var level = 1; level <= 8; level++) {
      final expressions = MathUtil.generate(
        level,
        20,
        includeMultiplicationDivision: false,
      );

      expect(expressions.any(hasMultiplicationOrDivision), isFalse);
    }
  });

  test('untimed add subtract difficulty changes operand size', () {
    final mediumExpressions = MathUtil.generate(
      1,
      20,
      includeMultiplicationDivision: false,
      difficultyType: DifficultyType.MEDIUM,
      isTimedMode: false,
    );

    for (final expression in mediumExpressions) {
      expect(int.parse(expression.firstOperand), greaterThanOrEqualTo(10));
      expect(int.parse(expression.secondOperand), greaterThanOrEqualTo(10));
    }

    final hardExpressions = MathUtil.generate(
      1,
      20,
      includeMultiplicationDivision: false,
      difficultyType: DifficultyType.HIGH,
      isTimedMode: false,
    );

    for (final expression in hardExpressions) {
      expect(int.parse(expression.firstOperand), greaterThanOrEqualTo(100));
      expect(int.parse(expression.secondOperand), greaterThanOrEqualTo(100));
    }
  });

  test('untimed hard multiplication division uses double digit range', () {
    final range = MathUtil.getMultiplicationDivisionRange(
      1,
      difficultyType: DifficultyType.HIGH,
      isTimedMode: false,
    );

    expect(range.min, 10);
    expect(range.max, 99);
  });

  test('math pairs can exclude multiplication and division', () {
    for (var level = 1; level <= 8; level++) {
      final expressions = MathUtil.getMathPair(
        level,
        10,
        includeMultiplicationDivision: false,
      );

      expect(expressions.any(hasMultiplicationOrDivision), isFalse);
    }
  });

  test('mental arithmetic can exclude multiplication and division', () {
    for (var level = 1; level <= 8; level++) {
      for (var i = 0; i < 10; i++) {
        final expression = MathUtil.getMentalExp(
          level,
          includeMultiplicationDivision: false,
        );

        expect(expression, isNotNull);
        expect(hasMultiplicationOrDivision(expression!), isFalse);
      }
    }
  });

  test('picture puzzle can exclude multiplication and division', () {
    final puzzles = PicturePuzzleRepository.getPicturePuzzleDataList(
      4,
      includeMultiplicationDivision: false,
    );

    for (final puzzle in puzzles) {
      for (final row in puzzle.list) {
        for (final item in row.shapeList) {
          if (item.type == PicturePuzzleQuestionItemType.sign) {
            expect(item.text, isNot(anyOf('*', '/')));
          }
        }
      }
    }
  });

  test('picture puzzle repeated shapes do not cancel themselves out', () {
    final addSubtractRow = PicturePuzzleRepository.getRowSecond(
      PicturePuzzleShapeType.SQUARE,
      '+',
      PicturePuzzleShapeType.CIRCLE,
      '-',
      '7',
      '3',
      '3',
      includeMultiplicationDivision: false,
    );

    expect(addSubtractRow.sign1, '+');
    expect(addSubtractRow.sign2, '+');

    final allOperationsRow = PicturePuzzleRepository.getRowThird(
      '+',
      PicturePuzzleShapeType.SQUARE,
      '-',
      PicturePuzzleShapeType.CIRCLE,
      '7',
      '3',
      '3',
    );

    expect(allOperationsRow.sign1, '+');
    expect(allOperationsRow.sign2, '*');
  });
}
