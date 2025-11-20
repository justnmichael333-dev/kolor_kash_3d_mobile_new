part of 'generated.dart';

class GetModel3dVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetModel3dVariablesBuilder(this._dataConnect, );
  Deserializer<GetModel3dData> dataDeserializer = (dynamic json)  => GetModel3dData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetModel3dData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetModel3dData, void> ref() {
    
    return _dataConnect.query("GetModel3D", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetModel3dModel3ds {
  final String id;
  final String name;
  final String? description;
  final String modelDataUrl;
  final String? thumbnailUrl;
  final int? kashUnlockPrice;
  GetModel3dModel3ds.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']),
  modelDataUrl = nativeFromJson<String>(json['modelDataUrl']),
  thumbnailUrl = json['thumbnailUrl'] == null ? null : nativeFromJson<String>(json['thumbnailUrl']),
  kashUnlockPrice = json['kashUnlockPrice'] == null ? null : nativeFromJson<int>(json['kashUnlockPrice']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetModel3dModel3ds otherTyped = other as GetModel3dModel3ds;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    description == otherTyped.description && 
    modelDataUrl == otherTyped.modelDataUrl && 
    thumbnailUrl == otherTyped.thumbnailUrl && 
    kashUnlockPrice == otherTyped.kashUnlockPrice;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, description.hashCode, modelDataUrl.hashCode, thumbnailUrl.hashCode, kashUnlockPrice.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    json['modelDataUrl'] = nativeToJson<String>(modelDataUrl);
    if (thumbnailUrl != null) {
      json['thumbnailUrl'] = nativeToJson<String?>(thumbnailUrl);
    }
    if (kashUnlockPrice != null) {
      json['kashUnlockPrice'] = nativeToJson<int?>(kashUnlockPrice);
    }
    return json;
  }

  const GetModel3dModel3ds({
    required this.id,
    required this.name,
    this.description,
    required this.modelDataUrl,
    this.thumbnailUrl,
    this.kashUnlockPrice,
  });
}

@immutable
class GetModel3dData {
  final List<GetModel3dModel3ds> model3DS;
  GetModel3dData.fromJson(dynamic json):
  
  model3DS = (json['model3DS'] as List<dynamic>)
        .map((e) => GetModel3dModel3ds.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetModel3dData otherTyped = other as GetModel3dData;
    return model3DS == otherTyped.model3DS;
    
  }
  @override
  int get hashCode => model3DS.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['model3DS'] = model3DS.map((e) => e.toJson()).toList();
    return json;
  }

  const GetModel3dData({
    required this.model3DS,
  });
}

