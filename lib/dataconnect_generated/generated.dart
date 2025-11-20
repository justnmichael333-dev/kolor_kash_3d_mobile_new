library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

part 'create_new_user.dart';

part 'get_model3d.dart';

part 'submit_battle.dart';

part 'get_user_kash_balance.dart';







class ExampleConnector {
  
  
  CreateNewUserVariablesBuilder createNewUser ({required String email, required String username, }) {
    return CreateNewUserVariablesBuilder(dataConnect, email: email,username: username,);
  }
  
  
  GetModel3dVariablesBuilder getModel3d () {
    return GetModel3dVariablesBuilder(dataConnect, );
  }
  
  
  SubmitBattleVariablesBuilder submitBattle ({required String battleId, required String coloredModelId, }) {
    return SubmitBattleVariablesBuilder(dataConnect, battleId: battleId,coloredModelId: coloredModelId,);
  }
  
  
  GetUserKashBalanceVariablesBuilder getUserKashBalance () {
    return GetUserKashBalanceVariablesBuilder(dataConnect, );
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-south1',
    'example',
    'kolorkash3dmobilenew',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
