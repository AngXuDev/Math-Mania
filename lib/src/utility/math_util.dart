import 'dart:math';

import '/src/core/app_constant.dart';

class MathUtil {
  static int evaluate(int x1, String sign, int x3) {
    switch (sign) {
      case "+":
        return x1 + x3;
      case "-":
        return x1 - x3;
      case "*":
        return x1 * x3;
      default:
        return x1 ~/ x3;
    }
  }

  static bool isOperator(String sign) {
    return ["+", "-", "*", "/"].contains(sign);
  }

  // ignore: missing_return
  static int getPrecedence(String sign) {
    switch (sign) {
      case "+":
        return 1;
      case "-":
        return 1;
      case "*":
        return 2;
      default:
        return 3;
    }
  }

  static int generateRandomAnswer(int min, int max) {
    final _random = new Random();
    int result = min + _random.nextInt(max - min);
    return result;
  }

  static String generateRandomSign({
    bool includeMultiplicationDivision = true,
  }) {
    var x = includeMultiplicationDivision ? ['/', '*', '-', '+'] : ['-', '+'];
    final _random = new Random();
    int result = _random.nextInt(x.length);
    return x[result];
  }

  static List<String> generateRandomSign1(
    int count, {
    bool includeMultiplicationDivision = true,
  }) {
    var listOfSign = <String>[];
    var sourceSigns =
        includeMultiplicationDivision ? ['/', '*', '-', '+'] : ['-', '+'];
    var list = List<List<String>>.generate(
      sourceSigns.length,
      (_) => sourceSigns,
    );

    while (listOfSign.length < count) {
      int row = Random().nextInt(sourceSigns.length);
      int col = Random().nextInt(sourceSigns.length);
      if (listOfSign.length == 0 || list[row][col] != listOfSign.last)
        listOfSign.add(list[row][col]);
    }
    return listOfSign;
  }

  static List<String> generateRandomNumber(int min, int max, int count) {
    var list = <List<int>>[];
    var listOfSign = <String>[];
    var listTemp = <int>[];

    for (int i = min; i <= max; i++) {
      listTemp.add(i);
    }
    for (int i = min; i <= max; i++) {
      list.add(listTemp);
    }
    while (listOfSign.length < count) {
      int row = Random().nextInt(max - min);
      int col = Random().nextInt(max - min);
      if (listOfSign.length == 0 ||
          list[row][col].toString() != listOfSign.last)
        listOfSign.add(list[row][col].toString());
    }
    return listOfSign;
  }

  static Expression getPlusSignExp(int min, int max) {
    var x = MathUtil.generateRandomNumber(min, max, 2);
    return Expression(
      firstOperand: x[0],
      operator1: "+",
      secondOperand: x[1],
      answer: int.parse(x[0]) + int.parse(x[1]),
      thirdOperand: '',
      operator2: null,
    );
  }

  static Expression getMinusSignExp(int min, int max) {
    var x1 = MathUtil.generateRandomNumber(max ~/ 2, max, 1);
    var x2 = MathUtil.generateRandomNumber(min, max, 1);
    while (int.parse(x2[0]) > int.parse(x1[0])) {
      x2 = MathUtil.generateRandomNumber(min, max, 1);
    }
    return Expression(
      firstOperand: x1[0],
      operator1: "-",
      secondOperand: x2[0],
      answer: int.parse(x1[0]) - int.parse(x2[0]),
      thirdOperand: '',
      operator2: null,
    );
  }

  static Expression getMultiplySignExp(int min, int max) {
    var x = MathUtil.generateRandomNumber(min, max, 2);

    return Expression(
      firstOperand: x[0],
      operator1: "*",
      secondOperand: x[1],
      answer: int.parse(x[0]) * int.parse(x[1]),
      thirdOperand: '',
      operator2: null,
    );
  }

  static Expression? getDivideSignExp(int min, int max) {
    var listTemp = <Map<String, String>>[];
    for (int i = min; i <= max; i++) {
      for (int j = min; j <= max; j++) {
        if (i != 1 && j != 1 && j != i && j % i == 0) {
          listTemp.add({j.toString(): i.toString()});
        }
      }
    }
    listTemp.shuffle();
    if (listTemp.length > 0) {
      var x = listTemp[Random().nextInt(listTemp.length)];
      return Expression(
        firstOperand: x.keys.first,
        operator1: "/",
        secondOperand: x.values.first,
        answer: int.parse(x.keys.first) ~/ int.parse(x.values.first),
        thirdOperand: '',
        operator2: null,
      );
    } else {
      return null;
    }
  }

  static Expression? getMixExp(
    int min,
    int max, {
    bool includeMultiplicationDivision = true,
    int? multiplicationMin,
    int? multiplicationMax,
  }) {
    int operand = int.parse(MathUtil.generateRandomNumber(min, max, 1).first);
    var signList = MathUtil.generateRandomSign1(
      2,
      includeMultiplicationDivision: includeMultiplicationDivision,
    );
    String firstSign = (MathUtil.getPrecedence(signList[0]) >=
            MathUtil.getPrecedence(signList[1]))
        ? signList[0]
        : "";
    String secondSign = (MathUtil.getPrecedence(signList[0]) >=
            MathUtil.getPrecedence(signList[1]))
        ? ""
        : signList[1];
    Expression? expression;
    Expression? finalExpression;

    switch (firstSign != "" ? firstSign : secondSign) {
      case "+":
        expression = MathUtil.getPlusSignExp(min, max);
        break;
      case "-":
        expression = MathUtil.getMinusSignExp(min, max);
        break;
      case "*":
        expression = MathUtil.getMultiplySignExp(
          multiplicationMin ?? 1,
          multiplicationMax ?? 15,
        );
        break;
      case "/":
        expression = MathUtil.getDivideSignExp(
          multiplicationMin ?? min,
          multiplicationMax ?? max,
        );
        break;
    }
    if (expression != null) {
      switch (firstSign != "" ? signList[1] : signList[0]) {
        case "+":
          if (firstSign != "")
            finalExpression = Expression(
                firstOperand: expression.firstOperand,
                operator1: expression.operator1,
                secondOperand: expression.secondOperand,
                operator2: "+",
                thirdOperand: operand.toString(),
                answer: expression.answer + operand);
          else
            finalExpression = Expression(
                firstOperand: operand.toString(),
                operator1: "+",
                secondOperand: expression.firstOperand,
                operator2: expression.operator1,
                thirdOperand: expression.secondOperand,
                answer: operand + expression.answer);
          break;
        case "-":
          if (firstSign != "") {
            if ((expression.answer - operand) < 0) {
              finalExpression = null;
            } else {
              finalExpression = Expression(
                  firstOperand: expression.firstOperand,
                  operator1: expression.operator1,
                  secondOperand: expression.secondOperand,
                  operator2: "-",
                  thirdOperand: operand.toString(),
                  answer: expression.answer - operand);
            }
          } else {
            if ((operand - expression.answer) < 0) {
              finalExpression = null;
            } else {
              finalExpression = Expression(
                  firstOperand: operand.toString(),
                  operator1: "-",
                  secondOperand: expression.firstOperand,
                  operator2: expression.operator1,
                  thirdOperand: expression.secondOperand,
                  answer: operand - expression.answer);
            }
          }
          break;
        case "*":
          if (firstSign != "")
            finalExpression = Expression(
                firstOperand: expression.firstOperand,
                operator1: expression.operator1,
                secondOperand: expression.secondOperand,
                operator2: "*",
                thirdOperand: operand.toString(),
                answer: expression.answer * operand);
          else
            finalExpression = Expression(
                firstOperand: operand.toString(),
                operator1: "*",
                secondOperand: expression.firstOperand,
                operator2: expression.operator1,
                thirdOperand: expression.secondOperand,
                answer: operand * expression.answer);

          break;
        case "/":
          if (firstSign != "") {
            if (expression.answer % operand == 0) {
              finalExpression = null;
            } else {
              finalExpression = Expression(
                  firstOperand: expression.firstOperand,
                  operator1: expression.operator1,
                  secondOperand: expression.secondOperand,
                  operator2: "/",
                  thirdOperand: operand.toString(),
                  answer: expression.answer ~/ operand);
            }
          } else {
            if (operand % expression.answer == 0) {
              finalExpression = null;
            } else {
              finalExpression = Expression(
                  firstOperand: operand.toString(),
                  operator1: "/",
                  secondOperand: expression.firstOperand,
                  operator2: expression.operator1,
                  thirdOperand: expression.secondOperand,
                  answer: operand ~/ expression.answer);
            }
          }
          break;
      }
    } else {
      finalExpression = expression;
    }
    return finalExpression;
  }

  static Expression? getMentalExp(
    int level, {
    bool includeMultiplicationDivision = true,
    DifficultyType difficultyType = DifficultyType.LOW,
    bool isTimedMode = true,
  }) {
    final addSubtractRange = getAddSubtractRange(
      level,
      difficultyType: difficultyType,
      isTimedMode: isTimedMode,
    );
    final multiplicationDivisionRange = getMultiplicationDivisionRange(
      level,
      difficultyType: difficultyType,
      isTimedMode: isTimedMode,
    );
    int operand = int.parse(MathUtil.generateRandomNumber(
      addSubtractRange.min,
      addSubtractRange.max,
      1,
    ).first);
    var signList = MathUtil.generateRandomSign1(
      2,
      includeMultiplicationDivision: includeMultiplicationDivision,
    );
    Expression? expression;
    Expression? finalExpression;

    switch (signList[0]) {
      case "+":
        expression = MathUtil.getPlusSignExp(
          addSubtractRange.min,
          addSubtractRange.max,
        );
        break;
      case "-":
        expression = MathUtil.getMinusSignExp(
          addSubtractRange.min,
          addSubtractRange.max,
        );
        break;
      case "*":
        expression = MathUtil.getMultiplySignExp(
          multiplicationDivisionRange.min,
          multiplicationDivisionRange.max,
        );
        break;
      case "/":
        expression = MathUtil.getDivideSignExp(
          multiplicationDivisionRange.min,
          multiplicationDivisionRange.max,
        );
        break;
    }
    if (expression != null) {
      switch (signList[1]) {
        case "+":
          finalExpression = Expression(
              firstOperand: expression.firstOperand,
              operator1: expression.operator1,
              secondOperand: expression.secondOperand,
              operator2: signList[1],
              thirdOperand: operand.toString(),
              answer: operand + expression.answer);
          break;
        case "-":
          finalExpression = Expression(
              firstOperand: expression.firstOperand,
              operator1: expression.operator1,
              secondOperand: expression.secondOperand,
              operator2: signList[1],
              thirdOperand: operand.toString(),
              answer: expression.answer - operand);
          break;
        case "*":
          finalExpression = Expression(
              firstOperand: expression.firstOperand,
              operator1: expression.operator1,
              secondOperand: expression.secondOperand,
              operator2: signList[1],
              thirdOperand: operand.toString(),
              answer: expression.answer * operand);

          break;
        case "/":
          if (expression.answer % operand != 0) {
            finalExpression = null;
          } else {
            finalExpression = Expression(
                firstOperand: expression.firstOperand,
                operator1: expression.operator1,
                secondOperand: expression.secondOperand,
                operator2: signList[1],
                thirdOperand: operand.toString(),
                answer: expression.answer ~/ operand);
          }
          break;
      }
    } else {
      finalExpression = expression;
    }
    return finalExpression;
  }

  static List<Expression> getMathPair(
    int level,
    int count, {
    bool includeMultiplicationDivision = true,
    DifficultyType difficultyType = DifficultyType.LOW,
    bool isTimedMode = true,
  }) {
    var list = <Expression>[];
    final addSubtractRange = getAddSubtractRange(
      level,
      difficultyType: difficultyType,
      isTimedMode: isTimedMode,
    );
    final multiplicationDivisionRange = getMultiplicationDivisionRange(
      level,
      difficultyType: difficultyType,
      isTimedMode: isTimedMode,
    );
    while (list.length < count) {
      MathUtil.generateRandomSign1(
        count - list.length,
        includeMultiplicationDivision: includeMultiplicationDivision,
      ).forEach((String sign) {
        Expression? expression;
        if (level <= 2) {
          switch (sign) {
            case "+":
              expression = MathUtil.getPlusSignExp(
                addSubtractRange.min,
                addSubtractRange.max,
              );
              break;
            case "-":
              expression = MathUtil.getMinusSignExp(
                addSubtractRange.min,
                addSubtractRange.max,
              );
              break;
            case "*":
              expression = MathUtil.getMultiplySignExp(
                multiplicationDivisionRange.min,
                multiplicationDivisionRange.max,
              );
              break;
            case "/":
              expression = MathUtil.getDivideSignExp(
                multiplicationDivisionRange.min,
                multiplicationDivisionRange.max,
              );
              break;
          }
        } else if (level <= 3) {
          switch (sign) {
            case "+":
              expression = MathUtil.getPlusSignExp(
                addSubtractRange.min,
                addSubtractRange.max,
              );
              break;
            case "-":
              expression = MathUtil.getMinusSignExp(
                addSubtractRange.min,
                addSubtractRange.max,
              );
              break;
            case "*":
              expression = MathUtil.getMultiplySignExp(
                multiplicationDivisionRange.min,
                multiplicationDivisionRange.max,
              );
              break;
            case "/":
              expression = MathUtil.getDivideSignExp(
                multiplicationDivisionRange.min,
                multiplicationDivisionRange.max,
              );
              break;
          }
        } else {
          switch (sign) {
            case "+":
              expression = MathUtil.getPlusSignExp(
                addSubtractRange.min,
                addSubtractRange.max,
              );
              break;
            case "-":
              expression = MathUtil.getMinusSignExp(
                addSubtractRange.min,
                addSubtractRange.max,
              );
              break;
            case "*":
              expression = MathUtil.getMultiplySignExp(
                multiplicationDivisionRange.min,
                multiplicationDivisionRange.max,
              );
              break;
            case "/":
              expression = MathUtil.getDivideSignExp(
                multiplicationDivisionRange.min,
                multiplicationDivisionRange.max,
              );
              break;
          }
        }
        if (expression != null && !list.contains(expression)) {
          list.add(expression);
        }
      });
    }
    return list;
  }

  static List<Expression> generate(
    int level,
    int count, {
    bool includeMultiplicationDivision = true,
    DifficultyType difficultyType = DifficultyType.LOW,
    bool isTimedMode = true,
  }) {
    var list = <Expression>[];
    final addSubtractRange = getAddSubtractRange(
      level,
      difficultyType: difficultyType,
      isTimedMode: isTimedMode,
    );
    final multiplicationDivisionRange = getMultiplicationDivisionRange(
      level,
      difficultyType: difficultyType,
      isTimedMode: isTimedMode,
    );
    while (list.length < count) {
      MathUtil.generateRandomSign1(
        count - list.length,
        includeMultiplicationDivision: includeMultiplicationDivision,
      ).forEach((String sign) {
        Expression? expression;
        if (level <= 2) {
          switch (sign) {
            case "+":
              expression = MathUtil.getPlusSignExp(
                addSubtractRange.min,
                addSubtractRange.max,
              );
              break;
            case "-":
              expression = MathUtil.getMinusSignExp(
                addSubtractRange.min,
                addSubtractRange.max,
              );
              break;
            case "*":
              expression = MathUtil.getMultiplySignExp(
                multiplicationDivisionRange.min,
                multiplicationDivisionRange.max,
              );
              break;
            case "/":
              expression = MathUtil.getDivideSignExp(
                multiplicationDivisionRange.min,
                multiplicationDivisionRange.max,
              );
              break;
          }
        } else if (level <= 4) {
          switch (sign) {
            case "+":
              expression = MathUtil.getPlusSignExp(
                addSubtractRange.min,
                addSubtractRange.max,
              );
              break;
            case "-":
              expression = MathUtil.getMinusSignExp(
                addSubtractRange.min,
                addSubtractRange.max,
              );
              break;
            case "*":
              expression = MathUtil.getMixExp(
                addSubtractRange.min,
                addSubtractRange.max,
                includeMultiplicationDivision: includeMultiplicationDivision,
                multiplicationMin: multiplicationDivisionRange.min,
                multiplicationMax: multiplicationDivisionRange.max,
              );
              break;
            case "/":
              expression = MathUtil.getDivideSignExp(
                multiplicationDivisionRange.min,
                multiplicationDivisionRange.max,
              );
              break;
          }
        } else if (level < 5) {
          expression = MathUtil.getMixExp(
            addSubtractRange.min,
            addSubtractRange.max,
            includeMultiplicationDivision: includeMultiplicationDivision,
            multiplicationMin: multiplicationDivisionRange.min,
            multiplicationMax: multiplicationDivisionRange.max,
          );
        } else if (level < 6) {
          expression = MathUtil.getMixExp(
            addSubtractRange.min,
            addSubtractRange.max,
            includeMultiplicationDivision: includeMultiplicationDivision,
            multiplicationMin: multiplicationDivisionRange.min,
            multiplicationMax: multiplicationDivisionRange.max,
          );
        } else {
          expression = MathUtil.getMixExp(
            addSubtractRange.min,
            addSubtractRange.max,
            includeMultiplicationDivision: includeMultiplicationDivision,
            multiplicationMin: multiplicationDivisionRange.min,
            multiplicationMax: multiplicationDivisionRange.max,
          );
        }
        if (expression != null && !list.contains(expression)) {
          list.add(expression);
        }
      });
    }
    return list;
  }

  static OperandRange getAddSubtractRange(
    int level, {
    DifficultyType difficultyType = DifficultyType.LOW,
    bool isTimedMode = true,
  }) {
    if (!isTimedMode) {
      switch (difficultyType) {
        case DifficultyType.HIGH:
          return OperandRange(100, 999);
        case DifficultyType.MEDIUM:
          return OperandRange(10, 99);
        case DifficultyType.LOW:
          break;
      }
    }

    return getDefaultRange(level);
  }

  static OperandRange getMultiplicationDivisionRange(
    int level, {
    DifficultyType difficultyType = DifficultyType.LOW,
    bool isTimedMode = true,
  }) {
    if (!isTimedMode && difficultyType == DifficultyType.HIGH) {
      return OperandRange(10, 99);
    }

    return getDefaultMultiplicationDivisionRange(level);
  }

  static OperandRange getDefaultRange(int level) {
    return OperandRange(
      level == 1 ? 1 : (5 * level) - 5,
      level == 1 ? 10 : (10 * level),
    );
  }

  static OperandRange getDefaultMultiplicationDivisionRange(int level) {
    if (level <= 2) {
      return OperandRange(1, 10);
    } else if (level <= 3) {
      return OperandRange(1, 15);
    } else {
      return OperandRange(5, 30);
    }
  }
}

void main() {}

class OperandRange {
  final int min;
  final int max;

  OperandRange(this.min, this.max);
}

class Expression {
  final String firstOperand;
  final String operator1;
  final String secondOperand;
  final String? operator2;
  final String thirdOperand;
  final int answer;

  Expression({
    required this.firstOperand,
    required this.operator1,
    required this.secondOperand,
    required this.operator2,
    required this.thirdOperand,
    required this.answer,
  });

  @override
  String toString() {
    return 'Expression{firstOperand: $firstOperand, operator1: $operator1, secondOperand: $secondOperand, operator2: $operator2, thirdOperand: $thirdOperand, answer: $answer}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expression &&
          runtimeType == other.runtimeType &&
          firstOperand == other.firstOperand &&
          operator1 == other.operator1 &&
          secondOperand == other.secondOperand &&
          operator2 == other.operator2 &&
          thirdOperand == other.thirdOperand &&
          answer == other.answer;

  @override
  int get hashCode =>
      firstOperand.hashCode ^
      operator1.hashCode ^
      secondOperand.hashCode ^
      operator2.hashCode ^
      thirdOperand.hashCode ^
      answer.hashCode;
}
