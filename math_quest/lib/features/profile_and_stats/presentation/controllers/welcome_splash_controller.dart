import 'dart:async';

class WelcomeSplashController {
  final _switchQueue = _AsyncSerialQueue();
  final String? Function() readActiveProfileId;
  final Future<void> Function() playTapAction;
  final Future<void> Function(String profileId) switchProfileAction;

  WelcomeSplashController({
    required this.readActiveProfileId,
    required this.playTapAction,
    required this.switchProfileAction,
  });

  void playTap() {
    unawaited(
      Future<void>.sync(playTapAction).catchError((Object _, StackTrace _) {
        // Audio is optional feedback and must never block the user action.
      }),
    );
  }

  Future<void> switchProfile(String profileId) {
    return _switchQueue.run(() async {
      final previousProfileId = readActiveProfileId();
      if (previousProfileId == profileId) return;

      try {
        await switchProfileAction(profileId);
      } catch (error, stackTrace) {
        if (previousProfileId != null && previousProfileId != profileId) {
          try {
            await switchProfileAction(previousProfileId);
          } catch (_) {
            // Preserve the original switch error for the screen.
          }
        }
        Error.throwWithStackTrace(error, stackTrace);
      }
    });
  }
}

class _AsyncSerialQueue {
  Future<void> _tail = Future<void>.value();

  Future<T> run<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _tail = _tail.then((_) async {
      try {
        completer.complete(await action());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }
}
