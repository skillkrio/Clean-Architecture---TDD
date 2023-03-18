import 'package:cleanarchitecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required int number, required String text})
      : super(number: number, text: text);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
        number: (json["number"]).toInt(), text: json["text"]);
  }
  Map<String, dynamic> toJson() {
    return {"number": number, "text": text};
  }
}

// This is a syntactic sugar of the above version
// class NumberTriviaModel extends NumberTrivia {
//   const NumberTriviaModel({required super.text, required super.number});
// }



