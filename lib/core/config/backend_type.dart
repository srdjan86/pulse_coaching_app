enum BackendType {
  mock,
  firebase,
  supabase;

  static BackendType fromString(String value) {
    return BackendType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => BackendType.mock,
    );
  }
}
