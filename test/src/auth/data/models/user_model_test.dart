import 'dart:convert';

import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLocalUserModel = LocalUserModel.empty();

  test(
    'should be a subclass of [LocalUser] entity',
    () => expect(tLocalUserModel, isA<LocalUser>()),
  );

  final tMap = jsonDecode(fixture('user.json')) as DataMap;
  group('fromMap', () {
    test('should return a valid [LocalUser model] from the map', () {
      final result = LocalUserModel.fromMap(tMap);
      expect(result, isA<LocalUserModel>());
      expect(result, equals(tLocalUserModel));
    });
  });

  group('toMap', () {
    test('should return a valid [DataMap] from the model', () {
      final result = tLocalUserModel.toMap();
      expect(result, equals(tMap));
    });
  });

  group('copyWith', () {
    test('should return a valid [LocalUserModel with updated values', () {
      final result = tLocalUserModel.copyWith(uid: '2');
      expect(result.uid, equals('2'));
    });
  });
}
