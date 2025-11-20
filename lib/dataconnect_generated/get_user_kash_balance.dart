part of 'generated.dart';

class GetUserKashBalanceVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetUserKashBalanceVariablesBuilder(this._dataConnect, );
  Deserializer<GetUserKashBalanceData> dataDeserializer = (dynamic json)  => GetUserKashBalanceData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetUserKashBalanceData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetUserKashBalanceData, void> ref() {
    
    return _dataConnect.query("GetUserKashBalance", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetUserKashBalanceUser {
  final int kashBalance;
  GetUserKashBalanceUser.fromJson(dynamic json):
  
  kashBalance = nativeFromJson<int>(json['kashBalance']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserKashBalanceUser otherTyped = other as GetUserKashBalanceUser;
    return kashBalance == otherTyped.kashBalance;
    
  }
  @override
  int get hashCode => kashBalance.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['kashBalance'] = nativeToJson<int>(kashBalance);
    return json;
  }

  const GetUserKashBalanceUser({
    required this.kashBalance,
  });
}

@immutable
class GetUserKashBalanceData {
  final GetUserKashBalanceUser? user;
  GetUserKashBalanceData.fromJson(dynamic json):
  
  user = json['user'] == null ? null : GetUserKashBalanceUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserKashBalanceData otherTyped = other as GetUserKashBalanceData;
    return user == otherTyped.user;
    
  }
  @override
  int get hashCode => user.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user != null) {
      json['user'] = user!.toJson();
    }
    return json;
  }

  const GetUserKashBalanceData({
    this.user,
  });
}

