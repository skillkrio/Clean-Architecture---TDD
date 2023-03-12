import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cleanarchitecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:cleanarchitecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'get_concrete_number_trivia_test.mocks.dart';
import 'package:cleanarchitecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaRepositoryTest extends Mock
    implements NumberTriviaRepository {}

@GenerateNiceMocks([MockSpec<NumberTriviaRepositoryTest>()])
void main() {
  late GetConcreteNumberTrivia usecase;
  late NumberTriviaRepositoryTest mockNumberTriviaRepositoryTest;
  setUp(() {
    mockNumberTriviaRepositoryTest = MockNumberTriviaRepositoryTest();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepositoryTest);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test("should get trivia for the number from the repository", () async {
    // # Arrange phase or stubbing the mock
    // "On the fly" implementation of the Repository using the Mockito package.
    // When getConcreteNumberTrivia is called with any argument, always answer with
    // the Right "side" of Either containing a test NumberTrivia object.

    when(mockNumberTriviaRepositoryTest.getConcreteNumberTrivia(tNumber))
        .thenAnswer((_) async => const Right(tNumberTrivia));
    // # Act phase
    // The "act" phase of the test. Call the not-yet-existent method.
    // UseCase should simply return whatever was returned from the Repository
    final result = await usecase(Params(number: tNumber));

    // # Assert phase
    expect(result, const Right(tNumberTrivia));
    // Verify that the method has been called on the Repository

    verify(mockNumberTriviaRepositoryTest.getConcreteNumberTrivia(tNumber));
    // Only the above method should be called and nothing more.
    verifyNoMoreInteractions(mockNumberTriviaRepositoryTest);
  });
}
