import 'package:flutter_test/flutter_test.dart';
import 'package:radiostream/bloc/settings/initial_radio_index_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('InitialRadioIndexBloc', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('emits 0 as default when no prefs stored', () async {
      final bloc = InitialRadioIndexBloc();
      await bloc.prefs;
      await expectLater(bloc.initialRadioIndexStream, emitsThrough(0));
      bloc.dispose();
    });

    test('loads stored initialRadioIndex from prefs', () async {
      SharedPreferences.setMockInitialValues({'initialRadioIndex': 2});
      final bloc = InitialRadioIndexBloc();
      await bloc.prefs;
      await expectLater(bloc.initialRadioIndexStream, emitsThrough(2));
      bloc.dispose();
    });

    test('loads stored value of -1 (recent streams option)', () async {
      SharedPreferences.setMockInitialValues({'initialRadioIndex': -1});
      final bloc = InitialRadioIndexBloc();
      await bloc.prefs;
      await expectLater(bloc.initialRadioIndexStream, emitsThrough(-1));
      bloc.dispose();
    });

    test('changeInitialRadioIndex updates the stream', () async {
      final bloc = InitialRadioIndexBloc();
      await bloc.prefs;
      bloc.changeInitialRadioIndex.add(1);
      await expectLater(bloc.initialRadioIndexStream, emitsThrough(1));
      bloc.dispose();
    });

    test('null resets to 0', () async {
      final bloc = InitialRadioIndexBloc();
      await bloc.prefs;
      bloc.changeInitialRadioIndex.add(1);
      bloc.changeInitialRadioIndex.add(null);
      await expectLater(bloc.initialRadioIndexStream, emitsThrough(0));
      bloc.dispose();
    });

    test('changeInitialRadioIndex persists to SharedPreferences', () async {
      final bloc = InitialRadioIndexBloc();
      await bloc.prefs;
      bloc.changeInitialRadioIndex.add(1);
      await Future.delayed(Duration.zero);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('initialRadioIndex'), 1);
      bloc.dispose();
    });

    test('stream closes after dispose', () async {
      final bloc = InitialRadioIndexBloc();
      await bloc.prefs;
      bloc.dispose();
      await expectLater(bloc.initialRadioIndexStream, emitsDone);
    });
  });
}
