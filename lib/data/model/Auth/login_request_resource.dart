class LoginRequestResource {
  final String email;

  LoginRequestResource({
    required this.email
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
