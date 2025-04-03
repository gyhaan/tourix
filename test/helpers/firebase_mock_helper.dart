import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

typedef Callback = void Function(MethodCall call);

void setupFirebaseMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

Future<void> setupFirebaseCoreMocks() async {
  // Register the platform instance
  final platform = FirebasePlatform.instance = MockFirebasePlatform();

  // Register mock implementations
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_core'),
    (call) async {
      switch (call.method) {
        case 'Firebase#initializeCore':
          return [
            {
              'name': '[DEFAULT]',
              'options': {
                'apiKey': 'mock-api-key',
                'appId': 'mock-app-id',
                'messagingSenderId': 'mock-sender-id',
                'projectId': 'mock-project-id',
              },
              'pluginConstants': {},
            }
          ];
        case 'Firebase#initializeApp':
          final arguments = call.arguments as Map<String, dynamic>;
          return {
            'name': arguments['appName'],
            'options': arguments['options'],
            'pluginConstants': {},
          };
        default:
          return null;
      }
    },
  );
}

class MockFirebasePlatform extends FirebasePlatform {
  @override
  bool get isAutomaticDataCollectionEnabled => true;

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return MockFirebaseAppPlatform(
      name ?? '[DEFAULT]',
      options ?? defaultFirebaseOptions,
    );
  }

  @override
  FirebaseAppPlatform app([String name = '[DEFAULT]']) {
    return MockFirebaseAppPlatform(
      name,
      defaultFirebaseOptions,
    );
  }

  @override
  List<FirebaseAppPlatform> get apps => [
        MockFirebaseAppPlatform(
          '[DEFAULT]',
          defaultFirebaseOptions,
        )
      ];

  FirebaseOptions get defaultFirebaseOptions => const FirebaseOptions(
        apiKey: 'mock-api-key',
        appId: 'mock-app-id',
        messagingSenderId: 'mock-sender-id',
        projectId: 'mock-project-id',
      );
}

class MockFirebaseAppPlatform extends FirebaseAppPlatform {
  MockFirebaseAppPlatform(String name, FirebaseOptions options)
      : super(name, options);

  @override
  Future<void> delete() async {}

  @override
  Future<void> setAutomaticDataCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setAutomaticResourceManagementEnabled(bool enabled) async {}
}
