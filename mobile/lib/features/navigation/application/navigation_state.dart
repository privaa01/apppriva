enum ExitDecision { allow, blockSaving, confirmDiscard, previousQuestion }

class NavigationState {
  const NavigationState({
    required this.path,
    required this.history,
    required this.generation,
    required this.pending,
  });
  final String? path;
  final List<String> history;
  final int generation;
  final bool pending;
}

/// Snapshot of a trusted, in-memory context; never a route argument or grant.
class NavigationIntent {
  const NavigationIntent({
    required this.ownerId,
    required this.navigationGeneration,
    required this.journeyGeneration,
  });
  final String? ownerId;
  final int navigationGeneration;
  final int journeyGeneration;
}
