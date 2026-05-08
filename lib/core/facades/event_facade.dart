import 'dart:async';

class Event {
  Event._();

  static final StreamController<Object> _bus =
      StreamController<Object>.broadcast();

  static Stream<T> on<T>() {
    return _bus.stream.where((event) => event is T).cast<T>();
  }

  static void emit(Object event) {
    _bus.add(event);
  }

  static Future<void> close() async {
    await _bus.close();
  }
}
