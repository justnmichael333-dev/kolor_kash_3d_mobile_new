import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart'; // from `flutterfire configure`
import 'screens/auth_gate.dart'; // we'll create this file below

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
    if (details.stack != null) {
      debugPrint(details.stack.toString());
    }
  };

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error, stackTrace) {
    debugPrint('Firebase initialization failed: $error');
    debugPrint(stackTrace.toString());
    rethrow;
  }

  runZonedGuarded(
    () => runApp(const KolorKashApp()),
    (error, stackTrace) {
      debugPrint('Uncaught zone error: $error');
      debugPrint(stackTrace.toString());
    },
  );
}

class KolorKashApp extends StatelessWidget {
  const KolorKashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kolor Kash 3D',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
class BattlesScreen extends StatelessWidget {
  static const routeName = '/battles';

  const BattlesScreen({Key? key}) : super(key: key);

  /// Expose route map so the main app can wire this screen into MaterialApp.routes
  static Map<String, WidgetBuilder> routes() {
    return {
      routeName: (context) => const BattlesScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kolor Kash Battles')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the battle arena; replace with your real battle screen
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BattleArenaPlaceholder()),
            );
          },
          child: const Text('Start Battle'),
        ),
      ),
    );
  }
}

class BattleArenaPlaceholder extends StatelessWidget {
  const BattleArenaPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battle Arena')),
      body: const Center(
        child: Text('Battle arena will be implemented here'),
      ),
    );
  }
}