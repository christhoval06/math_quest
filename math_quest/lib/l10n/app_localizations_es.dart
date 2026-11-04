// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'MathQuest';

  @override
  String get tapToStart => '¡Toca para Iniciar la Aventura!';

  @override
  String playingAs(String name, String grade) {
    return 'Jugando como: $name ($grade)';
  }

  @override
  String dayStreak(int count) {
    return '¡Racha de $count Días!';
  }

  @override
  String get todaysMission => 'MISIÓN DE HOY';

  @override
  String get solveAddition => 'Resuelve 10 Sumas';

  @override
  String get continueMission => 'Continuar Misión';

  @override
  String get gameModes => 'Modos de Juego';

  @override
  String get allUnlocked => 'Todos Desbloqueados';

  @override
  String get quickPlay => 'Juego Rápido';

  @override
  String get practiceArena => 'Arena de Práctica';

  @override
  String get adventureIsland => 'Isla de Aventura';

  @override
  String get buddyChallenge => 'Duelo de Amigos';

  @override
  String get practiceLab => 'LABORATORIO';

  @override
  String get customMission => 'Misión Matemática Personalizada';

  @override
  String get chooseOperation => 'Elige Operación';

  @override
  String get chooseDifficulty => 'Dificultad (Dígitos)';

  @override
  String get chooseTimer => 'Elige Tiempo / Ritmo';

  @override
  String get funHelpers => 'Ayudas Divertidas';

  @override
  String get visualCountingAids => 'Bloques Visuales de Conteo';

  @override
  String get soundEffectsCheering => 'Efectos de Sonido y Ánimos';

  @override
  String get launchMission => '¡Lanzar Misión! (10 Preguntas)';

  @override
  String get pickYourAnswer => 'Elige tu respuesta:';

  @override
  String get skip => 'Saltar';

  @override
  String get checkAnswer => '¡Comprobar Respuesta!';

  @override
  String get correctTitle => '¡Trabajo Increíble! 🌟';

  @override
  String get wrongTitle => '¡Casi, intenta de nuevo!';

  @override
  String get continueBtn => 'Continuar';

  @override
  String get questComplete => '¡Misión Cumplida!';

  @override
  String get roundStats => 'Estadísticas de Ronda';

  @override
  String get correctAnswers => 'Respuestas Correctas';

  @override
  String get averageSpeed => 'Velocidad Promedio';

  @override
  String get playAnotherRound => 'Jugar Otra Ronda';

  @override
  String get reviewMistakes => 'Revisar Errores';

  @override
  String get backToHome => 'Volver al Inicio';

  @override
  String get trophyRoomTitle => 'Sala de Trofeos y Progreso';

  @override
  String get weeklyPractice => 'Práctica Semanal';

  @override
  String get mathMasteryTracks => 'Rutas de Maestría Matemática';

  @override
  String get recentBadges => 'Insignias Recientes';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get language => 'Idioma de la App';

  @override
  String get parentGateTitle => 'Zona de Adultos';

  @override
  String parentGatePrompt(int num1, int num2) {
    return 'Pide a un adulto que resuelva: ¿Cuánto es $num1 × $num2?';
  }

  @override
  String get navPlay => 'Jugar';

  @override
  String get navPractice => 'Práctica';

  @override
  String get navQuest => 'Aventura';

  @override
  String get navTrophies => 'Trofeos';

  @override
  String get settingsLabel => 'CONFIGURACIÓN DE LA APP';

  @override
  String get personalizeQuest => '¡Personaliza tu aventura!';

  @override
  String get settingsDescription =>
      'Ajusta los sonidos, cambia de perfil y administra los controles parentales.';

  @override
  String get soundsAndWorld => 'Sonidos y mundo de aventura';

  @override
  String get soundEffects => 'Efectos de sonido (SFX)';

  @override
  String get gameMelodies => 'Melodías del juego';

  @override
  String get voiceReadAloud => 'Lectura en voz alta';

  @override
  String get voiceReadAloudDescription =>
      'Lee los problemas en voz alta automáticamente';

  @override
  String get hapticTouch => 'Vibración al tocar';

  @override
  String get hapticTouchDescription =>
      'Siente una vibración al responder y al acertar o fallar';

  @override
  String get selectLanguage => '🌐 Elige el idioma';

  @override
  String get responseMode => 'Modo de respuesta';

  @override
  String get responseModeDescription => 'Elige cómo responder en toda la app.';

  @override
  String get responseChoice => 'Opciones';

  @override
  String get responseWrite => 'Escribir';

  @override
  String get responseChoiceDescription => 'Elige entre cuatro respuestas';

  @override
  String get responseWriteDescription => 'Escribe la respuesta';

  @override
  String responseModeSemantics(String mode) {
    return 'Modo de respuesta: $mode';
  }

  @override
  String get gameVisualTheme => 'Tema visual del juego';

  @override
  String get themeGalaxy => 'Aventura galáctica';

  @override
  String get themeGalaxyDescription => 'Espacio profundo';

  @override
  String get themeCandy => 'Tierra de dulces';

  @override
  String get themeCandyDescription => 'Colinas dulces';

  @override
  String get themeDino => 'Dino Mate';

  @override
  String get themeDinoDescription => 'Prehistórico';

  @override
  String get themeUnderwater => 'Bajo el mar';

  @override
  String get themeUnderwaterDescription => 'Arrecife de coral';

  @override
  String get whosPlaying => '¿Quién juega?';

  @override
  String profileSlotsUsed(int count) {
    return '$count de 3 perfiles en uso';
  }

  @override
  String get profilesUnavailable => 'Perfiles no disponibles';

  @override
  String get addChildProfile => 'Añadir perfil infantil';

  @override
  String get allProfileSlotsUsed => 'Los 3 perfiles están en uso';

  @override
  String profileLevel(int level) {
    return 'Niv. $level';
  }

  @override
  String get profileActive => 'Activo';

  @override
  String get switchProfile => 'Cambiar';

  @override
  String safeKidsEdition(String version) {
    return 'MathQuest v$version (Edición segura para niños)';
  }

  @override
  String get localProgressBackup =>
      'Todo el progreso se guarda de forma segura en este dispositivo.';

  @override
  String get parentZone => 'Zona de control parental';

  @override
  String get parentZoneDescription =>
      'Solo adultos: planes de estudio, temporizadores e informes';

  @override
  String dailyScreenLimit(String name) {
    return 'Límite diario de pantalla ($name)';
  }

  @override
  String get unlimited => 'Sin límite';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get targetMathStandard => 'Nivel de matemáticas objetivo';

  @override
  String get gradePreK => 'Preescolar';

  @override
  String get gradeOne => '1.er grado';

  @override
  String get gradeTwo => '2.º grado';

  @override
  String get gradeThreePlus => '3.er grado o más';

  @override
  String get resetCurrentHero =>
      'Reiniciar el progreso de aventura del héroe actual';

  @override
  String get resetProgressTitle => '¿Reiniciar todo el progreso?';

  @override
  String get resetProgressDescription =>
      'Se bloquearán todas las etapas y mundos completados y la Isla de Aventura volverá a la etapa 1. ¿Quieres continuar?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get resetNow => 'Reiniciar ahora';

  @override
  String get hero => 'Héroe';

  @override
  String get profileSwitched => '¡Perfil cambiado! 🚀';

  @override
  String switchedToProfile(String name) {
    return '¡Ahora juega $name! 🚀';
  }

  @override
  String screenLimitUpdated(String limit) {
    return '¡Límite de pantalla actualizado a $limit!';
  }

  @override
  String minutesLong(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String targetStandardUpdated(String standard) {
    return '¡Nivel de matemáticas establecido en $standard!';
  }

  @override
  String get adventureProgressReset =>
      '✅ ¡La Isla de Aventura ha vuelto a la etapa 1!';

  @override
  String get settingsUpdateFailed =>
      'No se pudo actualizar la configuración. Inténtalo de nuevo.';

  @override
  String explorerName(String name) {
    return 'Explorador $name';
  }

  @override
  String get readyForQuest => '¿Listo para tu aventura?';

  @override
  String get starryWaiting => '¡Starry te espera en la Cima Cósmica!';

  @override
  String get streakLabel => 'RACHA';

  @override
  String get starsLabel => 'ESTRELLAS';

  @override
  String get rankLabel => 'RANGO';

  @override
  String daysShort(int count) {
    return '${count}d';
  }

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get quickPlayDuration => '2 min';

  @override
  String get customModeBadge => 'Personalizado';

  @override
  String get storyModeBadge => 'Historia';

  @override
  String get twoPlayersBadge => '2 jugadores';

  @override
  String get quickPlayDescription =>
      '¡Resuelve a toda velocidad antes de que se acabe el tiempo!';

  @override
  String get practiceDescription => 'Elige operaciones, dígitos y ritmo.';

  @override
  String get adventureDescription =>
      'Vence monstruos matemáticos y encuentra tesoros.';

  @override
  String get buddyDescription => 'Juega por turnos con amigos o familiares.';

  @override
  String get playNowAction => 'Jugar ahora →';

  @override
  String get configureAction => 'Configurar →';

  @override
  String get exploreAction => 'Explorar →';

  @override
  String get battleAction => '¡Al duelo! →';

  @override
  String missionProgress(int current, int total) {
    return '$current de $total completados';
  }

  @override
  String dailyMissionReward(int coins, String badge) {
    return 'Recompensa: $coins monedas estrella y $badge';
  }

  @override
  String get missionCompletedToday => '¡Misión de hoy completada! 🎉';

  @override
  String claimMissionReward(int coins) {
    return '¡Recoge $coins monedas y tu insignia! 🎁';
  }

  @override
  String missionRewardAdded(int coins, String badge) {
    return '🎁 ¡Recibiste $coins monedas estrella y $badge!';
  }

  @override
  String get superpowerTipHeading => 'SECRETO MATEMÁTICO • Consejo de hoy';

  @override
  String get tryNextChallenge => '¡Pruébalo en tu próximo desafío! →';

  @override
  String get missionLabDescription =>
      '¡Elige tu superpoder matemático y las reglas del desafío!';

  @override
  String get practiceMode => '🎮 Modo práctica';

  @override
  String get examChallenge => '📝 Desafío de examen';

  @override
  String get selectOperation => 'Elige una operación';

  @override
  String get operationAddition => 'Suma';

  @override
  String get operationSubtraction => 'Resta';

  @override
  String get operationMultiplication => 'Multiplicación';

  @override
  String get operationDivision => 'División';

  @override
  String get appleCounters => 'Cuenta manzanas';

  @override
  String get balloonPops => 'Explota globos';

  @override
  String get boosters => 'Impulsores';

  @override
  String get pizzaSlices => 'Porciones de pizza';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyMedium => 'Media';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get easyDigits => '1 dígito (3 + 5)';

  @override
  String get mediumDigits => '2 dígitos (24 + 38)';

  @override
  String get hardDigits => '3 dígitos (145 + 289)';

  @override
  String get easyDescription => 'Un calentamiento suave para principiantes';

  @override
  String get mediumDescription => 'Un desafío escolar para ejercitar la mente';

  @override
  String get hardDescription => '¡Nivel de superhéroe matemático!';

  @override
  String get noTimer => 'Sin temporizador';

  @override
  String get relaxAndLearn => 'Relájate y aprende';

  @override
  String secondsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segundos',
      one: '1 segundo',
    );
    return '$_temp0';
  }

  @override
  String get twoMinutes => '2 minutos';

  @override
  String get rapidDash => 'Carrera rápida';

  @override
  String get standardPace => 'Ritmo normal';

  @override
  String get deepFocus => 'Concentración total';

  @override
  String get visualAidsDescription =>
      'Muestra bloques interactivos y una cuadrícula de puntos';

  @override
  String get soundCheeringDescription =>
      'Sonidos divertidos y campanitas de la mascota';

  @override
  String get numberOfQuestions => 'Número de preguntas';

  @override
  String questionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count preguntas',
      one: '1 pregunta',
    );
    return '$_temp0';
  }

  @override
  String get completionReward =>
      'Al completar: +50 estrellas y 1 llave de aventura';

  @override
  String get missionRewardXp => '100 EXP';

  @override
  String launchMissionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count preguntas',
      one: '1 pregunta',
    );
    return '¡Iniciar misión! ($_temp0)';
  }

  @override
  String startExamCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count preguntas',
      one: '1 pregunta',
    );
    return 'Iniciar examen ($_temp0)';
  }

  @override
  String dailyAdditionTitle(int count) {
    return 'Resuelve $count sumas';
  }

  @override
  String dailySubtractionTitle(int count) {
    return 'Resuelve $count restas';
  }

  @override
  String dailyMultiplicationTitle(int count) {
    return 'Resuelve $count multiplicaciones';
  }

  @override
  String dailyDivisionTitle(int count) {
    return 'Resuelve $count divisiones';
  }

  @override
  String get spaceDetectiveBadge => 'Insignia de detective espacial';

  @override
  String get balloonPopperBadge => 'Insignia de explota globos';

  @override
  String get lightningBoosterBadge => 'Insignia de impulso relámpago';

  @override
  String get pizzaMasterBadge => 'Insignia de maestro de la pizza';

  @override
  String get tipDoublesTitle => '¡El truco de «dobles + 1»!';

  @override
  String get tipDoublesDescription =>
      'Si sabes que 6 + 6 = 12, entonces 6 + 7 es muy fácil: ¡suma 1 más para llegar a 13!';

  @override
  String get tipMakeTenTitle => '¡El secreto de «formar un 10»!';

  @override
  String get tipMakeTenDescription =>
      '¿8 + 5 parece difícil? ¡Toma 2 del 5 para convertir el 8 en 10! Luego, 10 + 3 = 13.';

  @override
  String get tipSubtractTenTitle => '¡El truco de «bajar a 10»!';

  @override
  String get tipSubtractTenDescription =>
      '¿Cuánto es 15 - 7? ¡Primero resta 5 para llegar a 10 y luego resta los 2 que faltan para obtener 8!';

  @override
  String get tipTimesFiveTitle => '¡El truco de «multiplicar por 5»!';

  @override
  String get tipTimesFiveDescription =>
      '¿6 × 5? ¡Añade un cero para obtener 60 y toma la mitad: 30! ¡Siempre funciona!';

  @override
  String get tipNinesTitle => '¡La magia del 9!';

  @override
  String get tipNinesDescription =>
      '¡Las cifras de la tabla del 9 suman 9! 9 × 3 = 27 (2+7=9). ¡9 × 4 = 36 (3+6=9)!';

  @override
  String get tipHalvingTitle => '¡Divide entre 4 tomando la mitad dos veces!';

  @override
  String get tipHalvingDescription =>
      '¡Para dividir entre 4, toma la mitad del número y luego otra vez la mitad! 28 → 14 → 7.';

  @override
  String get tipZeroTitle => '¡La regla del «héroe cero»!';

  @override
  String get tipZeroDescription =>
      '¡Cualquier número más cero queda igual, pero cualquier número multiplicado por cero se convierte en 0!';

  @override
  String get tapCorrectAnswer => 'Toca la respuesta correcta:';

  @override
  String get writeCorrectAnswer => 'Escribe la respuesta correcta:';

  @override
  String get matchSetup => 'Configurar partida';

  @override
  String get questionReview => 'Revisión de preguntas';

  @override
  String get nextStage => 'Siguiente etapa 🚀';

  @override
  String get playAnotherRoundAction => 'Jugar otra ronda 🔄';

  @override
  String reviewMistakesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errores',
      one: '1 error',
    );
    return 'Revisar $_temp0 🎯';
  }

  @override
  String get backAdventureMap => 'Volver al mapa de aventura 🏝️';

  @override
  String get backHomeAction => 'Volver al inicio 🏠';

  @override
  String targetBoss(String name) {
    return 'Jefe objetivo: $name';
  }

  @override
  String worldTitle(int index, String name) {
    return 'Mundo $index: $name';
  }

  @override
  String get switchIsland => 'Cambiar de isla';

  @override
  String get countingHelpers => 'Ayudas para contar';

  @override
  String get tensAndOnes => 'Decenas y unidades';

  @override
  String numberDecomposition(int value, int tens, int ones) {
    return '$value ($tens decenas, $ones unidades)';
  }

  @override
  String startBuddyChallenge(int points) {
    return '¡Iniciar duelo! (Primero en llegar a $points puntos)';
  }

  @override
  String get buddyRulesDescription =>
      '¡Elige a los jugadores y las reglas del duelo!';

  @override
  String get buddyArena => 'ARENA DE AMIGOS';

  @override
  String get playerOne => 'Jugador 1';

  @override
  String get playerTwo => 'Jugador 2';

  @override
  String get playerNames => 'Nombres de jugadores';

  @override
  String get pointsToWin => 'Puntos para ganar';

  @override
  String pointsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntos',
      one: '1 punto',
    );
    return '$_temp0';
  }

  @override
  String get pointsTargetDescription => 'Gana quien alcance primero la meta';

  @override
  String buddyScore(int score1, int score2) {
    return 'J1: $score1  vs  J2: $score2';
  }

  @override
  String firstToPoints(int points) {
    return 'Primero en llegar a $points puntos';
  }

  @override
  String winnerName(String name) {
    return '¡$name gana!';
  }

  @override
  String get outstandingReflexes => '¡Qué buenos reflejos matemáticos!';

  @override
  String get playAgain => 'Jugar de nuevo';

  @override
  String get changeSettings => 'Cambiar configuración';

  @override
  String get exit => 'Salir';

  @override
  String get champion => 'CAMPEÓN';

  @override
  String finalScoreSemantics(int score1, int score2) {
    return 'Puntuación final: jugador 1, $score1; jugador 2, $score2';
  }

  @override
  String get finalScore => 'PUNTUACIÓN FINAL';

  @override
  String correctAnswerExplanation(String answer) {
    return 'La respuesta correcta es $answer. ¡Sigue adelante, explorador!';
  }

  @override
  String get sparkyAdvice => 'Sparky dice: ¡Tómate tu tiempo y piensa bien!';

  @override
  String get worldBossDefeated => '¡JEFE DEL MUNDO DERROTADO!';

  @override
  String welcomeToWorld(String name) {
    return '¡Bienvenido a $name!';
  }

  @override
  String get newIslandDescription =>
      '¡Una nueva isla apareció en tu mapa con desafíos matemáticos y un jefe legendario!';

  @override
  String get exploreNewIsland => '¡Explorar nueva isla! 🚀';

  @override
  String starCoinsReward(int count) {
    return '+$count monedas estrella';
  }

  @override
  String mathXpReward(int count) {
    return '+$count EXP de matemáticas';
  }

  @override
  String accuracyPercent(int percent) {
    return '$percent% de precisión';
  }

  @override
  String averageSecondsItem(double seconds) {
    final intl.NumberFormat secondsNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String secondsString = secondsNumberFormat.format(seconds);

    return '${secondsString}s / pregunta';
  }

  @override
  String elapsedSeconds(double seconds) {
    final intl.NumberFormat secondsNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String secondsString = secondsNumberFormat.format(seconds);

    return '${secondsString}s';
  }

  @override
  String get stellaCoach => 'ENTRENADORA ESTELAR STELLA';

  @override
  String stellaExcellent(String name) {
    return '«¡Excelente, $name! ¡Lo hiciste genial en esta misión!»';
  }

  @override
  String get stellaEncouragement =>
      '«¡Buen esfuerzo, explorador! ¡Cada error ayuda a tu cerebro a crecer!»';

  @override
  String get tryAgainTitle => '¡Inténtalo de nuevo!';

  @override
  String get mistakeCorrected => '🎉 ¡Genial! ¡Corregiste tu error!';

  @override
  String get useCountingBlocks => '¡Casi! Usa los bloques para contar.';

  @override
  String get close => 'Cerrar';

  @override
  String chosenAnswer(String answer) {
    return 'Elegiste: $answer';
  }

  @override
  String get noAnswer => 'Ninguna';

  @override
  String get retry => 'Reintentar';

  @override
  String get countingHint =>
      'Pista: ¡Tómate tu tiempo y usa los bloques de decenas y unidades!';

  @override
  String get correctedSuccessfully => '🌟 ¡Corregido con éxito!';

  @override
  String starsEarned(int count) {
    return '$count DE 3 ESTRELLAS GANADAS';
  }

  @override
  String get newBadgeUnlocked => '¡NUEVA INSIGNIA DESBLOQUEADA!';

  @override
  String get correctAnswerSemantics => 'Respuesta correcta';

  @override
  String get incorrectAnswerSemantics => 'Respuesta incorrecta';

  @override
  String get writtenAnswerSemantics => 'Respuesta escrita';

  @override
  String get retryAnswerSemantics => 'Intenta comprobar la respuesta de nuevo';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get checkWrittenAnswer => 'Comprobar respuesta';

  @override
  String get tryAgainTooltip => 'Intentar de nuevo';

  @override
  String get checkAnswerTooltip => 'Comprobar respuesta';

  @override
  String get deleteDigit => 'Borrar dígito';

  @override
  String get checkingAnswer => 'Comprobando la respuesta';

  @override
  String get checkingStatus => 'Comprobando…';

  @override
  String examStageLabel(int current, int total) {
    return 'DESAFÍO DE EXAMEN ($current/$total)';
  }

  @override
  String operationAdventure(String operation) {
    return 'AVENTURA DE $operation';
  }

  @override
  String adventureNamePart(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'p0': 'de esmeralda',
      'p1': 'del sol',
      'p2': 'de los susurros',
      'p3': 'del verdor',
      'p4': 'de oro',
      'p5': 'Atolón',
      'p6': 'Isla',
      'p7': 'Costas',
      'p8': 'Pradera',
      'p9': 'Refugio',
      'p10': 'de ciruela dulce',
      'p11': 'de algodón de azúcar',
      'p12': 'de piruletas',
      'p13': 'de caramelo',
      'p14': 'de dulces',
      'p15': 'Cañón',
      'p16': 'Isla',
      'p17': 'Arrecife',
      'p18': 'Laguna',
      'p19': 'Reino',
      'p20': 'de la prehistoria',
      'p21': 'del trueno',
      'p22': 'del jurásico',
      'p23': 'de ámbar',
      'p24': 'de la antigüedad',
      'p25': 'Selva',
      'p26': 'Peñasco',
      'p27': 'Tierras salvajes',
      'p28': 'Santuario',
      'p29': 'de los astros',
      'p30': 'de estrellas fugaces',
      'p31': 'de luz estelar',
      'p32': 'de la galaxia',
      'p33': 'del cosmos',
      'p34': 'Cima',
      'p35': 'Archipiélago',
      'p36': 'Cumbres',
      'p37': 'Nebulosa',
      'p38': 'Aguja',
      'p39': 'de las profundidades',
      'p40': 'del azul',
      'p41': 'de las mareas',
      'p42': 'de zafiro',
      'p43': 'de aguamarina',
      'p44': 'Ensenada',
      'p45': 'Cayo',
      'p46': 'Abismo',
      'p47': 'Profundidad',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String adventureLandmark(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      's0': 'Playa de guijarros',
      's1': 'Bosque de bambú',
      's2': 'Valle del trébol',
      's3': 'Cresta de la cascada',
      's4': 'Fortaleza del gólem',
      's5': 'Costa de gomitas',
      's6': 'Sendero de malvaviscos',
      's7': 'Río de chocolate',
      's8': 'Pico de piruletas',
      's9': 'Castillo dulce del dragón',
      's10': 'Playa de fósiles',
      's11': 'Dosel de helechos',
      's12': 'Barranco del raptor',
      's13': 'Laderas del volcán',
      's14': 'Sala del trono del T-Rex',
      's15': 'Cuenca de polvo estelar',
      's16': 'Puente de meteoros',
      's17': 'Cresta de la aurora',
      's18': 'Pozo de gravedad',
      's19': 'Observatorio del titán',
      's20': 'Ensenada del pez payaso',
      's21': 'Caverna de conchas',
      's22': 'Galeón hundido',
      's23': 'Fosa de perlas',
      's24': 'Guarida sumergida del kraken',
      's25': 'Gólem de piedra',
      's26': 'Dragón de azúcar',
      's27': 'Rey matemático T-Rex',
      's28': 'Titán estelar',
      's29': 'Señor kraken',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String gameBadgeTitle(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'speed_counter': 'Contador veloz',
      'lightning_math': 'Matemáticas relámpago',
      'quick_thinker': 'Pensador rápido',
      'clean_slate': 'Héroe sin errores',
      'sharp_shooter': 'Puntería perfecta',
      'flawless_focus': 'Concentración impecable',
      'early_starter': 'Primer hábito',
      'week_warrior': 'Guerrero semanal',
      'fortnight_legend': 'Titán de la quincena',
      'half_century': 'Los primeros cincuenta',
      'century_club': 'Club de los cien',
      'grand_master_500': 'Maratonista matemático',
      'millennium_scholar': 'Sabio del milenio',
      'addition_superhero': 'Héroe de la suma',
      'minus_ninja': 'Ninja de la resta',
      'times_master': 'Maestro de la multiplicación',
      'division_champ': 'Campeón del reparto',
      'boss_slayer': 'Conquistador de islas',
      'space_detective': 'Detective espacial',
      'quad_master': 'Gran polímata',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String gameBadgeDescription(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'speed_counter':
          'Responde 5 preguntas en menos de 5 segundos cada una en una ronda.',
      'lightning_math': 'Responde 10 preguntas correctamente en menos de 30 segundos en total.',
      'quick_thinker': 'Resuelve tu primer problema en menos de 3 segundos.',
      'clean_slate':
          'Logra un 100% de precisión en una ronda de al menos 10 preguntas.',
      'sharp_shooter': 'Consigue 5 respuestas correctas seguidas sin errores.',
      'flawless_focus': 'Completa una ronda de 15 o más preguntas con al menos un 90% de precisión.',
      'early_starter': 'Mantén una racha de aprendizaje de 3 días.',
      'week_warrior': 'Mantén una racha de aprendizaje de 7 días.',
      'fortnight_legend': 'Alcanza una racha de práctica de 14 días.',
      'half_century':
          'Resuelve 50 problemas en total entre todas las operaciones.',
      'century_club':
          'Resuelve 100 problemas en total entre todas las operaciones.',
      'grand_master_500': 'Alcanza 500 preguntas respondidas.',
      'millennium_scholar': '¡Resuelve un total de 1.000 preguntas!',
      'addition_superhero':
          'Resuelve 100 sumas con al menos un 90% de precisión.',
      'minus_ninja': 'Resuelve 100 restas con al menos un 85% de precisión.',
      'times_master':
          'Alcanza el nivel 4 en la ruta de dominio de la multiplicación.',
      'division_champ': 'Resuelve 75 desafíos de división sin resto.',
      'boss_slayer': 'Derrota a un jefe del mundo en la Isla de Aventura.',
      'space_detective': 'Completa la misión diaria de hoy.',
      'quad_master': 'Alcanza al menos el nivel 3 en las 4 operaciones.',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String adventureIslandName(String prefix, String suffix) {
    return '$suffix $prefix';
  }

  @override
  String get welcomeAppName => 'Math Quest';

  @override
  String get welcomeTagline => '¡Aprende, juega y cuenta!';

  @override
  String get profileSwitchFailed =>
      'No se pudo cambiar de perfil. Inténtalo de nuevo.';

  @override
  String get addChildProfileTitle => 'Añadir perfil infantil';

  @override
  String get createHero => '¡Crea tu héroe!';

  @override
  String get createHeroDescription =>
      'Elige tu avatar y dinos tu nombre para comenzar.';

  @override
  String get chooseAvatar => 'Elige tu avatar';

  @override
  String get explorerNamePrompt => '¿Cómo te llamas, explorador?';

  @override
  String get enterName => 'Escribe tu nombre';

  @override
  String get selectGrade => 'Elige tu grado escolar';

  @override
  String get creatingProfile => 'Creando perfil…';

  @override
  String get startMyAdventure => '¡Comenzar mi aventura! 🚀';

  @override
  String profileCreated(String name) {
    return '🎉 ¡Bienvenido, $name! Tu perfil está creado y activo.';
  }

  @override
  String get profileCreationFailed =>
      'No se pudo crear el perfil. Inténtalo de nuevo.';

  @override
  String get profileSwitcherDescription =>
      '¡Elige tu perfil para continuar la aventura!';

  @override
  String get chargingBoosters => 'Cargando impulsores matemáticos...';

  @override
  String get warmingSuperpowers => 'Preparando superpoderes...';

  @override
  String get readyForAdventure => '¡Listo para la aventura! 🚀';

  @override
  String welcomeGreeting(String name) {
    return '¡Hola, $name!';
  }

  @override
  String get starMath => 'MATEMÁTICAS ESTELARES';

  @override
  String get onboardingWelcomeTitle => '¡Bienvenido a MathQuest!';

  @override
  String get onboardingWelcomeDescription =>
      'Convierte las matemáticas en una aventura cósmica donde aprender es tan divertido como jugar.';

  @override
  String get onboardingBlocksTitle => 'Bloques visuales para contar';

  @override
  String get onboardingBlocksDescription =>
      '¡Da vida a los números con bloques de base 10! Cuenta decenas y unidades para aprender a sumar llevando.';

  @override
  String get onboardingAdventureTitle => 'Derrota jefes y gana trofeos';

  @override
  String get onboardingAdventureDescription =>
      '¡Explora la Isla de Aventura, desbloquea mundos, reúne insignias y compite en duelos de dos jugadores!';

  @override
  String get getStarted => 'Comenzar 🚀';

  @override
  String get next => 'Siguiente';

  @override
  String get gradeKindergarten => 'Preescolar';

  @override
  String gradeAgeRange(int min, int max) {
    return 'Edad $min-$max';
  }

  @override
  String avatarOption(String avatar) {
    return 'Avatar $avatar';
  }

  @override
  String onboardingPage(int current, int total) {
    return 'Página $current de $total';
  }

  @override
  String get switchProfileAction => 'Cambiar perfil';

  @override
  String get allBadgesTitle => 'Todas las insignias y trofeos';

  @override
  String get badgeUnlockedCaps => '✅ DESBLOQUEADA';

  @override
  String get badgeLockedCaps => '🔒 BLOQUEADA';

  @override
  String get badgeUnlocked => '✅ Desbloqueada';

  @override
  String get badgeLocked => '🔒 Bloqueada';

  @override
  String get gotIt => '¡Entendido!';

  @override
  String get awesome => '¡Genial!';

  @override
  String viewAllCount(int count) {
    return 'Ver todas ($count)';
  }

  @override
  String operationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count operaciones',
      one: '1 operación',
    );
    return '$_temp0';
  }

  @override
  String get parentDiagnosticTitle => 'Informe de diagnóstico para padres';

  @override
  String get superMathematician => '¡SUPER MATEMÁTICO!';

  @override
  String get keepShining =>
      '¡Sigue brillando! Estás cumpliendo tus metas diarias.';

  @override
  String get totalSolvedLabel => 'TOTAL RESUELTO';

  @override
  String get accuracyLabel => 'PRECISIÓN';

  @override
  String get unstoppable => '¡Imparable! 🔥';

  @override
  String get trophiesLabel => 'TROFEOS';

  @override
  String badgesRemaining(int count) {
    return 'Faltan $count por desbloquear';
  }

  @override
  String dailyProblemGoal(int count) {
    return 'Meta diaria: $count problemas';
  }

  @override
  String get weeklyGoalMet => '🎯 ¡Meta cumplida!';

  @override
  String get weeklyKeepGoing => '¡Sigue practicando!';

  @override
  String get noWeeklyData => 'Aún no hay práctica';

  @override
  String get noCategoryBadges => 'Aún no hay insignias en esta categoría.';

  @override
  String get noMasteryData => 'Comienza a practicar para ver tu progreso.';

  @override
  String shortAccuracy(int percent) {
    return '$percent% aciertos';
  }

  @override
  String masteryRank(String icon, String title, int level) {
    return '$icon $title (Nivel $level)';
  }

  @override
  String masteryProgress(int solved, int remaining, int level) {
    return '$solved resueltos • faltan $remaining para el nivel $level';
  }

  @override
  String masteryMaxProgress(int solved) {
    return '$solved resueltos • ¡Nivel máximo! 👑';
  }

  @override
  String get curriculumBreakdown =>
      'Desglose de operaciones del plan de estudios';

  @override
  String get activeStudent => 'Estudiante activo';

  @override
  String gradeAligned(String grade) {
    return '$grade • Alineado con Common Core';
  }

  @override
  String reportDate(String date) {
    return 'Fecha del informe: $date';
  }

  @override
  String get readinessIndex => 'ÍNDICE DE PREPARACIÓN ESCOLAR';

  @override
  String get noOperationData => 'Aún no hay datos de operaciones.';

  @override
  String get stellaObservations =>
      'Observaciones de la profesora y entrenadora Stella';

  @override
  String get identifiedStrength => 'Fortaleza identificada:';

  @override
  String get recommendedFocus => 'Enfoque recomendado:';

  @override
  String get baselineGathering => 'Recopilando datos iniciales';

  @override
  String masteryPercent(int percent) {
    return '$percent% de dominio';
  }

  @override
  String readinessStrong(String name) {
    return '$name demuestra una base numérica sólida y avanza hacia niveles más complejos.';
  }

  @override
  String readinessStarting(String name) {
    return '$name está construyendo sus habilidades básicas. Se recomiendan sesiones diarias de 10 minutos.';
  }

  @override
  String get noRoundsCompleted => 'Sin rondas completadas';

  @override
  String questionsAnswered(int count) {
    return '$count preguntas respondidas';
  }

  @override
  String get diagnosticPending => 'Evaluación pendiente';

  @override
  String get diagnosticNeedsPractice => 'Necesita práctica 🎯';

  @override
  String get diagnosticOnTrack => 'Buen progreso ⚡';

  @override
  String get diagnosticMastered => 'Dominado ✅';

  @override
  String get closeParentVerification => 'Cerrar verificación parental';

  @override
  String get adultVerificationCaps => 'VERIFICACIÓN DE ADULTO';

  @override
  String get adultVerification => 'Verificación de adulto';

  @override
  String get parentControlsProtected =>
      'Esta verificación ayuda a proteger los controles para adultos.';

  @override
  String get parentAnswerSemantics => 'Respuesta de verificación parental';

  @override
  String get answer => 'Respuesta';

  @override
  String get gateAnswerRequired => 'Escribe una respuesta para continuar.';

  @override
  String get gateNumbersOnly => 'Usa solo números.';

  @override
  String get gateAnswerIncorrect => 'No es correcto. Inténtalo de nuevo.';

  @override
  String parentVerificationPrompt(String first, String second) {
    return '¿Cuánto es $first × $second?';
  }

  @override
  String get timeForRest => '¡Hora de descansar!';

  @override
  String get restDescription =>
      '¡Buen trabajo en tu aventura de hoy! Starry está durmiendo. Pide ayuda a un adulto si quieres seguir jugando.';

  @override
  String get parentUnlock => 'Desbloqueo parental 🛡️';

  @override
  String get gateSettingsTitle => 'Configuración parental';

  @override
  String get gateSettingsDescription =>
      'Confirma que eres un adulto antes de abrir la configuración protegida.';

  @override
  String get unlockSettings => 'Desbloquear configuración';

  @override
  String get gateScreenLimitTitle => 'Cambiar límite de pantalla';

  @override
  String get gateScreenLimitDescription =>
      'Confirma que eres un adulto antes de cambiar el tiempo diario de juego.';

  @override
  String get gateLearningTitle => 'Cambiar meta de aprendizaje';

  @override
  String get gateLearningDescription =>
      'Confirma que eres un adulto antes de cambiar el nivel de matemáticas objetivo.';

  @override
  String get gateResetTitle => 'Reiniciar progreso de aventura';

  @override
  String get gateResetDescription =>
      'Esta acción está protegida. Confirma que eres un adulto para continuar.';

  @override
  String get gateExtraTimeTitle => 'Añadir tiempo de juego';

  @override
  String get gateExtraTimeDescription =>
      'Confirma que eres un adulto antes de añadir 15 minutos más.';

  @override
  String get addFifteenMinutes => 'Añadir 15 minutos';

  @override
  String badgeCategory(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'ALL': 'TODAS',
      'SPEED': 'VELOCIDAD',
      'ACCURACY': 'PRECISIÓN',
      'STREAK': 'RACHA',
      'MILESTONE': 'LOGROS',
      'MASTERY': 'DOMINIO',
      'ADVENTURE': 'AVENTURA',
      'DAILY': 'DIARIAS',
      'LEGENDARY': 'LEGENDARIAS',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String badgeTier(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'bronze': 'BRONCE',
      'silver': 'PLATA',
      'gold': 'ORO',
      'diamond': 'DIAMANTE',
      'other': '$key',
    });
    return '$_temp0';
  }

  @override
  String masteryTierTitle(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'l1': 'Explorador principiante',
      'l2': 'Cadete de los números',
      'l3': 'Aventurero matemático',
      'l4': 'Estrella en ascenso',
      'l5': 'Mago de los números',
      'l6': 'Superhéroe matemático',
      'l7': 'Campeón cósmico',
      'l8': 'Mente brillante',
      'l9': 'Gran titán',
      'l10': '¡Leyenda suprema de las matemáticas!',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String gateNumberWord(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'n0': 'cero',
      'n1': 'uno',
      'n2': 'dos',
      'n3': 'tres',
      'n4': 'cuatro',
      'n5': 'cinco',
      'n6': 'seis',
      'n7': 'siete',
      'n8': 'ocho',
      'n9': 'nueve',
      'n10': 'diez',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String weekdayShort(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'd0': 'Lun',
      'd1': 'Mar',
      'd2': 'Mié',
      'd3': 'Jue',
      'd4': 'Vie',
      'd5': 'Sáb',
      'd6': 'Dom',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String solvedToday(int count) {
    return '+$count hoy';
  }

  @override
  String get practiceAccuracy => 'En operaciones practicadas';

  @override
  String get explorerLabel => 'Explorador';

  @override
  String get observationNeedsPractice =>
      'Completa una sesión de práctica para descubrir fortalezas.';

  @override
  String get observationBuilding =>
      'Las habilidades aún se están desarrollando. Sigue practicando para mejorar la precisión.';

  @override
  String observationStrength(String operation, int percent, int count) {
    return '$operation: $percent% de precisión en $count preguntas respondidas.';
  }

  @override
  String get observationStart =>
      'Prueba una sesión corta de práctica para comenzar la evaluación.';

  @override
  String get observationMaintain =>
      'Sigue practicando todas las operaciones para mantener la precisión.';

  @override
  String observationTry(String operation) {
    return 'Prueba $operation para reunir datos de evaluación.';
  }

  @override
  String observationFocus(String operation, int percent) {
    return 'Practica $operation, actualmente con un $percent% de precisión.';
  }

  @override
  String get appTagline => 'Un poco de práctica. Una gran aventura.';

  @override
  String get aboutSectionTitle => 'ACERCA DE';

  @override
  String get aboutAppTitle => 'Sobre MathQuest';

  @override
  String get aboutAppSubtitle => 'Una pequeña idea, inspirada por Dion';

  @override
  String get aboutAppStory =>
      'Creé MathQuest para ayudar a mi hijo Dion a estudiar matemáticas. Como no siempre tenemos lápiz y papel a mano, quería una forma sencilla de convertir cualquier ratito libre en una oportunidad para aprender juntos.';

  @override
  String get aboutPracticeTitle => 'Practicar en cualquier lugar';

  @override
  String get aboutPracticeBody =>
      'Unos minutos de matemáticas, dondequiera que te lleve el día.';

  @override
  String get aboutPaceTitle => 'A su propio ritmo';

  @override
  String get aboutPaceBody =>
      'Distintos grados y actividades para acompañar a cada pequeño explorador.';

  @override
  String get aboutFamilyTitle => 'Para aprender en familia';

  @override
  String get aboutFamilyBody =>
      'Un proyecto que nació en casa para hacer de las matemáticas parte del día a día.';

  @override
  String get aboutDeveloperTitle => 'Sobre el desarrollador';

  @override
  String get aboutDeveloperSubtitle => 'La persona detrás de MathQuest';

  @override
  String get aboutDeveloperBio =>
      'Hola, soy @christhoval, ingeniero fullstack y Tech Lead Front-End en Panamá. Trabajo con JavaScript y Python, y construyo herramientas CLI, paquetes npm y apps móviles. Me enfoco en crear productos útiles, cuidar la experiencia de uso y la privacidad desde el diseño. MathQuest nació de un deseo sencillo: ayudar a Dion a disfrutar aprendiendo matemáticas.';

  @override
  String get developerRoleTitle => 'Rol actual';

  @override
  String get developerRoleBody => 'Ingeniero fullstack y Tech Lead Front-End.';

  @override
  String get developerStackTitle => 'Stack principal';

  @override
  String get developerStackBody =>
      'JavaScript, TypeScript, Python, Flutter, CLI y npm.';

  @override
  String get developerFocusTitle => 'Enfoque';

  @override
  String get developerFocusBody =>
      'Producto, experiencia de usuario y privacidad desde el diseño.';

  @override
  String get contactSupportTitle => 'Contacto / Soporte';

  @override
  String get contactSupportSubtitle => 'Reportar un error o compartir una idea';

  @override
  String get supportEmailSubject => 'MathQuest — Soporte';

  @override
  String get supportEmailBody =>
      'Hola, Christhoval:\n\nTe escribo sobre MathQuest:\n\n';

  @override
  String get supportEmailUnavailable =>
      'No hay una app de correo disponible. Puedes escribirme a la siguiente dirección.';

  @override
  String get copyEmail => 'Copiar correo electrónico';

  @override
  String get emailCopied => 'Correo electrónico copiado';

  @override
  String get landingPageTitle =>
      'MathQuest · Pequeños pasos. Confianza cósmica.';

  @override
  String get landingNavLearning => 'Cómo aprende';

  @override
  String get landingNavModes => 'Formas de jugar';

  @override
  String get landingNavParents => 'Para familias';

  @override
  String get landingNavGallery => 'Dentro de la app';

  @override
  String get landingLanguageLabel => 'Idioma';

  @override
  String get landingStartAction => 'Descárgalo en App Store';

  @override
  String get landingExploreAction => 'Explora los modos';

  @override
  String get landingHeroEyebrow => 'PEQUEÑOS PASOS. GRANDES DESCUBRIMIENTOS.';

  @override
  String get landingHeroLead => 'Convierte las matemáticas en una';

  @override
  String get landingHeroAccent => 'aventura cósmica.';

  @override
  String get landingHeroDescription =>
      'Un poco de práctica. ¡Muchos “lo logré”! Ayuda a tu peque a ganar confianza con matemáticas visuales, retos divertidos y un universo de pequeños logros.';

  @override
  String get landingProofOffline => 'Funciona sin conexión';

  @override
  String get landingProofAds => 'Sin anuncios. Solo descubrimientos.';

  @override
  String get landingProofProfiles => 'Un espacio para cada peque';

  @override
  String get landingDailyBadge => 'Un pequeño logro cada día';

  @override
  String get landingDailyBadgeDetail => 'Su próxima aventura les espera.';

  @override
  String get landingStatOperations => 'Operaciones esenciales';

  @override
  String get landingStatDifficulty => 'Niveles para crecer';

  @override
  String get landingStatWorlds => 'Mundos por explorar';

  @override
  String get landingStatAds => 'Anuncios en su camino';

  @override
  String get landingLearningEyebrow => 'COMPRENDER ANTES DE MEMORIZAR';

  @override
  String get landingLearningTitle =>
      'Las matemáticas son más fáciles\ncuando se pueden ver.';

  @override
  String get landingLearningIntro =>
      'Del “¿qué significa?” al “¡ya sé cómo!”. Las ayudas visuales convierten ideas abstractas en descubrimientos.';

  @override
  String get landingBlocksTitle => 'Grandes ideas. Pequeños bloques.';

  @override
  String get landingBlocksBody =>
      'Las barras de decenas y puntos de unidades ayudan a comprender el valor posicional, las llevadas y el conteo.';

  @override
  String get landingEncouragementTitle => 'Un espacio seguro para reintentar';

  @override
  String get landingEncouragementBody =>
      'Las pistas y el ánimo mantienen viva la curiosidad, incluso cuando hace falta intentarlo otra vez.';

  @override
  String get landingPaceTitle => 'A su ritmo. Con sus descubrimientos.';

  @override
  String get landingPaceBody =>
      'Empieza con apoyo visual y avanza hacia la resolución independiente, paso a paso.';

  @override
  String get landingModesEyebrow => 'APRENDIZAJE REAL. DIVERSIÓN SIN LÍMITES.';

  @override
  String get landingModesTitle =>
      'Distintos momentos.\nUn universo de formas de jugar.';

  @override
  String get landingModesIntro =>
      '¿Una práctica tranquila o un duelo amistoso? Hay una aventura para cada forma de aprender.';

  @override
  String get landingPracticeTitle => 'Arena de práctica';

  @override
  String get landingPracticeBody =>
      'Respira, prueba una estrategia y deja que las ayudas visuales te guíen.';

  @override
  String get landingPracticeTag => 'SIN PRISA. CON PROGRESO.';

  @override
  String get landingDuelTitle => 'Duelo para dos';

  @override
  String get landingDuelBody =>
      'Una pantalla. Dos exploradores. Practiquen juntos con un reto amistoso.';

  @override
  String get landingDuelTag => 'MEJOR EN COMPAÑÍA';

  @override
  String get landingMissionTitle => 'Misiones a medida';

  @override
  String get landingMissionBody =>
      'Elige la operación, la dificultad y el tiempo. Crea la misión ideal para hoy.';

  @override
  String get landingMissionTag => 'SU PROPIA AVENTURA';

  @override
  String get landingWorldTitle => 'Isla de aventuras';

  @override
  String get landingWorldBody =>
      'Sigue un camino de pequeños retos y descubre qué hay en la siguiente parada.';

  @override
  String get landingWorldTag => 'SIGUE EXPLORANDO';

  @override
  String get landingRewardsEyebrow => 'CADA ESFUERZO MERECE CELEBRARSE';

  @override
  String get landingRewardsTitle =>
      'Celebra su esfuerzo.\nHaz brillar su confianza.';

  @override
  String get landingRewardsIntro =>
      'Cada pequeño logro invita a volver. En MathQuest, el progreso se puede ver, coleccionar y celebrar.';

  @override
  String get landingCoinsTitle => 'Monedas estelares';

  @override
  String get landingCoinsBody => 'Un poco de brillo por su esfuerzo.';

  @override
  String get landingStreakTitle => 'Rachas diarias';

  @override
  String get landingStreakBody => 'Un hábito, un día feliz a la vez.';

  @override
  String get landingBadgesTitle => 'Trofeos para recordar';

  @override
  String get landingBadgesBody => 'Logros que dan ganas de compartir.';

  @override
  String get landingWorldsTitle => 'Nuevos mundos';

  @override
  String get landingWorldsBody => 'Nuevos lugares para mentes curiosas.';

  @override
  String get landingParentEyebrow => 'PARA QUIENES LES ACOMPAÑAN';

  @override
  String get landingParentTitle =>
      'Menos dudas.\nMás “mira cuánto has avanzado”.';

  @override
  String get landingParentIntro =>
      'Acompaña su aprendizaje sin vigilar cada respuesta. Los informes claros te ayudan a ver su próximo paso.';

  @override
  String get landingReportTitle => 'Progreso que puedes entender';

  @override
  String get landingReportBody =>
      'Consulta la precisión, la actividad y las habilidades que necesitan un poco más de atención.';

  @override
  String get landingProfilesTitle => 'Un espacio para cada peque';

  @override
  String get landingProfilesBody =>
      'Los perfiles separados conservan el progreso de cada explorador.';

  @override
  String get landingControlsTitle => 'Límites saludables integrados';

  @override
  String get landingControlsBody =>
      'Configura límites de tiempo y protege los ajustes con un control parental.';

  @override
  String get landingGalleryEyebrow => 'PARA SUS PEQUEÑAS MANOS';

  @override
  String get landingGalleryTitle => 'Descubre su próxima aventura.';

  @override
  String get landingGalleryPrevious => 'Capturas anteriores';

  @override
  String get landingGalleryNext => 'Siguientes capturas';

  @override
  String get landingScreenWelcome => 'Una cálida bienvenida';

  @override
  String get landingScreenProfile => 'Crea su héroe';

  @override
  String get landingScreenDaily => 'Pequeñas misiones diarias';

  @override
  String get landingScreenBlocks => 'Mira las matemáticas';

  @override
  String get landingScreenDuel => 'Comparte el reto';

  @override
  String get landingScreenTrophies => 'Celebra cada paso';

  @override
  String get landingScreenReport => 'Comprende su progreso';

  @override
  String get landingScreenSettings => 'Haz que sea su mundo';

  @override
  String get landingDownloadEyebrow => 'SU PRÓXIMO “¡LO LOGRÉ!” EMPIEZA AQUÍ';

  @override
  String get landingDownloadTitle =>
      'Pequeños pasos hoy.\nSuperpoderes matemáticos mañana.';

  @override
  String get landingDownloadBody =>
      'Dale a su curiosidad un lugar para jugar. Descarga MathQuest en App Store y comienza la próxima aventura de tu familia.';

  @override
  String get landingEmailFailure =>
      'No se pudo abrir tu correo. Escríbenos a me@christhoval.dev.';

  @override
  String get landingEmailSubject => 'Soporte de MathQuest';

  @override
  String get landingEmailBody => '¡Hola! Necesito ayuda con MathQuest.';

  @override
  String get landingFooterLine =>
      'Un poco de práctica. Un mundo de posibilidades.';

  @override
  String get landingFooterCredit => 'Creado con cariño para mentes curiosas.';

  @override
  String get landingBackToTop => 'Volver al inicio';

  @override
  String get landingCloseMenu => 'Cerrar navegación';

  @override
  String get landingOpenMenu => 'Abrir navegación';

  @override
  String get landingContactLabel => 'Contacto y soporte';

  @override
  String get landingDownloadAction => 'Descárgalo en App Store';

  @override
  String get landingDownloadNote => 'Disponible en App Store.';

  @override
  String get landingDownloadFailure =>
      'No se pudo abrir App Store. Inténtalo de nuevo.';
}
