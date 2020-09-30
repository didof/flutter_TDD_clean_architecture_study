import 'package:TDD_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:TDD_clean_architecture/core/errors/failure.dart';
import 'package:TDD_clean_architecture/core/usecases.dart';
import 'package:TDD_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
