class AuthFailure implements Exception {
  const AuthFailure(this.code, {this.details});

  final String code;
  final String? details;

  @override
  String toString() => details ?? code;
}
