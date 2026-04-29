import 'package:flutter_test/flutter_test.dart';
import 'package:radiostream/bloc/radio/radio_loading_bloc.dart';

void main() {
  group('RadioLoadingBloc', () {
    late RadioLoadingBloc bloc;

    setUp(() {
      bloc = RadioLoadingBloc();
    });

    tearDown(() {
      bloc.dispose();
    });

    test('emits false as initial value', () {
      expect(bloc.radioLoadingStream, emits(false));
    });

    test('emits true when loading state set to true', () async {
      bloc.changeLoadingState.add(true);
      await expectLater(bloc.radioLoadingStream, emitsThrough(true));
    });

    test('emits false when loading state set to false', () async {
      bloc.changeLoadingState.add(true);
      bloc.changeLoadingState.add(false);
      await expectLater(bloc.radioLoadingStream, emitsThrough(false));
    });

    test('treats null as false', () async {
      bloc.changeLoadingState.add(null);
      await expectLater(bloc.radioLoadingStream, emitsThrough(false));
    });

    test('stream closes after dispose', () async {
      bloc.dispose();
      await expectLater(bloc.radioLoadingStream, emitsDone);
    });
  });
}
