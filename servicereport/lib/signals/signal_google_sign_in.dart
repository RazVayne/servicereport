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

  final currentUser = signal<GoogleSignInAccount?>(null);
  final isAuthorized = signal(false);
  final errorMessage = signal('');
  final serverAuthCode = signal('');
  final GoogleSignIn signIn = GoogleSignIn.instance;
  bool _isInitialized = false;

  void initGoogleSignIn() async {
    _isInitialized = true;
    if (!_isInitialized) {
      await signIn
          .initialize(
            clientId: kIsWeb ? webCliendId : androidClientId,
            serverClientId: kIsWeb ? null : webServerCliendId,
          )
          .then((value) {
            signIn.authenticationEvents
                .listen(_handleAuthenticationEvent)
                .onError(_handleAuthenticationError);
          });
    }
  }

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    final GoogleSignInAccount? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    final GoogleSignInClientAuthorization? authorization = await user
        ?.authorizationClient
        .authorizationForScopes(scopes);

    currentUser.value = user;
    isAuthorized.value = authorization != null;
    errorMessage.value = '';

    //TODO: Call APIs to get contact ICON and NAME
  }

  Future<void> _handleAuthenticationError(Object e) async {
    currentUser.value = null;
    isAuthorized.value = false;
    errorMessage.value = e is GoogleSignInException
        ? _errorMessageFromSignInException(e)
        : "Unknown exception: $e";
  }

  Future<void> handleAuthorizationScopes(GoogleSignInAccount user) async {
    try {
      final GoogleSignInClientAuthorization authorization = await user
          .authorizationClient
          .authorizeScopes(scopes);
      authorization;
      isAuthorized.value = true;
      errorMessage.value = '';

      //TODO: Get JSON files from Drive
    } on GoogleSignInException catch (e) {
      errorMessage.value = _errorMessageFromSignInException(e);
    }
  }

  Future<void> handleGetAuthCode(GoogleSignInAccount user) async {
    try {
      final GoogleSignInServerAuthorization? serverAuth = await user
          .authorizationClient
          .authorizeServer(scopes);

      serverAuthCode.value = serverAuth == null
          ? ''
          : serverAuth.serverAuthCode;
    } on GoogleSignInException catch (e) {
      errorMessage.value = _errorMessageFromSignInException(e);
    }
  }

  Future<void> handleSignOut() async {
    await GoogleSignIn.instance.signOut();
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
    };
  }
}
