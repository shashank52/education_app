import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckIfUserIsFirstTimer extends Mock
    implements CheckIfUserIsFirstTimer {}

void main() {
  late CacheFirstTimer cacheFirstTimer;
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;
  late OnBoardingCubit onBoardingCubit;

  setUp(() {
    cacheFirstTimer = MockCacheFirstTimer();
    checkIfUserIsFirstTimer = MockCheckIfUserIsFirstTimer();
    onBoardingCubit = OnBoardingCubit(
      cacheFirstTimer: cacheFirstTimer,
      checkIfUserIsFirstTimer: checkIfUserIsFirstTimer,
    );
  });

  tearDown(() => onBoardingCubit.close());

  final tCacheFailure = CacheFailure(message: 'message', statusCode: 500);
  test('initial state should be [OnBoardingInitial]', () async {
    expect(onBoardingCubit.state, equals(isA<OnBoardingInitial>()));
  });

  group('CacheFirstTimer', () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CachingFirstTimer, UserCached] when successful',
      build: () {
        when(() => cacheFirstTimer())
            .thenAnswer((_) async => const Right(null));
        return onBoardingCubit;
      },
      act: (cubit) => cubit.cachedFirstTimer(),
      expect: () => [const CachingFirstTimer(), const UserCached()],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );

    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CachingFirstTimer, OnBoardingError] when unsuccessful',
      build: () {
        when(() => cacheFirstTimer())
            .thenAnswer((_) async => Left(tCacheFailure));
        return onBoardingCubit;
      },
      act: (cubit) => cubit.cachedFirstTimer(),
      expect: () =>
          [const CachingFirstTimer(), OnBoardingError(tCacheFailure.message)],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );
  });

  group('CheckingIfUserIsFirstTimer', () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CheckingIfUserIsFirstTimer, OnBoardingStatus] '
      'when successful',
      build: () {
        when(() => checkIfUserIsFirstTimer())
            .thenAnswer((_) async => const Right(true));
        return onBoardingCubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => [
        const CheckingIfUserIsFirstTimer(),
        const OnBoardingStatus(isFirstTimer: true),
      ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );

    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CheckingIfUserIsFirstTimer, OnBoardingStatus] '
      'when unsuccessful',
      build: () {
        when(() => checkIfUserIsFirstTimer())
            .thenAnswer((_) async => Left(tCacheFailure));
        return onBoardingCubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => [
        const CheckingIfUserIsFirstTimer(),
        const OnBoardingStatus(isFirstTimer: true),
      ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );
  });
}
