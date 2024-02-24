import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_app/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:education_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSrc extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late OnBoardingLocalDataSource localDataSource;
  late OnBoardingRepoImpl repoImpl;

  setUp(() {
    localDataSource = MockOnBoardingLocalDataSrc();
    repoImpl = OnBoardingRepoImpl(localDataSource);
  });

  test('should be a subclass of [OnBoardingRepo]', () {
    expect(repoImpl, equals(isA<OnBoardingRepo>()));
  });

  group('cachedFirstTimer', () {
    test(
        'should complete successfully when call to local data source successful',
        () async {
      //Arrange
      when(() => localDataSource.cachedFirstTime())
          .thenAnswer((_) async => Future.value());
      //act
      final result = await repoImpl.cacheFirstTimer();
      //assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => localDataSource.cachedFirstTime()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });

    test(
        'should return [CacheFailure] when call to local data source unsuccessful',
        () async {
      //Arrange
      when(() => localDataSource.cachedFirstTime()).thenThrow(
        const CacheException(serverMessage: 'Insufficient Storage'),
      );
      //act
      final result = await repoImpl.cacheFirstTimer();
      //assert
      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            CacheFailure(message: 'Insufficient Storage', statusCode: 500),
          ),
        ),
      );
      verify(() => localDataSource.cachedFirstTime()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });
  });

  group('checkIfUserIsFirstTimer', () {
    test(
        'should complete successfully when call to local data source successful ',
        () async {
      //arrange
      when(() => localDataSource.checkIfUserIsFirstTimer())
          .thenAnswer((_) async => Future.value(true));
      //act
      final result = await repoImpl.checkIfUserIsFirstTimer();

      //assert
      expect(result, equals(const Right<Failure, bool>(true)));
      verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });

    test(
        'should return [CacheFailure] when call to local data source unsuccessful ',
        () async {
      //arrange
      when(() => localDataSource.checkIfUserIsFirstTimer()).thenThrow(
        const CacheException(serverMessage: 'Insufficient Storage'),
      );
      //act
      final result = await repoImpl.checkIfUserIsFirstTimer();

      //assert
      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            CacheFailure(message: 'Insufficient Storage', statusCode: 500),
          ),
        ),
      );
      verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });
  });
}
