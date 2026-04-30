import 'package:flutter_test/flutter_test.dart';
import 'package:radiostream/audio_service/notifiers/play_button_notifier.dart';

void main() {
  group('PlayButtonNotifier', () {
    test('initial value is paused', () {
      final notifier = PlayButtonNotifier();
      expect(notifier.value, PlayButtonState.paused);
    });

    test('value can be set to playing', () {
      final notifier = PlayButtonNotifier();
      notifier.value = PlayButtonState.playing;
      expect(notifier.value, PlayButtonState.playing);
    });

    test('value can be set back to paused', () {
      final notifier = PlayButtonNotifier();
      notifier.value = PlayButtonState.playing;
      notifier.value = PlayButtonState.paused;
      expect(notifier.value, PlayButtonState.paused);
    });

    test('notifies listeners on change', () {
      final notifier = PlayButtonNotifier();
      int callCount = 0;
      notifier.addListener(() => callCount++);
      notifier.value = PlayButtonState.playing;
      expect(callCount, 1);
    });

    test('does not notify listeners when value is unchanged', () {
      final notifier = PlayButtonNotifier();
      int callCount = 0;
      notifier.addListener(() => callCount++);
      notifier.value = PlayButtonState.paused; // same as initial
      expect(callCount, 0);
    });
  });
}
