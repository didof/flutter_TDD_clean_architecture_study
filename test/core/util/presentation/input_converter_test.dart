import 'package:TDD_clean_architecture/core/util/presentation/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  void expectLeftFailure(result) {
    expect(result, equals(Left(InvalidInputFailure())));
  }

  group('stringToUnsignedInteger', () {
    test(
        'should return an integer when the string represent an unsigned integer',
        () async {
      // arrange
      final str = '123';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, equals(Right(123)));
    });

    test('should return a Failure when the string is not an unsigned integer',
        () async {
      // arrange
      final str = 'A';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expectLeftFailure(result);
    });

    test('should return a Failure when the string is a negative integer',
        () async {
      // arrange
      final str = '-1';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expectLeftFailure(result);
    });
  });
}
