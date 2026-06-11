enum AppBootstrapRoute {
  loading,
  languageSelection,
  login,
  firstEnterSetup,
  decks,
}

AppBootstrapRoute resolveAppBootstrapRoute({
  required bool isLoading,
  required String? languageCode,
  required String? token,
  required bool isFirstEnter,
}) {
  if (isLoading) {
    return AppBootstrapRoute.loading;
  }

  if (languageCode == null || languageCode.isEmpty) {
    return AppBootstrapRoute.languageSelection;
  }

  if (token == null || token.isEmpty) {
    return AppBootstrapRoute.login;
  }

  if (isFirstEnter) {
    return AppBootstrapRoute.firstEnterSetup;
  }

  return AppBootstrapRoute.decks;
}