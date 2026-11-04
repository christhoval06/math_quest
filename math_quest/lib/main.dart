import 'package:flutter/foundation.dart';
import 'package:math_quest/features/landing/landing_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:math_quest/core/theme/theme_provider.dart';
import 'package:math_quest/core/storage/database_bootstrapper.dart';
import 'package:math_quest/core/localization/locale_provider.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/providers/settings_provider.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Marketing website uses the same feature code and localization, without
  // opening the gameplay database or initializing mobile services.
  if (kIsWeb) {
    runApp(const LandingApp());
    return;
  }

  // Initialize Hive offline database
  await DatabaseBootstrapper.initialize();

  // 🔍 Calculate initial route from Hive state
  final settingsBox = Hive.box('app_settings_box');
  final hasSeenOnboarding =
      settingsBox.get('has_seen_onboarding', defaultValue: false) as bool;
  final initialRoute = hasSeenOnboarding
      ? AppRoutes.welcome
      : AppRoutes.onboarding;

  runApp(ProviderScope(child: MathQuestApp(initialRoute: initialRoute)));
}

class MathQuestApp extends ConsumerWidget {
  final String initialRoute;

  const MathQuestApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final currentPalette = ref.watch(visualThemeProvider);
    ref.watch(settingsRuntimeInitializationProvider);

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: currentPalette.toThemeData(),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // 🚀 Centralized Core Routing!
      initialRoute: initialRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            // textScaler: TextScaler.noScaling,
            textScaler: mediaQuery.textScaler.clamp(
              minScaleFactor: 0.95,
              maxScaleFactor: 1.15,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
