import 'package:TDD_clean_architecture/core/network/network_info.dart';
import 'package:TDD_clean_architecture/core/util/presentation/input_converter.dart';
import 'package:TDD_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:TDD_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:TDD_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:TDD_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:TDD_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:TDD_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final sl = GetIt.instance; // service locator

Future<void> init() async {
  //? Features - Number Trivia
  // BLoC
  /// classes requiring cleanup (such as [Bloc]) shouldn't be registered as singletons.
  sl.registerFactory(() {
    return NumberTriviaBloc(
      inputConverter: sl(),
      concrete: sl(),
      random: sl(),
    );
  });

  // Use cases
  /// both the use cases points to the contract (abstract) so it is necessary
  /// in 'Repository' below to instruct that when it resolves to
  /// [NumberTriviaRepository] it actually has to instantiate [NumberTriviaRepositoryImpl]
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            networkInfo: sl(),
            localDataSource: sl(),
            remoteDataSource: sl(),
          ));

  // Data Sources
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));

  //? Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //? External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
