import 'package:flutter_test/flutter_test.dart';
import 'package:radiostream/audio_service/notifiers/repeat_button_notifier.dart';

void main() {
  group('RepeatButtonNotifier', () {
    test('initial value is off', () {
      final notifier = RepeatButtonNotifier();
      expect(notifier.value, RepeatState.off);
    });

    test('nextState cycles off → repeatQueue → repeatSong → off', () {
      final notifier = RepeatButtonNotifier();
      expect(notifier.value, RepeatState.off);
      notifier.nextState();
      expect(notifier.value, RepeatState.repeatQueue);
      notifier.nextState();
      expect(notifier.value, RepeatState.repeatSong);
      notifier.nextState();
      expect(notifier.value, RepeatState.off);
    });

    test('cycles wrap correctly after multiple full rotations', () {
      final notifier = RepeatButtonNotifier();
      final totalStates = RepeatState.values.length;
      for (int i = 0; i < totalStates * 3; i++) {
        notifier.nextState();
      }
      expect(notifier.value, RepeatState.off);
    });

    test('notifies listeners on nextState', () {
      final notifier = RepeatButtonNotifier();
      int callCount = 0;
      notifier.addListener(() => callCount++);
      notifier.nextState();
      expect(callCount, 1);
    });

    test('value can be set directly', () {
      final notifier = RepeatButtonNotifier();
      notifier.value = RepeatState.repeatSong;
      expect(notifier.value, RepeatState.repeatSong);
    });
  });
}
