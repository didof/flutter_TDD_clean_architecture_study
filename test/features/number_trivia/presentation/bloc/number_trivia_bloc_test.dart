import 'package:TDD_clean_architecture/core/errors/failure.dart';
import 'package:TDD_clean_architecture/core/usecases.dart';
import 'package:TDD_clean_architecture/core/util/presentation/input_converter.dart';
import 'package:TDD_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:TDD_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:TDD_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:TDD_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState shoul be [NumberTriviaInitial]', () {
    expect(bloc.initialState, equals(NumberTriviaInitial()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
    }

    test(
        '''should call the [InputConverter] to validate and convert the string to
        an unsigned integer''', () async {
      // arrange
      setUpMockInputConverterSuccess();
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit NumberTrivia[Initial, Error] when the input is invalid',
        () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      // assert later
      final expected = [
        NumberTriviaInitial(),
        NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      // assert

      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
    });

    test('should get data from the concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async {
        return Right(tNumberTrivia);
      });
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test(
        'should emit NumberTrivia[Initial, Loading, Loaded] when getting data is successful',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async {
        return Right(tNumberTrivia);
      });
      // assert later
      final expected = [
        NumberTriviaInitial(),
        NumberTriviaLoading(),
        NumberTriviaLoaded(trivia: tNumberTrivia),
      ];
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      // assert
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
    });
    test(
        'should emit NumberTrivia[Initial, Loading, ServerError] when getting data fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async {
        return Left(ServerFailure());
      });
      // assert later
      final expected = [
        NumberTriviaInitial(),
        NumberTriviaLoading(),
        NumberTriviaError(message: SERVER_FAILURE_MESSAGE),
      ];
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      // assert
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
    });
    test(
        'should emit NumberTrivia[Initial, Loading, CacheError] when getting data fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async {
        return Left(CacheFailure());
      });
      // assert later
      final expected = [
        NumberTriviaInitial(),
        NumberTriviaLoading(),
        NumberTriviaError(message: CACHE_FAILURE_MESSAGE),
      ];
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      // assert
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
    });
  });
  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

    test('should get data from the random use case', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async {
        return Right(tNumberTrivia);
      });
      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });
    test(
        'should emit NumberTrivia[Initial, Loading, Loaded] when getting data is successful',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async {
        return Right(tNumberTrivia);
      });
      // assert later
      final expected = [
        NumberTriviaInitial(),
        NumberTriviaLoading(),
        NumberTriviaLoaded(trivia: tNumberTrivia),
      ];
      // act
      bloc.add(GetTriviaForRandomNumber());
      // assert
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
    });
    test(
        'should emit NumberTrivia[Initial, Loading, ServerError] when getting data is successful',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async {
        return Left(ServerFailure());
      });
      // assert later
      final expected = [
        NumberTriviaInitial(),
        NumberTriviaLoading(),
        NumberTriviaError(message: SERVER_FAILURE_MESSAGE),
      ];
      // act
      bloc.add(GetTriviaForRandomNumber());
      // assert
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
    });
    test(
        'should emit NumberTrivia[Initial, Loading, CacheError] when getting data is successful',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async {
        return Left(CacheFailure());
      });
      // assert later
      final expected = [
        NumberTriviaInitial(),
        NumberTriviaLoading(),
        NumberTriviaError(message: CACHE_FAILURE_MESSAGE),
      ];
      // act
      bloc.add(GetTriviaForRandomNumber());
      // assert
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
    });
  });
}
