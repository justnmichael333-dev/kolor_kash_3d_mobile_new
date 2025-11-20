part of 'generated.dart';

class CreateNewUserVariablesBuilder {
  String email;
  String username;

  final FirebaseDataConnect _dataConnect;
  CreateNewUserVariablesBuilder(
    this._dataConnect, {
    required this.email,
    required this.username,
  });

  CreateNewUserData _dataDeserializer(dynamic json) =>
      CreateNewUserData.fromJson(jsonDecode(json));

  String _varsSerializer(CreateNewUserVariables vars) =>
      jsonEncode(vars.toJson());

  Future<OperationResult<CreateNewUserData, CreateNewUserVariables>> execute() {
    return ref().execute();
  }

  // Fix: Use existing class instead of undefined OperationRef and match usage with _dataConnect interface
  OperationRef<CreateNewUserData, CreateNewUserVariables> ref() {
    final vars = CreateNewUserVariables(
      email: email,
      username: username,
    );
    return _dataConnect.mutation(
      "CreateNewUser",
      _dataDeserializer,
      _varsSerializer,
      vars,
    );
  }
}

@immutable
class CreateNewUserUserInsert {
  final String id;
  CreateNewUserUserInsert.fromJson(dynamic json)
      : id = json['id'] as String;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateNewUserUserInsert otherTyped = other as CreateNewUserUserInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  const CreateNewUserUserInsert({
    required this.id,
  });
}

@immutable
class CreateNewUserData {
  final CreateNewUserUserInsert userInsert;

  CreateNewUserData.fromJson(dynamic json)
      : userInsert = CreateNewUserUserInsert.fromJson(json['user_insert']);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateNewUserData otherTyped = other as CreateNewUserData;
    return userInsert == otherTyped.userInsert;
  }

  @override
  int get hashCode => userInsert.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'user_insert': userInsert.toJson(),
    };
  }

  const CreateNewUserData({
    required this.userInsert,
  });
}

@immutable
class CreateNewUserVariables {
  final String email;
  final String username;

  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateNewUserVariables.fromJson(Map<String, dynamic> json)
      : email = json['email'] as String,
        username = json['username'] as String;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateNewUserVariables otherTyped = other as CreateNewUserVariables;
    return email == otherTyped.email && username == otherTyped.username;
  }

  @override
  int get hashCode => Object.hashAll([email.hashCode, username.hashCode]);

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
    };
  }

  const CreateNewUserVariables({
    required this.email,
    required this.username,
  });
}

