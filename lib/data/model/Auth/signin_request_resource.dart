class SigninRequestResource {
  final String fullName;
  final String email;
  final String photoUrl;

  SigninRequestResource({
    required this.fullName,
    required this.email,
    required this.photoUrl
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email':email,
      'photoUrl':photoUrl
    };
  }
}
