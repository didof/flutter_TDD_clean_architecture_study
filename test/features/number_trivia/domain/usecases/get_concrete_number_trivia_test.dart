import 'package:TDD_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:TDD_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'mock.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tText = 'test';
  final tNumberTrivia = NumberTrivia(number: tNumber, text: tText);

  test('should get trivia for the number repository', () async {
    // arrange
    // when getConcreteNumberTrivia is called with any argument, always answer
    // with the [NumberTrivia].
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));

    // act
    final result = await usecase(Params(number: tNumber));

    // assert
    // check if the execution of the usecase returned a [Right(NumberTrivia)]
    expect(result, Right(tNumberTrivia));
    // verify that the method has been called on the Repository
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
