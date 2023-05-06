import 'package:cleanarchitecture_tdd/core/error/failures.dart';
import 'package:cleanarchitecture_tdd/core/usecases/usecase.dart';
import 'package:cleanarchitecture_tdd/core/util/input_converter.dart';
import 'package:cleanarchitecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanarchitecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:cleanarchitecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:cleanarchitecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'number_trivia_bloc_test.mocks.dart';

class GetConcreteNumberTriviaTest extends Mock
    implements GetConcreteNumberTrivia {}

class GetRandomNumberTriviaTest extends Mock implements GetRandomNumberTrivia {}

class InputConverterTest extends Mock implements InputConverter {}

@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTriviaTest>(),
  MockSpec<GetRandomNumberTriviaTest>(),
  MockSpec<InputConverterTest>(),
])
void main() {
  late MockGetConcreteNumberTriviaTest mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTriviaTest mockGetRandomNumberTrivia;
  late MockInputConverterTest mockInputConverter;
  late NumberTriviaBloc numberTriviaBloc;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTriviaTest();
    mockGetRandomNumberTrivia = MockGetRandomNumberTriviaTest();
    mockInputConverter = MockInputConverterTest();
    numberTriviaBloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be Empty', () {
    // assert

    //.state will point to the current state inside the bloc. we passed Empty() in constructor
    expect(numberTriviaBloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    // The event takes in a String
    const tNumberString = '1';
    // This is the successful output of the InputConverter
    final tNumberParsed = int.parse(tNumberString);
    // NumberTrivia instance is needed too, of course
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async* {
        // arrange
        setUpMockInputConverterSuccess();
        // act
        numberTriviaBloc.add(
            const GetTriviaForConcreteNumberEvent(numberString: tNumberString));

        await untilCalled(
          mockInputConverter.stringToUnsignedInteger(any),
        );
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async* {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          // The initial state is always emitted first
          Empty(),
          const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(expected));
        // act
        numberTriviaBloc.add(
            const GetTriviaForConcreteNumberEvent(numberString: tNumberString));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        numberTriviaBloc.add(
            const GetTriviaForConcreteNumberEvent(numberString: tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async* {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          const Loaded(trivia: tNumberTrivia),
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(expected));
        // act
        numberTriviaBloc.add(
            const GetTriviaForConcreteNumberEvent(numberString: tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async* {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(expected));
        // act
        numberTriviaBloc.add(
            const GetTriviaForConcreteNumberEvent(numberString: tNumberString));
      },
    );
    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async* {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(expected));
        // act
        numberTriviaBloc.add(
            const GetTriviaForConcreteNumberEvent(numberString: tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        numberTriviaBloc.add(const GetTriviaForRandomNumberEvent());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async* {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          const Loaded(trivia: tNumberTrivia),
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(expected));
        // act
        numberTriviaBloc.add(const GetTriviaForRandomNumberEvent());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async* {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(expected));
        // act
        numberTriviaBloc.add(const GetTriviaForRandomNumberEvent());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async* {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(expected));
        // act
        numberTriviaBloc.add(const GetTriviaForRandomNumberEvent());
      },
    );
  });
}
