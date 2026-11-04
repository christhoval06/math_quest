import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/core/widgets/responsive_container.dart';
import 'package:math_quest/features/profile_and_stats/presentation/controllers/welcome_splash_controller.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/welcome_splash_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/welcome_brand_card.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/welcome_launch_button.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/welcome_loading_progress.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/welcome_profile_pill.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/welcome_profile_switcher.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/welcome_status_bar.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class WelcomeSplashScreen extends ConsumerStatefulWidget {
  const WelcomeSplashScreen({super.key});

  @override
  ConsumerState<WelcomeSplashScreen> createState() =>
      _WelcomeSplashScreenState();
}

class _WelcomeSplashScreenState extends ConsumerState<WelcomeSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;
  late final AnimationController _loadingController;
  late final Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
    _loadingAnimation = CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(welcomeSplashProvider);
    final controller = ref.read(welcomeSplashControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: ResponsiveContainer(
          child: Column(
            children: [
              const SizedBox(height: 12),
              WelcomeStatusBar(
                currentStreak: state.currentStreak,
                starCoins: state.starCoins,
                avatar: state.avatar,
                name: state.name,
                onProfileTap: () => _showProfileSwitcher(controller),
              ),
              const Spacer(flex: 2),
              AnimatedBuilder(
                animation: _floatAnimation,
                builder: (_, _) =>
                    WelcomeBrandCard(floatOffset: _floatAnimation.value),
              ),
              const SizedBox(height: 28),
              Text(
                AppLocalizations.of(context)!.welcomeAppName,
                style: AppTypography.titleLarge.copyWith(fontSize: 34),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.welcomeTagline,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 22),
              AnimatedBuilder(
                animation: _loadingAnimation,
                builder: (_, _) =>
                    WelcomeLoadingProgress(progress: _loadingAnimation.value),
              ),
              const Spacer(flex: 3),
              WelcomeLaunchButton(
                onPressed: () {
                  controller.playTap();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.mainShell,
                    (_) => false,
                  );
                },
              ),
              const SizedBox(height: 14),
              WelcomeProfilePill(
                avatar: state.avatar,
                name: state.name,
                gradeLabel: state.gradeLabel,
                onTap: () => _showProfileSwitcher(controller),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileSwitcher(WelcomeSplashController controller) {
    controller.playTap();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Consumer(
              builder: (_, sheetRef, _) {
                final sheetState = sheetRef.watch(welcomeSplashProvider);
                return WelcomeProfileSwitcher(
                  state: sheetState,
                  onProfileSelected: (profileId) =>
                      _switchProfile(sheetContext, controller, profileId),
                  onAddProfile: () {
                    Navigator.pop(sheetContext);
                    Navigator.pushNamed(
                      context,
                      AppRoutes.createProfile,
                      arguments: false,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _switchProfile(
    BuildContext sheetContext,
    WelcomeSplashController controller,
    String profileId,
  ) async {
    controller.playTap();
    try {
      await controller.switchProfile(profileId);
      if (sheetContext.mounted) Navigator.pop(sheetContext);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.profileSwitchFailed),
        ),
      );
    }
  }
}
