import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_authentication_test.mocks.dart';
import 'package:curso_manguinho/domain/usecases/authentication.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});
  Future<void> auth({required AuthenticationParams params}) async {
    await httpClient.request(url: url, method: 'post', body: params.toJson());
  }
}

abstract class HttpClient {
  Future<void> request({required String url, required String method, Map body});
}

@GenerateMocks([HttpClient])
void main() {
  late HttpClient httpClient;
  late String url;
  late RemoteAuthentication sut;
  final params = AuthenticationParams(
      email: faker.internet.email(), secret: faker.internet.password());

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test("Should call HttpClient With correct Values", () async {
    await sut.auth(params: params);

    verify(httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.secret}));
  });
}
