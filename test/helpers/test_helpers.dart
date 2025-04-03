import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'firestore_mocks.dart';
import 'firebase_mock_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

// Generate mocks for Firebase Auth
@GenerateMocks([FirebaseAuth, User, UserCredential])
import 'test_helpers.mocks.dart';

class TestData {
  static final Map<String, dynamic> mockUser = {
    'uid': 'test-user-id',
    'email': 'test@example.com',
    'role': 'user',
  };

  static final Map<String, dynamic> mockTrip = {
    'departureCity': 'London',
    'destinationCity': 'Paris',
    'availableSeats': ['A1', 'A2', 'A3', 'A4', 'A5'],
    'agencyID': 'test-agency-id',
  };

  static final Map<String, dynamic> mockBooking = {
    'travellerID': 'test-user-id',
    'tripID': 'test-trip-id',
    'departureTime': DateTime.now().add(const Duration(days: 1)),
    'seatsBooked': ['A1'],
    'active': true,
  };

  static final Map<String, dynamic> mockAgency = {
    'name': 'Luxury Bus',
    'email': 'agency@example.com',
  };
}

class TestHelpers {
  static late MockFirebaseAuth mockAuth;
  static late MockUser mockUser;
  static late MockUserCredential mockUserCredential;

  static void setupMocks() {
    // Setup Auth mocks
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();

    when(mockAuth.currentUser).thenReturn(mockUser);
    when(mockAuth.signInWithEmailAndPassword(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => mockUserCredential);
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn(TestData.mockUser['uid']);

    // Setup Firestore mocks
    FirestoreMocks.setupMocks();
  }

  static void setupAll() {
    setupMocks();
    setupFirebaseMocks();
  }

  static void tearDownAll() {
    // Clean up any resources if needed
  }

  static Future<void> setupFirestore({bool shouldThrowError = false}) async {
    // Setup Firestore mocks
    FirestoreMocks.setupMocks(shouldThrowError: shouldThrowError);
  }

  static void injectFirebaseInstances(
      FirebaseAuth auth, FirebaseFirestore firestore) {
    // Mock Firebase instances
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_auth'),
      (call) async {
        switch (call.method) {
          case 'Auth#authStateChanges':
            return null;
          default:
            return null;
        }
      },
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_firestore'),
      (call) async {
        switch (call.method) {
          case 'Query#get':
            return [];
          default:
            return null;
        }
      },
    );
  }
}
