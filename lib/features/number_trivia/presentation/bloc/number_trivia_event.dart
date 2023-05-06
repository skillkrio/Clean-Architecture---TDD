part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumberEvent extends NumberTriviaEvent {
  final String numberString;
  const GetTriviaForConcreteNumberEvent({
    required this.numberString,
  });

  @override
  List<Object> get props => [numberString];

  @override
  String toString() =>
      'GetTriviaForConcreteNumberEvent(numberString: $numberString)';

  GetTriviaForConcreteNumberEvent copyWith({
    String? numberString,
  }) {
    return GetTriviaForConcreteNumberEvent(
      numberString: numberString ?? this.numberString,
    );
  }
}

class GetTriviaForRandomNumberEvent extends NumberTriviaEvent {
  const GetTriviaForRandomNumberEvent();

  @override
  List<Object> get props => [];
}
