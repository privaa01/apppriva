const signInFailureMessage =
    'No pudimos iniciar sesión. Revisa tus datos o verifica el correo con el que te registraste';
const operationFailureMessage =
    'No pudimos completar la solicitud. Revisa tu conexión e inténtalo de nuevo.';
const waitFailureMessage =
    'La solicitud está tardando. Revisa tu conexión antes de reintentar.';
const codeFailureMessage =
    'No pudimos validar el código. Revísalo o solicita uno nuevo.';

class AccountFailure implements Exception {
  const AccountFailure();
  // Deliberately no provider body, credentials or user information.
}

/// Sanitized stages only: no provider messages, identifiers or credentials.
enum SignInIssue {
  credentials,
  verification,
  network,
  configuration,
  authorizationMissing,
  authorizationRead,
  profileRead,
  identity,
  rateLimited,
  service,
}

class SignInFailure extends AccountFailure {
  const SignInFailure(this.issue);
  final SignInIssue issue;
  String get safeMessage => switch (issue) {
    SignInIssue.credentials => signInFailureMessage,
    SignInIssue.service => 'El servicio de acceso no pudo completar la solicitud. Inténtalo de nuevo; si continúa, comparte la referencia AC-09.',
    SignInIssue.verification => signInFailureMessage,
    SignInIssue.network => 'No pudimos comprobar el acceso. Revisa tu conexión y vuelve a intentarlo. [AC-03]',
    SignInIssue.configuration => 'El servicio de acceso no está disponible por su configuración. Inténtalo más tarde. [AC-01]',
    SignInIssue.authorizationMissing => 'No pudimos confirmar la autorización necesaria para acceder. Comparte la referencia AC-04 para revisar el problema.',
    SignInIssue.authorizationRead => 'No pudimos comprobar la autorización de acceso. Inténtalo de nuevo; si continúa, comparte la referencia AC-05.',
    SignInIssue.profileRead => 'No pudimos cargar el perfil para iniciar sesión. Inténtalo de nuevo; si continúa, comparte la referencia AC-06.',
    SignInIssue.identity =>
      'No pudimos confirmar la sesión. Vuelve a iniciar sesión. [AC-07]',
    SignInIssue.rateLimited =>
      'Espera unos minutos antes de volver a intentar iniciar sesión. [AC-08]',
  };
}
