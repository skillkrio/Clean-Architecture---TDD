import 'package:cleanarchitecture_tdd/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'network_info_test.mocks.dart';

class InternetConnectionCheckerTest extends Mock
    implements InternetConnectionChecker {}

@GenerateNiceMocks([MockSpec<InternetConnectionCheckerTest>()])
void main() {
  late InternetConnectionCheckerTest mockInternetConnectionTest;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    mockInternetConnectionTest = MockInternetConnectionCheckerTest();
    networkInfo = NetworkInfoImpl(mockInternetConnectionTest);
  });

  group('isConnected', () {
    test(
      'should forward the call to InternetConnectionChecker.hasConnection',
      () async {
        // arrange
        final tHasConnectionFuture = Future.value(true);

        when(mockInternetConnectionTest.hasConnection)
            .thenAnswer((_) => tHasConnectionFuture);
        // act
        // NOTICE: We're NOT awaiting the result
        final result = networkInfo.isConnected;
        // assert
        verify(mockInternetConnectionTest.hasConnection);
        // Utilizing Dart's default referential equality.
        // Only references to the same object are equal.
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
