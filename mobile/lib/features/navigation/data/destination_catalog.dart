enum NavigationSection { home, profile, tips, chat, questionnaire }

enum DestinationAccess { public, entry, private }

class Destination {
  const Destination(
    this.path,
    this.access, {
    this.section,
    this.requiresResult = false,
  });
  final String path;
  final DestinationAccess access;
  final NavigationSection? section;
  final bool requiresResult;
  bool get available => destinationAvailable(path);
}

const destinations = <Destination>[
  Destination('/signin', DestinationAccess.entry),
  Destination('/signup', DestinationAccess.entry),
  Destination('/confirm', DestinationAccess.entry),
  Destination('/recovery', DestinationAccess.entry),
  Destination(
    '/home',
    DestinationAccess.private,
    section: NavigationSection.home,
  ),
  Destination(
    '/profile',
    DestinationAccess.private,
    section: NavigationSection.profile,
  ),
  Destination(
    '/tips',
    DestinationAccess.public,
    section: NavigationSection.tips,
  ),
  Destination(
    '/tips/passwords',
    DestinationAccess.public,
    section: NavigationSection.tips,
  ),
  Destination(
    '/tips/sharing',
    DestinationAccess.public,
    section: NavigationSection.tips,
  ),
  Destination(
    '/tips/links',
    DestinationAccess.public,
    section: NavigationSection.tips,
  ),
  Destination(
    '/tips/profiles',
    DestinationAccess.public,
    section: NavigationSection.tips,
  ),
  Destination(
    '/chat',
    DestinationAccess.private,
    section: NavigationSection.chat,
  ),
  Destination(
    '/questionnaire',
    DestinationAccess.private,
    section: NavigationSection.questionnaire,
  ),
  Destination(
    '/results',
    DestinationAccess.private,
    section: NavigationSection.questionnaire,
    requiresResult: true,
  ),
];

Destination? destinationFor(String path) {
  for (final destination in destinations) {
    if (destination.path == path) return destination;
  }
  return null;
}

// Availability describes delivered content, independently of permission to navigate.
bool destinationAvailable(String path) => const {
  '/signin',
  '/signup',
  '/confirm',
  '/recovery',
  '/home',
  '/profile',
  '/tips',
  '/tips/passwords',
  '/tips/sharing',
  '/tips/links',
  '/tips/profiles',
  '/chat',
  '/questionnaire',
  '/results',
}.contains(path);

bool destinationAllowed(
  String path, {
  required bool privateAccess,
  bool hasResult = false,
}) {
  final destination = destinationFor(path);
  return destination != null &&
      (destination.access != DestinationAccess.private || privateAccess) &&
      (!destination.requiresResult || hasResult);
}
