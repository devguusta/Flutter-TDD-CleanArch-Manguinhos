import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/authentication.dart';
import '../http/http.dart';
import '../models/remote_account_model.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});
  Future<AccountEntity> auth({required AuthenticationParams params}) async {
    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAuthenticationParams.fromDomain(params).toJson(),
      );
      return RemoteAccountModel.fromMap(httpResponse['accessToken']).toEntity();
    } on HttpError catch (e) {
      throw e == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({required this.email, required this.password});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(email: params.email, password: params.secret);

  Map toJson() => {'email': email, 'password': password};
}
