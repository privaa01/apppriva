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
