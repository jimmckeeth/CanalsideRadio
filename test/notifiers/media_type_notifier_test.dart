import 'package:flutter_test/flutter_test.dart';
import 'package:radiostream/audio_service/notifiers/media_type_notifier.dart';
import 'package:radiostream/helper/media_helper.dart';

void main() {
  group('MediaTypeNotifier', () {
    test('initial value is radio', () {
      final notifier = MediaTypeNotifier();
      expect(notifier.value, MediaType.radio);
    });

    test('value can be set to media', () {
      final notifier = MediaTypeNotifier();
      notifier.value = MediaType.media;
      expect(notifier.value, MediaType.media);
    });

    test('value can be set back to radio', () {
      final notifier = MediaTypeNotifier();
      notifier.value = MediaType.media;
      notifier.value = MediaType.radio;
      expect(notifier.value, MediaType.radio);
    });

    test('notifies listeners on change', () {
      final notifier = MediaTypeNotifier();
      int callCount = 0;
      notifier.addListener(() => callCount++);
      notifier.value = MediaType.media;
      expect(callCount, 1);
    });

    test('does not notify listeners when value is unchanged', () {
      final notifier = MediaTypeNotifier();
      int callCount = 0;
      notifier.addListener(() => callCount++);
      notifier.value = MediaType.radio; // same as initial
      expect(callCount, 0);
    });
  });
}
