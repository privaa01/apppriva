class ConnectivityState {
  const ConnectivityState({
    this.available = true,
    this.initialized = false,
    this.retrying = false,
  });
  final bool available;
  final bool initialized;
  final bool retrying;
  ConnectivityState copyWith({
    bool? available,
    bool? initialized,
    bool? retrying,
  }) => ConnectivityState(
    available: available ?? this.available,
    initialized: initialized ?? this.initialized,
    retrying: retrying ?? this.retrying,
  );
}
