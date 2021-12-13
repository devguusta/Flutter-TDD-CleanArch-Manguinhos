import 'dart:convert';

import 'package:curso_manguinho/domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;
  RemoteAccountModel({
    required this.accessToken,
  });

  RemoteAccountModel copyWith({
    String? accessToken,
  }) {
    return RemoteAccountModel(
      accessToken: accessToken ?? this.accessToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
    };
  }

  factory RemoteAccountModel.fromMap(Map<String, dynamic> map) {
    return RemoteAccountModel(
      accessToken: map['accessToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoteAccountModel.fromJson(String source) =>
      RemoteAccountModel.fromMap(json.decode(source));

  @override
  String toString() => 'RemoteAccountModel(accessToken: $accessToken)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RemoteAccountModel && other.accessToken == accessToken;
  }

  @override
  int get hashCode => accessToken.hashCode;

  AccountEntity toEntity() => AccountEntity(accessToken);
}
