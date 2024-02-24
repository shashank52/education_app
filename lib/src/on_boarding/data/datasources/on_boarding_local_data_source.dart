abstract class OnBoardingLocalDataSource {
  const OnBoardingLocalDataSource();

  Future<void> cachedFirstTime();

  Future<bool> checkIfUserIsFirstTimer();
}
