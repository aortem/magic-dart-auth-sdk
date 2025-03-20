import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/magic_auth_mock.dart';

void main() {
  group('magicAuth Tests', () {
    late MockmagicAuth mockmagicAuth;

    setUp(() {
      mockmagicAuth = MockmagicAuth();
    });

    test('performRequest handles typed arguments correctly', () async {
      // Arrange
      const endpoint = 'update';
      const body = {'key': 'value'};
      final expectedResponse = HttpResponse(
        statusCode: 200,
        body: {'message': 'Success'},
      );

      when(mockmagicAuth.performRequest(endpoint, body))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final result = await mockmagicAuth.performRequest(endpoint, body);

      // Assert
      expect(result.statusCode, equals(200));
      expect(result.body, containsPair('message', 'Success'));

      verify(mockmagicAuth.performRequest(endpoint, body)).called(1);
    });
  });
}
