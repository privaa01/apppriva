enum AccountPhase { visitor, pendingVerification, authenticated, recovering }

class AccountSession {
  const AccountSession({
    required this.userId,
    required this.emailVerified,
    required this.passwordAuthenticated,
    this.displayName,
  });
  final String userId;
  final bool emailVerified;
  final bool passwordAuthenticated;
  final String? displayName;
  bool get canAccessPrivate => emailVerified && passwordAuthenticated;
}

class AccountState {
  const AccountState({
    this.phase = AccountPhase.visitor,
    this.busy = false,
    this.error,
    this.notice,
    this.email = '',
    this.session,
  });
  final AccountPhase phase;
  final bool busy;
  final String? error;
  final String? notice;
  final String email;
  final AccountSession? session;
  bool get canAccessPrivate =>
      phase == AccountPhase.authenticated && session?.canAccessPrivate == true;
}

bool isPublicDestination(String route) => const {
  '/tips',
  '/tips/passwords',
  '/tips/sharing',
  '/tips/links',
  '/tips/profiles',
  '/signin',
  '/signup',
  '/confirm',
  '/recovery',
}.contains(route);

bool canOpenDestination(String route, AccountState state) =>
    isPublicDestination(route) || state.canAccessPrivate;
