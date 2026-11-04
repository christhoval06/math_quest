import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/presentation/controllers/welcome_splash_controller.dart';

void main() {
  test('tap sound is non-blocking and failures are contained', () async {
    final gate = Completer<void>();
    var soundCalls = 0;
    final controller = WelcomeSplashController(
      readActiveProfileId: () => 'leo',
      playTapAction: () {
        soundCalls++;
        return gate.future;
      },
      switchProfileAction: (_) async {},
    );

    controller.playTap();

    expect(soundCalls, 1);
    gate.completeError(StateError('audio unavailable'));
    await Future<void>.delayed(Duration.zero);
  });

  test('synchronous tap sound failures are contained', () {
    final controller = WelcomeSplashController(
      readActiveProfileId: () => 'leo',
      playTapAction: () => throw StateError('audio unavailable'),
      switchProfileAction: (_) async {},
    );

    expect(controller.playTap, returnsNormally);
  });

  test('switching to the active profile is a no-op', () async {
    var calls = 0;
    final controller = WelcomeSplashController(
      readActiveProfileId: () => 'leo',
      playTapAction: () async {},
      switchProfileAction: (_) async => calls++,
    );

    await controller.switchProfile('leo');

    expect(calls, 0);
  });

  test('rapid profile switches execute serially', () async {
    var activeId = 'leo';
    final events = <String>[];
    final firstGate = Completer<void>();
    final controller = WelcomeSplashController(
      readActiveProfileId: () => activeId,
      playTapAction: () async {},
      switchProfileAction: (id) async {
        events.add('start:$id');
        if (id == 'mia') await firstGate.future;
        activeId = id;
        events.add('end:$id');
      },
    );

    final first = controller.switchProfile('mia');
    final second = controller.switchProfile('ava');
    await Future<void>.delayed(Duration.zero);

    expect(events, ['start:mia']);
    firstGate.complete();
    await Future.wait([first, second]);

    expect(events, ['start:mia', 'end:mia', 'start:ava', 'end:ava']);
    expect(activeId, 'ava');
  });

  test('failed profile switch restores the prior active profile', () async {
    var activeId = 'leo';
    final calls = <String>[];
    final failure = StateError('switch failed');
    final controller = WelcomeSplashController(
      readActiveProfileId: () => activeId,
      playTapAction: () async {},
      switchProfileAction: (id) async {
        calls.add(id);
        activeId = id;
        if (id == 'mia') throw failure;
      },
    );

    await expectLater(controller.switchProfile('mia'), throwsA(same(failure)));

    expect(calls, ['mia', 'leo']);
    expect(activeId, 'leo');
  });

  test('rollback failure preserves the original switch error', () async {
    var activeId = 'leo';
    final original = StateError('original switch failure');
    final controller = WelcomeSplashController(
      readActiveProfileId: () => activeId,
      playTapAction: () async {},
      switchProfileAction: (id) async {
        activeId = id;
        if (id == 'mia') throw original;
        throw StateError('rollback failure');
      },
    );

    await expectLater(controller.switchProfile('mia'), throwsA(same(original)));
  });

  test('serial queue recovers for later switches after a failure', () async {
    var activeId = 'leo';
    var shouldFail = true;
    final controller = WelcomeSplashController(
      readActiveProfileId: () => activeId,
      playTapAction: () async {},
      switchProfileAction: (id) async {
        activeId = id;
        if (id == 'mia' && shouldFail) {
          shouldFail = false;
          throw StateError('first failure');
        }
      },
    );

    await expectLater(controller.switchProfile('mia'), throwsStateError);
    await controller.switchProfile('ava');

    expect(activeId, 'ava');
  });
}
