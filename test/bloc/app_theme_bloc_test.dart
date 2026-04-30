import 'package:flutter_test/flutter_test.dart';
import 'package:radiostream/bloc/settings/app_theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AppThemeBloc', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('emits System default when no prefs stored', () async {
      final bloc = AppThemeBloc();
      await bloc.prefs;
      await expectLater(bloc.appThemeStream, emitsThrough('System default'));
      bloc.dispose();
    });

    test('loads stored theme from prefs', () async {
      SharedPreferences.setMockInitialValues({'appTheme': 'Dark'});
      final bloc = AppThemeBloc();
      await bloc.prefs;
      await expectLater(bloc.appThemeStream, emitsThrough('Dark'));
      bloc.dispose();
    });

    test('changeAppTheme updates the stream', () async {
      final bloc = AppThemeBloc();
      await bloc.prefs;
      bloc.changeAppTheme.add('Light');
      await expectLater(bloc.appThemeStream, emitsThrough('Light'));
      bloc.dispose();
    });

    test('null resets to System default', () async {
      final bloc = AppThemeBloc();
      await bloc.prefs;
      bloc.changeAppTheme.add('Dark');
      bloc.changeAppTheme.add(null);
      await expectLater(bloc.appThemeStream, emitsThrough('System default'));
      bloc.dispose();
    });

    test('changeAppTheme persists to SharedPreferences', () async {
      final bloc = AppThemeBloc();
      await bloc.prefs;
      bloc.changeAppTheme.add('Dark');
      await Future.delayed(Duration.zero);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('appTheme'), 'Dark');
      bloc.dispose();
    });

    test('all valid theme values round-trip through stream', () async {
      final themes = ['Light', 'Dark', 'System default'];
      for (final theme in themes) {
        SharedPreferences.setMockInitialValues({'appTheme': theme});
        final bloc = AppThemeBloc();
        await bloc.prefs;
        await expectLater(bloc.appThemeStream, emitsThrough(theme));
        bloc.dispose();
      }
    });

    test('stream closes after dispose', () async {
      final bloc = AppThemeBloc();
      await bloc.prefs;
      bloc.dispose();
      // BehaviorSubject replays its last value to new subscribers before done
      await expectLater(
        bloc.appThemeStream,
        emitsInOrder([anything, emitsDone]),
      );
    });
  });
}
