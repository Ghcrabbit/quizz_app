import 'package:app_cms_ghc/screens/main_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import './screens/test_type_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Ignorar se o Firebase já foi inicializado
    if (e is FirebaseException && e.code == 'duplicate-app') {
      print('Firebase already initialized.');
    } else {
      rethrow; // Rethrow outros erros
    }
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Captura de erros não tratados
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    try {
      await Future.delayed(const Duration(seconds: 3)); // Simulação de inicialização
      FlutterNativeSplash.remove(); // Remove a tela de splash
    } catch (error, stackTrace) {
      // Registra qualquer erro que ocorra durante a inicialização
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
