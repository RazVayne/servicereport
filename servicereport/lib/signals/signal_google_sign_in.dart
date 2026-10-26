import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:signals/signals.dart';

class SignalGoogleSignIn {
  String webCliendId = "401661839059-752arpga3giqvlt4d20fg06t422flh1n";
  String webServerCliendId =
      "401661839059-752arpga3giqvlt4d20fg06t422flh1n.apps.googleusercontent.com";
  String androidClientId = "401661839059-t72i74e0d547q68a06s59g9e0m76kgg3";
  String androidServerClientId =
      "401661839059-mhvhvh06t2cuu7qik8ocpm2n1fp2fdtr.apps.googleusercontent.com";
  List<String> scopes = <String>['https://www.googleapis.com/auth/drive.file'];

  final _currentUser = signal<GoogleSignInAccount?>(null);
  final _isAuthorized = signal(false);
  final _errorMessage = signal('');
  final _serverAuthCode = signal('');

  void initGoogleSignIn() {
    final GoogleSignIn signIn = GoogleSignIn.instance;
    unawaited(
      signIn
          .initialize(
            clientId: kIsWeb ? webCliendId : androidClientId,
            serverClientId: webServerCliendId,
          )
          .then((value) {
            signIn.authenticationEvents
                .listen(handleAuthenticationEvent)
                .onError(handleAuthenticationError);
          }),
    );
  }

  Future<void> handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    final GoogleSignInAccount? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    final GoogleSignInClientAuthorization? authorization = await user
        ?.authorizationClient
        .authorizationForScopes(scopes);

    _currentUser.value = user;
    _isAuthorized.value = authorization != null;
    _errorMessage.value = '';

    //TODO: Call APIs to get contact ICON and NAME
  }

  Future<void> handleAuthenticationError(Object e) async {
    _currentUser.value = null;
    _isAuthorized.value = false;
    _errorMessage.value = e is GoogleSignInException
        ? _errorMessageFromSignInException(e)
        : "Unknown exception: $e";
  }

  Future<void> handleAuthorizationScopes(GoogleSignInAccount user) async {
    try {
      final GoogleSignInClientAuthorization authorization = await user
          .authorizationClient
          .authorizeScopes(scopes);
      authorization;
      _isAuthorized.value = true;
      _errorMessage.value = '';

      //TODO: Get JSON files from Drive
    } on GoogleSignInException catch (e) {
      _errorMessage.value = _errorMessageFromSignInException(e);
    }
  }

  String _errorMessageFromSignInException(GoogleSignInException e) {
    return switch (e.code) {
      GoogleSignInExceptionCode.canceled => 'Sign in canceled',
      GoogleSignInExceptionCode.clientConfigurationError =>
        'Client configuration error',
      GoogleSignInExceptionCode.interrupted => 'Sign in interrupted',
      GoogleSignInExceptionCode.providerConfigurationError =>
        'Provider configuration error',
      GoogleSignInExceptionCode.uiUnavailable => 'UI unavailable',
      GoogleSignInExceptionCode.unknownError => 'Unknown error $e',
      GoogleSignInExceptionCode.userMismatch => 'User mismatch',
      _ => 'GoogleSignInException ${e.code}: ${e.description}',
    };
  }
}
