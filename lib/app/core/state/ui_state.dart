/// Sealed class representing the state of UI data
sealed class UiState<T> {
  const UiState();
}

/// Initial/idle state before any operation
class Idle<T> extends UiState<T> {
  const Idle();
}

/// Loading state during async operations
class Loading<T> extends UiState<T> {
  const Loading();
}

/// Success state with data
class Ready<T> extends UiState<T> {
  final T data;
  const Ready(this.data);
}

/// Empty state when no data is available
class Empty<T> extends UiState<T> {
  const Empty();
}

/// Error state with error message
class ErrorState<T> extends UiState<T> {
  final String message;
  const ErrorState(this.message);
}
