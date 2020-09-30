import 'package:TDD_clean_architecture/core/errors/exception.dart';
import 'package:TDD_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:TDD_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClient([int statusCode = 200]) {
    switch (statusCode) {
      case 200:
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(
            fixture('trivia.json'),
            200,
          ),
        );
        break;
      case 400:
      case 404:
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response('Something went wrong', 404));
        break;
    }
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        '''should perform a GET request to an URL with number being the endpoint
         and with application/json header''', () async {
      // arrange
      setUpMockHttpClient();
      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(
        mockHttpClient.get('http://numbersapi.com/$tNumber', headers: {
          'Content-Type': 'application/json',
        }),
      );
    });

    test('should return [NumberTrivia] when the response code is 200',
        () async {
      // arrange
      setUpMockHttpClient();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw [ServerException] when the response code is not 200',
        () async {
      // arrange
      setUpMockHttpClient(404);
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        'should perform a GET request to an URL and with application/json header',
        () async {
      // arrange
      setUpMockHttpClient();
      // act
      dataSource.getRandomNumberTrivia();
      // assert
      verify(
        mockHttpClient.get('http://numbersapi.com/random', headers: {
          'Content-Type': 'application/json',
        }),
      );
    });

    test('should return [NumberTrivia] when the response code is 200',
        () async {
      // arrange
      setUpMockHttpClient();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw [ServerException] when the response code is not 200',
        () async {
      // arrange
      setUpMockHttpClient(404);
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
