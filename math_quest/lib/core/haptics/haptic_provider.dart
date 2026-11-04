import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/core/haptics/haptic_service_impl.dart';
import 'package:math_quest/core/haptics/i_haptic_service.dart';

final hapticServiceProvider = Provider<IHapticService>((ref) {
  return HapticServiceImpl();
});
