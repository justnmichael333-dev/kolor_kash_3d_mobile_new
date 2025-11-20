# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetModel3D
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getModel3d().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetModel3DData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getModel3d();
GetModel3DData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getModel3d().ref();
ref.execute();

ref.subscribe(...);
```


### GetUserKashBalance
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getUserKashBalance().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetUserKashBalanceData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getUserKashBalance();
GetUserKashBalanceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getUserKashBalance().ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateNewUser
#### Required Arguments
```dart
String email = ...;
String username = ...;
ExampleConnector.instance.createNewUser(
  email: email,
  username: username,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateNewUserData, CreateNewUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createNewUser(
  email: email,
  username: username,
);
CreateNewUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String email = ...;
String username = ...;

final ref = ExampleConnector.instance.createNewUser(
  email: email,
  username: username,
).ref();
ref.execute();
```


### SubmitBattle
#### Required Arguments
```dart
String battleId = ...;
String coloredModelId = ...;
ExampleConnector.instance.submitBattle(
  battleId: battleId,
  coloredModelId: coloredModelId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<SubmitBattleData, SubmitBattleVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.submitBattle(
  battleId: battleId,
  coloredModelId: coloredModelId,
);
SubmitBattleData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String battleId = ...;
String coloredModelId = ...;

final ref = ExampleConnector.instance.submitBattle(
  battleId: battleId,
  coloredModelId: coloredModelId,
).ref();
ref.execute();
```

