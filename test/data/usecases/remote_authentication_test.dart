import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_authentication_test.mocks.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});
  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({required String url, required String method}) async {}
}

@GenerateMocks([HttpClient])
void main() {
  late HttpClient httpClient;
  late String url;
  late RemoteAuthentication sut;

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test("Should call HttpClient With correct URL", () async {
    await sut.auth();

    verify(httpClient.request(url: url, method: 'post'));
  });
  test("Should call HttpClient With correct Values", () async {
    await sut.auth();

    verify(httpClient.request(
      url: url,
      method: 'post',
    ));
  });
}
