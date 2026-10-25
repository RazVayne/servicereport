import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:signals/signals.dart';

class SignalGoogleSignIn {
  String clientId =
      "401661839059-mhvhvh06t2cuu7qik8ocpm2n1fp2fdtr.apps.googleusercontent.com";
  List<String> scopes = <String>['https://www.googleapis.com/auth/drive.file'];

  final _currentUser = signal<GoogleSignInAccount?>(null);
  final _isAuthorized = signal(false);
  final _errorMessage = signal('');
  final _serverAuthCode = signal('');

  void initGoogleSignIn() {
    final GoogleSignIn signIn = GoogleSignIn.instance;
    unawaited(
      signIn.initialize(clientId: clientId).then((value) {
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
