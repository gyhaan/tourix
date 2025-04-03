import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

class MockFirestore implements FirebaseFirestore {
  final Map<String, MockCollection> collections = {};
  bool shouldThrowError = false;

  @override
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    return collections.putIfAbsent(
        collectionPath, () => MockCollection(collectionPath, shouldThrowError));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockCollection implements CollectionReference<Map<String, dynamic>> {
  final String path;
  final Map<String, MockDocument> documents = {};
  final bool shouldThrowError;

  MockCollection(this.path, this.shouldThrowError);

  @override
  DocumentReference<Map<String, dynamic>> doc([String? documentPath]) {
    return documents.putIfAbsent(
        documentPath ?? '', () => MockDocument(documentPath ?? '', path));
  }

  @override
  Query<Map<String, dynamic>> where(Object field,
      {Object? isEqualTo,
      Object? isNotEqualTo,
      Object? isLessThan,
      Object? isLessThanOrEqualTo,
      Object? isGreaterThan,
      Object? isGreaterThanOrEqualTo,
      Object? arrayContains,
      Iterable<Object?>? arrayContainsAny,
      Iterable<Object?>? whereIn,
      Iterable<Object?>? whereNotIn,
      bool? isNull}) {
    return MockQuery(
        documents.values.toList(), field, isEqualTo, shouldThrowError);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockDocument implements DocumentReference<Map<String, dynamic>> {
  final String path;
  final String collectionPath;
  Map<String, dynamic>? _data;

  MockDocument(this.path, this.collectionPath);

  @override
  String get id => path;

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get(
      [GetOptions? options]) async {
    return MockDocumentSnapshot(_data, this);
  }

  @override
  Future<void> update(Map<Object, Object?> data) async {
    _data = {...?_data, ...Map<String, dynamic>.from(data)};
  }

  void setData(Map<String, dynamic> data) {
    _data = data;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockDocumentSnapshot implements DocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic>? _data;
  final MockDocument _ref;

  MockDocumentSnapshot(this._data, this._ref);

  @override
  bool get exists => _data != null;

  @override
  Map<String, dynamic>? data() => _data;

  @override
  dynamic get(Object field) => _data?[field];

  @override
  dynamic operator [](Object field) => get(field);

  @override
  String get id => _ref.id;

  @override
  DocumentReference<Map<String, dynamic>> get reference => _ref;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockQuery implements Query<Map<String, dynamic>> {
  final List<MockDocument> _docs;
  final Object _field;
  final Object? _isEqualTo;
  final bool shouldThrowError;

  MockQuery(this._docs, this._field, this._isEqualTo, this.shouldThrowError);

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([GetOptions? options]) async {
    if (shouldThrowError) {
      throw Exception('Failed to load trips');
    }

    final filteredDocs = _docs.where((doc) {
      final value = doc._data?[_field];
      if (_isEqualTo is DocumentReference && value is DocumentReference) {
        return (value as DocumentReference).id ==
            (_isEqualTo as DocumentReference).id;
      }
      return value == _isEqualTo;
    }).toList();

    return MockQuerySnapshot(filteredDocs);
  }

  @override
  Query<Map<String, dynamic>> where(Object field,
      {Object? isEqualTo,
      Object? isNotEqualTo,
      Object? isLessThan,
      Object? isLessThanOrEqualTo,
      Object? isGreaterThan,
      Object? isGreaterThanOrEqualTo,
      Object? arrayContains,
      Iterable<Object?>? arrayContainsAny,
      Iterable<Object?>? whereIn,
      Iterable<Object?>? whereNotIn,
      bool? isNull}) {
    return MockQuery(_docs, field, isEqualTo, shouldThrowError);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockQuerySnapshot implements QuerySnapshot<Map<String, dynamic>> {
  final List<MockDocument> _docs;

  MockQuerySnapshot(this._docs);

  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs =>
      _docs.map((d) => MockQueryDocumentSnapshot(d._data ?? {}, d)).toList();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockQueryDocumentSnapshot
    implements QueryDocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> _data;
  final MockDocument _ref;

  MockQueryDocumentSnapshot(this._data, this._ref);

  @override
  Map<String, dynamic> data() => _data;

  @override
  dynamic get(Object field) => _data[field];

  @override
  dynamic operator [](Object field) => get(field);

  @override
  String get id => _ref.id;

  @override
  DocumentReference<Map<String, dynamic>> get reference => _ref;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FirestoreMocks {
  static late MockFirestore mockFirestore;

  static void setupMocks({bool shouldThrowError = false}) {
    mockFirestore = MockFirestore()..shouldThrowError = shouldThrowError;

    // Setup initial data
    final tripsCollection = mockFirestore.collection('trips') as MockCollection;
    final tripDoc = tripsCollection.doc('test-trip-id') as MockDocument;
    tripDoc.setData({
      'departureCity': 'London',
      'destinationCity': 'Paris',
      'availableSeats': ['A1', 'A2', 'A3', 'A4', 'A5'],
      'agencyID': 'test-agency-id',
    });

    final bookingsCollection =
        mockFirestore.collection('bookings') as MockCollection;
    final bookingDoc =
        bookingsCollection.doc('test-booking-id') as MockDocument;
    bookingDoc.setData({
      'tripID': tripDoc,
      'departureTime': Timestamp.now(),
      'seatsBooked': [],
      'active': true,
    });
  }
}
