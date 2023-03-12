import 'package:cleanarchitecture_tdd/core/usecases/usecase.dart';
import 'package:cleanarchitecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:cleanarchitecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanarchitecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_random_number_trivia_test.mocks.dart';

class RandomNumberTriviaRepositoryTest extends Mock
    implements NumberTriviaRepository {}

@GenerateNiceMocks([MockSpec<RandomNumberTriviaRepositoryTest>()])
void main() {
  late GetRandomNumberTrivia usecase;
  late RandomNumberTriviaRepositoryTest mockRandomNumberTriviaRepositoryTest;
  setUp(() {
    mockRandomNumberTriviaRepositoryTest =
        MockRandomNumberTriviaRepositoryTest();
    usecase = GetRandomNumberTrivia(mockRandomNumberTriviaRepositoryTest);
  });

  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test("should get random trivia from the repository", () async {
    // # Arrange phase or stubbing the mock
    // "On the fly" implementation of the Repository using the Mockito package.
    // When getRandomNumberTrivia is called with any argument, always answer with
    // the Right "side" of Either containing a test NumberTrivia object.

    when(mockRandomNumberTriviaRepositoryTest.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));
    // # Act phase
    // The "act" phase of the test. Call the not-yet-existent method.
    // UseCase should simply return whatever was returned from the Repository
    final result = await usecase(NoParams());

    // # Assert phase
    expect(result, const Right(tNumberTrivia));
    // Verify that the method has been called on the Repository

    verify(mockRandomNumberTriviaRepositoryTest.getRandomNumberTrivia());
    // Only the above method should be called and nothing more.
    verifyNoMoreInteractions(mockRandomNumberTriviaRepositoryTest);
  });
}
