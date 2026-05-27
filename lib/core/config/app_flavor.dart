enum AppFlavor {
  dev,
  staging,
  prod;

  static AppFlavor fromString(String value) {
    return AppFlavor.values.firstWhere(
      (flavor) => flavor.name == value,
      orElse: () => AppFlavor.dev,
    );
  }
}
