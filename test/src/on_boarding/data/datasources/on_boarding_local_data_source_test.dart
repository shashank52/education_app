import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences prefs;
  late OnBoardingLocalDataSource localDataSource;

  setUp(() {
    prefs = MockSharedPreferences();
    localDataSource = OnBoardingLocalDataSrcImpl(prefs);
  });

  group('cachedFirstTimer', () {
    test('should call [SharedPreferences] to cache the data', () async {
      //arrange
      when(() => prefs.setBool(any(), any())).thenAnswer((_) async => true);

      //act
      await localDataSource.cachedFirstTime();

      //assert
      // expect(actual, matcher)

      verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(prefs);
    });

    test(
      'should throw [CacheException] when there is an error caching the data',
      () async {
        when(() => prefs.setBool(any(), any())).thenThrow(Exception());

        final methodCall = localDataSource.cachedFirstTime;

        expect(methodCall, throwsA(isA<CacheException>()));
        verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
        verifyNoMoreInteractions(prefs);
      },
    );
  });

  group('checkIfUserIsFirstTimer', () {
    test(
      'should call [SharedPreferences] to check if user is first timer and '
      'return the right response when data exists',
      () async {
        when(() => prefs.getBool(any())).thenReturn(false);

        final result = await localDataSource.checkIfUserIsFirstTimer();

        expect(result, false);

        verify(() => prefs.getBool(kFirstTimerKey)).called(1);
        verifyNoMoreInteractions(prefs);
      },
    );

    test(
      'should return true if no data exist in sharedPreferences',
      () async {
        when(() => prefs.getBool(any())).thenReturn(null);

        final result = await localDataSource.checkIfUserIsFirstTimer();

        expect(result, true);

        verify(() => prefs.getBool(kFirstTimerKey)).called(1);
        verifyNoMoreInteractions(prefs);
      },
    );

    test(
      'should throw [CacheException] when there is an error '
      'retrieving the data',
      () async {
        when(() => prefs.getBool(any())).thenThrow(Exception());

        final methodCall = localDataSource.checkIfUserIsFirstTimer;

        expect(methodCall, throwsA(isA<CacheException>()));

        verify(() => prefs.getBool(kFirstTimerKey)).called(1);
        verifyNoMoreInteractions(prefs);
      },
    );
  });
}
