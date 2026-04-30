import 'package:flutter_test/flutter_test.dart';
import 'package:radiostream/audio_service/notifiers/loading_notifier.dart';

void main() {
  group('LoadingNotifier', () {
    test('initial value is done', () {
      final notifier = LoadingNotifier();
      expect(notifier.value, LoadingState.done);
    });

    test('value can be set to loading', () {
      final notifier = LoadingNotifier();
      notifier.value = LoadingState.loading;
      expect(notifier.value, LoadingState.loading);
    });

    test('value can be set back to done', () {
      final notifier = LoadingNotifier();
      notifier.value = LoadingState.loading;
      notifier.value = LoadingState.done;
      expect(notifier.value, LoadingState.done);
    });

    test('notifies listeners on change', () {
      final notifier = LoadingNotifier();
      int callCount = 0;
      notifier.addListener(() => callCount++);
      notifier.value = LoadingState.loading;
      expect(callCount, 1);
    });

    test('does not notify listeners when value is unchanged', () {
      final notifier = LoadingNotifier();
      int callCount = 0;
      notifier.addListener(() => callCount++);
      notifier.value = LoadingState.done; // same as initial
      expect(callCount, 0);
    });
  });
}
