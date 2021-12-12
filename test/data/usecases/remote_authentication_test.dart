import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'remote_authentication_test.mocks.dart';

import 'package:curso_manguinho/data/usecases/usecases.dart';
import 'package:curso_manguinho/domain/helpers/helpers.dart';

import 'package:curso_manguinho/domain/usecases/usecases.dart';

import 'package:curso_manguinho/data/http/http.dart';

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
  test("Shouldthrow UnexpectedError if HttpClient returns 400", () async {
    when(
      httpClient.request(
        url: "url",
        method: "anyNamed('method')",
        body: {
          'email': faker.internet.email(),
          'password': faker.internet.password()
        },
      ),
    ).thenThrow(HttpError.badRequest);
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    final future = sut.auth(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });
}
