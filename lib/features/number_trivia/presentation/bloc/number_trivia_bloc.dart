import 'dart:async';

import 'package:TDD_clean_architecture/core/errors/failure.dart';
import 'package:TDD_clean_architecture/core/usecases.dart';
import 'package:TDD_clean_architecture/core/util/presentation/input_converter.dart';
import 'package:TDD_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:TDD_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:TDD_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server failure';
const String CACHE_FAILURE_MESSAGE = 'Cache failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        assert(concrete != null),
        assert(random != null),
        super(NumberTriviaInitial());

  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaState get initialState => NumberTriviaInitial();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    yield NumberTriviaInitial();

    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold(
        (l) async* {
          yield NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (r) async* {
          yield NumberTriviaLoading();
          final triviaEither = await getConcreteNumberTrivia(Params(number: r));

          yield* triviaEither.fold((l) async* {
            yield NumberTriviaError(message: _mapFailureToMessage(l));
          }, (r) async* {
            yield NumberTriviaLoaded(trivia: r);
          });
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield NumberTriviaLoading();
      final triviaEither = await getRandomNumberTrivia(NoParams());

      yield* triviaEither.fold(
        (l) async* {
          yield NumberTriviaError(message: _mapFailureToMessage(l));
        },
        (r) async* {
          yield NumberTriviaLoaded(trivia: r);
        },
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
