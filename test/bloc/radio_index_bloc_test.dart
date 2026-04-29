import 'package:flutter_test/flutter_test.dart';
import 'package:radiostream/bloc/radio/radio_index_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('RadioIndexBloc', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('emits 0 as default when no prefs stored', () async {
      final bloc = RadioIndexBloc();
      // Wait for prefs to load
      await bloc.prefs;
      await expectLater(bloc.radioIndexStream, emitsThrough(0));
      bloc.dispose();
    });

    test('respects stored radioIndex when initialRadioIndex is -1 (recent)', () async {
      SharedPreferences.setMockInitialValues({
        'radioIndex': 1,
        'initialRadioIndex': -1,
      });
      final bloc = RadioIndexBloc();
      await bloc.prefs;
      await expectLater(bloc.radioIndexStream, emitsThrough(1));
      bloc.dispose();
    });

    test('uses initialRadioIndex when set to a specific stream', () async {
      SharedPreferences.setMockInitialValues({
        'radioIndex': 1,
        'initialRadioIndex': 0,
      });
      final bloc = RadioIndexBloc();
      await bloc.prefs;
      await expectLater(bloc.radioIndexStream, emitsThrough(0));
      bloc.dispose();
    });

    test('changeRadioIndex updates the stream', () async {
      final bloc = RadioIndexBloc();
      await bloc.prefs;
      bloc.changeRadioIndex.add(2);
      await expectLater(bloc.radioIndexStream, emitsThrough(2));
      bloc.dispose();
    });

    test('null resets index to 0', () async {
      final bloc = RadioIndexBloc();
      await bloc.prefs;
      bloc.changeRadioIndex.add(2);
      bloc.changeRadioIndex.add(null);
      await expectLater(bloc.radioIndexStream, emitsThrough(0));
      bloc.dispose();
    });

    test('changeRadioIndex persists to SharedPreferences', () async {
      final bloc = RadioIndexBloc();
      await bloc.prefs;
      bloc.changeRadioIndex.add(1);
      // Allow async prefs write to complete
      await Future.delayed(Duration.zero);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('radioIndex'), 1);
      bloc.dispose();
    });

    test('stream closes after dispose', () async {
      final bloc = RadioIndexBloc();
      await bloc.prefs;
      bloc.dispose();
      await expectLater(bloc.radioIndexStream, emitsDone);
    });
  });
}
