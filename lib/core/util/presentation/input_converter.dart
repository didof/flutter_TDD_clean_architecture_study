import 'package:TDD_clean_architecture/core/errors/exception.dart';
import 'package:TDD_clean_architecture/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw IntegerOutOfRangeException();
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    } on IntegerOutOfRangeException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object> get props => [];
}
