// ignore_for_file: constant_identifier_names

import 'package:cleanarchitecture_tdd/core/error/failures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';
import '../../../../core/util/input_converter.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {
    on<GetTriviaForConcreteNumberEvent>(_handleGetConcreteNumberTrivia);
    on<GetTriviaForRandomNumberEvent>(_handleRandomNumberTrivia);
  }

  void _handleGetConcreteNumberTrivia(
      GetTriviaForConcreteNumberEvent event, Emitter<NumberTriviaState> emit) {
    final inputConverterEither =
        inputConverter.stringToUnsignedInteger(event.numberString);
    inputConverterEither.fold((failure) {
      emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
    }, (integer) async {
      emit(Loading());
      final failureOrTrivia =
          await getConcreteNumberTrivia(Params(number: integer));
      failureOrTrivia.fold((failure) {
        emit(Error(message: _mapFailureToMessage(failure)));
      }, (trivia) {
        emit(Loaded(trivia: trivia));
      });
    });
  }

  void _handleRandomNumberTrivia(GetTriviaForRandomNumberEvent event,
      Emitter<NumberTriviaState> emit) async {
    emit(Loading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    failureOrTrivia.fold((failure) {
      emit(Error(message: _mapFailureToMessage(failure)));
    }, (trivia) {
      emit(Loaded(trivia: trivia));
    });
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
