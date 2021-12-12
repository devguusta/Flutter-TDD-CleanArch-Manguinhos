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
  late AuthenticationParams params;

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });

  test("Should call HttpClient With correct Values", () async {
    when(
      httpClient.request(
          url: url,
          method: "post",
          body: {'email': params.email, 'password': params.secret}),
    ).thenAnswer((_) async => {
          'accessToken': faker.guid.guid(),
          'name': faker.person.name(),
        });
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

    final future = sut.auth(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });
  test("Shouldthrow UnexpectedError if HttpClient returns 500", () async {
    when(httpClient.request(
      url: "url",
      method: "anyNamed('method')",
      body: {
        'email': faker.internet.email(),
        'password': faker.internet.password()
      },
    )).thenThrow(HttpError.serverError);

    final future = sut.auth(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });
  test("Should throw InvalidCredentialsError if HttpClient returns 401",
      () async {
    when(
      httpClient.request(
        url: "url",
        method: "anyNamed('method')",
        body: {
          'email': faker.internet.email(),
          'password': faker.internet.password()
        },
      ),
    ).thenThrow(HttpError.unauthorized);

    final future = sut.auth(params: params);
    expect(future, throwsA(DomainError.invalidCredentials));
  });
  test("Should return an Account if HttpClient returns 200", () async {
    final accessToken = faker.guid.guid();
    when(
      httpClient.request(
        url: "url",
        method: "anyNamed('method')",
        body: {
          'email': faker.internet.email(),
          'password': faker.internet.password()
        },
      ),
    ).thenAnswer((_) async => {
          'accessToken': accessToken,
          'name': faker.person.name(),
        });

    final account = await sut.auth(params: params);
    expect(account.token, accessToken);
  });
}
