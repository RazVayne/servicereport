import 'package:google_sign_in/google_sign_in.dart';

class ClassCachedGoogleIdentity implements GoogleIdentity {
  @override
  final String id;
  @override
  final String email;
  @override
  final String? displayName;
  @override
  final String? photoUrl;

  const ClassCachedGoogleIdentity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
  };

  factory ClassCachedGoogleIdentity.fromJson(Map<String, dynamic> json) =>
      ClassCachedGoogleIdentity(
        id: json['id'] as String,
        email: json['email'] as String,
        displayName: json['displayName'] as String?,
        photoUrl: json['photoUrl'] as String?,
      );
}
