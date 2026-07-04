enum AppBootstrapRoute {
  loading,
  languageSelection,
  login,
  decks,
}

AppBootstrapRoute resolveAppBootstrapRoute({
  required bool isLoading,
  required String? languageCode,
  required String? token,
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

  return AppBootstrapRoute.decks;
}