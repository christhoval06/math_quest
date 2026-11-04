import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/core/audio/i_sound_service.dart';
import 'package:math_quest/core/audio/sound_service_impl.dart';

/// Global provider giving any screen access to the sound engine
final soundServiceProvider = Provider<ISoundService>((ref) {
  return SoundServiceImpl();
});
