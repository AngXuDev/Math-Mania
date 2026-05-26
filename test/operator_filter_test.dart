import 'package:flutter_test/flutter_test.dart';
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
}
