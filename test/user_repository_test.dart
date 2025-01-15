// ignore_for_file: unused_import

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_api/user_model.dart';
import 'package:unit_api/user_repository.dart';
import 'package:http/http.dart';

class MockHTTPClient extends Mock implements Client {}

void main() {
  late UserRepository userRepository;
  late MockHTTPClient mockHTTPClient;

  setUp(() {
    mockHTTPClient = MockHTTPClient();
    userRepository = UserRepository(mockHTTPClient);
  });

  group("User Repository-", () {
    group("getUser Method", () {
      test(
          "Given UserRepository class when getUser method is called and status code is 200 then a user model should be returned",
          () async {
        // Arrange
        when(
          () => mockHTTPClient.get(
            Uri.parse("https://jsonplaceholder.typicode.com/users/1"),
          ),
        ).thenAnswer((_) async => Response('''
{
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "website": "hildegard.org"
}
''', 200));

        // Act
        final user = await userRepository.getUser();

        // Assert
        expect(user, isA<User>());
      });

      test("If status code is not 200 then throw an exception", () async {
        //Arrange
        when(
          () => mockHTTPClient.get(
            Uri.parse("https://jsonplaceholder.typicode.com/users/1"),
          ),
        ).thenAnswer(
          (_) async => Response("", 500),
        );
        //Act
        final user = userRepository.getUser();

        //Assert
        expect(user, throwsException);
      });
    });
  });
}
