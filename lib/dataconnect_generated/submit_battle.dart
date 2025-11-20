part of 'generated.dart';


class SubmitBattleVariablesBuilder {
  String battleId;
  String coloredModelId;

  final FirebaseDataConnect _dataConnect;
  SubmitBattleVariablesBuilder(this._dataConnect, {required  this.battleId,required  this.coloredModelId,});
  Deserializer<SubmitBattleData> dataDeserializer = (dynamic json)  => SubmitBattleData.fromJson(jsonDecode(json));
  Serializer<SubmitBattleVariables> varsSerializer = (SubmitBattleVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<SubmitBattleData, SubmitBattleVariables>> execute() {
    return ref().execute();
  }

  MutationRef<SubmitBattleData, SubmitBattleVariables> ref() {
    SubmitBattleVariables vars= SubmitBattleVariables(battleId: battleId,coloredModelId: coloredModelId,);
    return _dataConnect.mutation("SubmitBattle", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SubmitBattleBattleSubmissionInsert {
  final String id;
  SubmitBattleBattleSubmissionInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SubmitBattleBattleSubmissionInsert otherTyped = other as SubmitBattleBattleSubmissionInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const SubmitBattleBattleSubmissionInsert({
    required this.id,
  });
}

@immutable
class SubmitBattleData {
  final SubmitBattleBattleSubmissionInsert battleSubmissionInsert;
  SubmitBattleData.fromJson(dynamic json)
      : battleSubmissionInsert = SubmitBattleBattleSubmissionInsert.fromJson(
            json['battleSubmission_insert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final SubmitBattleData otherTyped = other as SubmitBattleData;
    return battleSubmissionInsert == otherTyped.battleSubmissionInsert;
  }

  @override
  int get hashCode => battleSubmissionInsert.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'battleSubmission_insert': battleSubmissionInsert.toJson(),
    };
  }

  const SubmitBattleData({
    required this.battleSubmissionInsert,
  });
}

@immutable
class SubmitBattleVariables {
  final String battleId;
  final String coloredModelId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SubmitBattleVariables.fromJson(Map<String, dynamic> json):
  
  battleId = nativeFromJson<String>(json['battleId']),
  coloredModelId = nativeFromJson<String>(json['coloredModelId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SubmitBattleVariables otherTyped = other as SubmitBattleVariables;
    return battleId == otherTyped.battleId && 
    coloredModelId == otherTyped.coloredModelId;
    
  }
  @override
  int get hashCode => Object.hashAll([battleId.hashCode, coloredModelId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['battleId'] = nativeToJson<String>(battleId);
    json['coloredModelId'] = nativeToJson<String>(coloredModelId);
    return json;
  }

  const SubmitBattleVariables({
    required this.battleId,
    required this.coloredModelId,
  });
}

