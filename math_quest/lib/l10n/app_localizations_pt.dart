// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'MathQuest';

  @override
  String get tapToStart => 'Toque para Começar!';

  @override
  String playingAs(String name, String grade) {
    return 'Jogando como: $name ($grade)';
  }

  @override
  String dayStreak(int count) {
    return 'Sequência de $count Dias!';
  }

  @override
  String get todaysMission => 'MISSÃO DE HOJE';

  @override
  String get solveAddition => 'Resolva 10 Adições';

  @override
  String get continueMission => 'Continuar Missão';

  @override
  String get gameModes => 'Modos de Jogo';

  @override
  String get allUnlocked => 'Todos Desbloqueados';

  @override
  String get quickPlay => 'Jogo Rápido';

  @override
  String get practiceArena => 'Arena de Treino';

  @override
  String get adventureIsland => 'Ilha da Aventura';

  @override
  String get buddyChallenge => 'Desafio Amigo';

  @override
  String get practiceLab => 'LABORATÓRIO';

  @override
  String get customMission => 'Missão de Matemática Personalizada';

  @override
  String get chooseOperation => 'Escolha a Operação';

  @override
  String get chooseDifficulty => 'Dificuldade (Dígitos)';

  @override
  String get chooseTimer => 'Escolha o Tempo / Ritmo';

  @override
  String get funHelpers => 'Ajudas Divertidas';

  @override
  String get visualCountingAids => 'Blocos de Contagem Visual';

  @override
  String get soundEffectsCheering => 'Efeitos Sonoros e Torcida';

  @override
  String get launchMission => 'Iniciar Missão! (10 Perguntas)';

  @override
  String get pickYourAnswer => 'Escolha sua resposta:';

  @override
  String get skip => 'Pular';

  @override
  String get checkAnswer => 'Verificar Resposta!';

  @override
  String get correctTitle => 'Trabalho Incrível! 🌟';

  @override
  String get wrongTitle => 'Quase lá, tente de novo!';

  @override
  String get continueBtn => 'Continuar';

  @override
  String get questComplete => 'Missão Concluída!';

  @override
  String get roundStats => 'Estatísticas da Rodada';

  @override
  String get correctAnswers => 'Respostas Corretas';

  @override
  String get averageSpeed => 'Velocidade Média';

  @override
  String get playAnotherRound => 'Jogar Outra Rodada';

  @override
  String get reviewMistakes => 'Revisar Erros';

  @override
  String get backToHome => 'Voltar ao Início';

  @override
  String get trophyRoomTitle => 'Sala de Troféus e Estatísticas';

  @override
  String get weeklyPractice => 'Prática Semanal';

  @override
  String get mathMasteryTracks => 'Trilhas de Maestria';

  @override
  String get recentBadges => 'Emblemas Recentes';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get language => 'Idioma do Aplicativo';

  @override
  String get parentGateTitle => 'Área dos Pais';

  @override
  String parentGatePrompt(int num1, int num2) {
    return 'Peça a um adulto para resolver: Quanto é $num1 × $num2?';
  }

  @override
  String get navPlay => 'Jogar';

  @override
  String get navPractice => 'Praticar';

  @override
  String get navQuest => 'Aventura';

  @override
  String get navTrophies => 'Troféus';

  @override
  String get settingsLabel => 'CONFIGURAÇÕES DO APP';

  @override
  String get personalizeQuest => 'Personalize sua aventura!';

  @override
  String get settingsDescription =>
      'Ajuste os sons, troque de perfil e gerencie os controles dos pais.';

  @override
  String get soundsAndWorld => 'Sons e mundo de aventura';

  @override
  String get soundEffects => 'Efeitos sonoros (SFX)';

  @override
  String get gameMelodies => 'Melodias do jogo';

  @override
  String get voiceReadAloud => 'Leitura em voz alta';

  @override
  String get voiceReadAloudDescription =>
      'Lê os problemas em voz alta automaticamente';

  @override
  String get hapticTouch => 'Vibração ao tocar';

  @override
  String get hapticTouchDescription =>
      'Sinta uma vibração ao responder e ao acertar ou errar';

  @override
  String get selectLanguage => '🌐 Selecione o idioma';

  @override
  String get responseMode => 'Modo de resposta';

  @override
  String get responseModeDescription =>
      'Escolha como responder em todo o aplicativo.';

  @override
  String get responseChoice => 'Opções';

  @override
  String get responseWrite => 'Escrever';

  @override
  String get responseChoiceDescription => 'Escolha entre quatro respostas';

  @override
  String get responseWriteDescription => 'Digite a resposta';

  @override
  String responseModeSemantics(String mode) {
    return 'Modo de resposta: $mode';
  }

  @override
  String get gameVisualTheme => 'Tema visual do jogo';

  @override
  String get themeGalaxy => 'Aventura galáctica';

  @override
  String get themeGalaxyDescription => 'Espaço profundo';

  @override
  String get themeCandy => 'Terra dos doces';

  @override
  String get themeCandyDescription => 'Colinas doces';

  @override
  String get themeDino => 'Dino Matemática';

  @override
  String get themeDinoDescription => 'Pré-histórico';

  @override
  String get themeUnderwater => 'Fundo do mar';

  @override
  String get themeUnderwaterDescription => 'Recife de coral';

  @override
  String get whosPlaying => 'Quem vai jogar?';

  @override
  String profileSlotsUsed(int count) {
    return '$count de 3 perfis em uso';
  }

  @override
  String get profilesUnavailable => 'Perfis indisponíveis';

  @override
  String get addChildProfile => 'Adicionar perfil infantil';

  @override
  String get allProfileSlotsUsed => 'Os 3 perfis estão em uso';

  @override
  String profileLevel(int level) {
    return 'Nív. $level';
  }

  @override
  String get profileActive => 'Ativo';

  @override
  String get switchProfile => 'Trocar';

  @override
  String safeKidsEdition(String version) {
    return 'MathQuest v$version (Edição segura para crianças)';
  }

  @override
  String get localProgressBackup =>
      'Todo o progresso é salvo com segurança neste dispositivo.';

  @override
  String get parentZone => 'Área de controle dos pais';

  @override
  String get parentZoneDescription =>
      'Somente adultos: currículos, temporizadores e relatórios';

  @override
  String dailyScreenLimit(String name) {
    return 'Limite diário de tela ($name)';
  }

  @override
  String get unlimited => 'Sem limite';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get targetMathStandard => 'Nível de matemática desejado';

  @override
  String get gradePreK => 'Pré-escola';

  @override
  String get gradeOne => '1º ano';

  @override
  String get gradeTwo => '2º ano';

  @override
  String get gradeThreePlus => '3º ano ou mais';

  @override
  String get resetCurrentHero =>
      'Reiniciar o progresso de aventura do herói atual';

  @override
  String get resetProgressTitle => 'Reiniciar todo o progresso?';

  @override
  String get resetProgressDescription =>
      'Todas as etapas e mundos concluídos serão bloqueados e a Ilha da Aventura voltará à etapa 1. Deseja continuar?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get resetNow => 'Reiniciar agora';

  @override
  String get hero => 'Herói';

  @override
  String get profileSwitched => 'Perfil alterado! 🚀';

  @override
  String switchedToProfile(String name) {
    return 'Agora é a vez de $name! 🚀';
  }

  @override
  String screenLimitUpdated(String limit) {
    return 'Limite de tela atualizado para $limit!';
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
    return 'Nível de matemática definido como $standard!';
  }

  @override
  String get adventureProgressReset => '✅ A Ilha da Aventura voltou à etapa 1!';

  @override
  String get settingsUpdateFailed =>
      'Não foi possível atualizar as configurações. Tente novamente.';

  @override
  String explorerName(String name) {
    return 'Explorador $name';
  }

  @override
  String get readyForQuest => 'Pronto para sua aventura?';

  @override
  String get starryWaiting => 'Starry espera por você no Pico Cósmico!';

  @override
  String get streakLabel => 'SEQUÊNCIA';

  @override
  String get starsLabel => 'ESTRELAS';

  @override
  String get rankLabel => 'NÍVEL';

  @override
  String daysShort(int count) {
    return '${count}d';
  }

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String get quickPlayDuration => '2 min';

  @override
  String get customModeBadge => 'Personalizado';

  @override
  String get storyModeBadge => 'História';

  @override
  String get twoPlayersBadge => '2 jogadores';

  @override
  String get quickPlayDescription =>
      'Resolva as contas antes que o tempo acabe!';

  @override
  String get practiceDescription => 'Escolha operações, dígitos e ritmo.';

  @override
  String get adventureDescription =>
      'Vença monstros matemáticos e encontre tesouros.';

  @override
  String get buddyDescription => 'Jogue por turnos com amigos ou familiares.';

  @override
  String get playNowAction => 'Jogar agora →';

  @override
  String get configureAction => 'Configurar →';

  @override
  String get exploreAction => 'Explorar →';

  @override
  String get battleAction => 'Duelar →';

  @override
  String missionProgress(int current, int total) {
    return '$current de $total concluídos';
  }

  @override
  String dailyMissionReward(int coins, String badge) {
    return 'Recompensa: $coins moedas estrela e $badge';
  }

  @override
  String get missionCompletedToday => 'Missão de hoje concluída! 🎉';

  @override
  String claimMissionReward(int coins) {
    return 'Resgate $coins moedas e seu emblema! 🎁';
  }

  @override
  String missionRewardAdded(int coins, String badge) {
    return '🎁 Você recebeu $coins moedas estrela e $badge!';
  }

  @override
  String get superpowerTipHeading => 'SEGREDO MATEMÁTICO • Dica de hoje';

  @override
  String get tryNextChallenge => 'Experimente no próximo desafio! →';

  @override
  String get missionLabDescription =>
      'Escolha seu superpoder matemático e as regras do desafio!';

  @override
  String get practiceMode => '🎮 Modo prática';

  @override
  String get examChallenge => '📝 Desafio de prova';

  @override
  String get selectOperation => 'Selecione a operação';

  @override
  String get operationAddition => 'Adição';

  @override
  String get operationSubtraction => 'Subtração';

  @override
  String get operationMultiplication => 'Multiplicação';

  @override
  String get operationDivision => 'Divisão';

  @override
  String get appleCounters => 'Conte maçãs';

  @override
  String get balloonPops => 'Estoure balões';

  @override
  String get boosters => 'Propulsores';

  @override
  String get pizzaSlices => 'Fatias de pizza';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyMedium => 'Média';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get easyDigits => '1 dígito (3 + 5)';

  @override
  String get mediumDigits => '2 dígitos (24 + 38)';

  @override
  String get hardDigits => '3 dígitos (145 + 289)';

  @override
  String get easyDescription => 'Um aquecimento leve para iniciantes';

  @override
  String get mediumDescription => 'Um desafio escolar para exercitar a mente';

  @override
  String get hardDescription => 'Nível de super-herói da matemática!';

  @override
  String get noTimer => 'Sem tempo';

  @override
  String get relaxAndLearn => 'Relaxe e aprenda';

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
  String get rapidDash => 'Corrida rápida';

  @override
  String get standardPace => 'Ritmo normal';

  @override
  String get deepFocus => 'Concentração total';

  @override
  String get visualAidsDescription =>
      'Mostra blocos interativos e uma grade de pontos';

  @override
  String get soundCheeringDescription =>
      'Sons divertidos e sininhos da mascote';

  @override
  String get numberOfQuestions => 'Número de perguntas';

  @override
  String questionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perguntas',
      one: '1 pergunta',
    );
    return '$_temp0';
  }

  @override
  String get completionReward =>
      'Ao concluir: +50 estrelas e 1 chave de aventura';

  @override
  String get missionRewardXp => '100 EXP';

  @override
  String launchMissionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perguntas',
      one: '1 pergunta',
    );
    return 'Iniciar missão! ($_temp0)';
  }

  @override
  String startExamCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perguntas',
      one: '1 pergunta',
    );
    return 'Iniciar prova ($_temp0)';
  }

  @override
  String dailyAdditionTitle(int count) {
    return 'Resolva $count adições';
  }

  @override
  String dailySubtractionTitle(int count) {
    return 'Resolva $count subtrações';
  }

  @override
  String dailyMultiplicationTitle(int count) {
    return 'Resolva $count multiplicações';
  }

  @override
  String dailyDivisionTitle(int count) {
    return 'Resolva $count divisões';
  }

  @override
  String get spaceDetectiveBadge => 'Emblema de detetive espacial';

  @override
  String get balloonPopperBadge => 'Emblema de estourar balões';

  @override
  String get lightningBoosterBadge => 'Emblema de impulso relâmpago';

  @override
  String get pizzaMasterBadge => 'Emblema de mestre da pizza';

  @override
  String get tipDoublesTitle => 'O truque dos «dobros + 1»!';

  @override
  String get tipDoublesDescription =>
      'Se você sabe que 6 + 6 = 12, então 6 + 7 é fácil: basta somar mais 1 para chegar a 13!';

  @override
  String get tipMakeTenTitle => 'O segredo de «formar um 10»!';

  @override
  String get tipMakeTenDescription =>
      '8 + 5 parece difícil? Tire 2 do 5 para transformar o 8 em 10! Depois, 10 + 3 = 13!';

  @override
  String get tipSubtractTenTitle => 'O truque de «descer até 10»!';

  @override
  String get tipSubtractTenDescription =>
      'Quanto é 15 - 7? Primeiro tire 5 para chegar a 10, depois tire os 2 restantes para obter 8!';

  @override
  String get tipTimesFiveTitle => 'O truque de «multiplicar por 5»!';

  @override
  String get tipTimesFiveDescription =>
      '6 × 5? Acrescente um zero para obter 60 e depois pegue a metade: 30! Sempre funciona!';

  @override
  String get tipNinesTitle => 'A magia do 9!';

  @override
  String get tipNinesDescription =>
      'Os algarismos da tabuada do 9 somam 9! 9 × 3 = 27 (2+7=9). 9 × 4 = 36 (3+6=9)!';

  @override
  String get tipHalvingTitle => 'Divida por 4 tomando a metade duas vezes!';

  @override
  String get tipHalvingDescription =>
      'Para dividir por 4, pegue a metade do número e depois a metade de novo! 28 → 14 → 7!';

  @override
  String get tipZeroTitle => 'A regra do «herói zero»!';

  @override
  String get tipZeroDescription =>
      'Qualquer número somado a zero fica igual, mas qualquer número multiplicado por zero vira 0!';

  @override
  String get tapCorrectAnswer => 'Toque na resposta correta:';

  @override
  String get writeCorrectAnswer => 'Escreva a resposta correta:';

  @override
  String get matchSetup => 'Configurar partida';

  @override
  String get questionReview => 'Revisão das perguntas';

  @override
  String get nextStage => 'Próxima etapa 🚀';

  @override
  String get playAnotherRoundAction => 'Jogar outra rodada 🔄';

  @override
  String reviewMistakesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count erros',
      one: '1 erro',
    );
    return 'Revisar $_temp0 🎯';
  }

  @override
  String get backAdventureMap => 'Voltar ao mapa de aventura 🏝️';

  @override
  String get backHomeAction => 'Voltar ao início 🏠';

  @override
  String targetBoss(String name) {
    return 'Chefe alvo: $name';
  }

  @override
  String worldTitle(int index, String name) {
    return 'Mundo $index: $name';
  }

  @override
  String get switchIsland => 'Trocar de ilha';

  @override
  String get countingHelpers => 'Ajudas para contar';

  @override
  String get tensAndOnes => 'Dezenas e unidades';

  @override
  String numberDecomposition(int value, int tens, int ones) {
    return '$value ($tens dezenas, $ones unidades)';
  }

  @override
  String startBuddyChallenge(int points) {
    return 'Iniciar duelo! (Primeiro a chegar a $points pontos)';
  }

  @override
  String get buddyRulesDescription =>
      'Escolha os jogadores e as regras do duelo!';

  @override
  String get buddyArena => 'ARENA DOS AMIGOS';

  @override
  String get playerOne => 'Jogador 1';

  @override
  String get playerTwo => 'Jogador 2';

  @override
  String get playerNames => 'Nomes dos jogadores';

  @override
  String get pointsToWin => 'Pontos para vencer';

  @override
  String pointsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontos',
      one: '1 ponto',
    );
    return '$_temp0';
  }

  @override
  String get pointsTargetDescription => 'Vence quem atingir a meta primeiro';

  @override
  String buddyScore(int score1, int score2) {
    return 'J1: $score1  vs  J2: $score2';
  }

  @override
  String firstToPoints(int points) {
    return 'Primeiro a chegar a $points pontos';
  }

  @override
  String winnerName(String name) {
    return '$name venceu!';
  }

  @override
  String get outstandingReflexes => 'Excelentes reflexos matemáticos!';

  @override
  String get playAgain => 'Jogar novamente';

  @override
  String get changeSettings => 'Alterar configurações';

  @override
  String get exit => 'Sair';

  @override
  String get champion => 'CAMPEÃO';

  @override
  String finalScoreSemantics(int score1, int score2) {
    return 'Placar final: jogador 1, $score1; jogador 2, $score2';
  }

  @override
  String get finalScore => 'PLACAR FINAL';

  @override
  String correctAnswerExplanation(String answer) {
    return 'A resposta correta é $answer. Continue, explorador!';
  }

  @override
  String get sparkyAdvice => 'Sparky diz: Pense com calma e sem pressa!';

  @override
  String get worldBossDefeated => 'CHEFE DO MUNDO DERROTADO!';

  @override
  String welcomeToWorld(String name) {
    return 'Boas-vindas a $name!';
  }

  @override
  String get newIslandDescription =>
      'Uma nova ilha apareceu no mapa com desafios matemáticos e um chefe lendário!';

  @override
  String get exploreNewIsland => 'Explorar nova ilha! 🚀';

  @override
  String starCoinsReward(int count) {
    return '+$count moedas estrela';
  }

  @override
  String mathXpReward(int count) {
    return '+$count EXP de matemática';
  }

  @override
  String accuracyPercent(int percent) {
    return '$percent% de precisão';
  }

  @override
  String averageSecondsItem(double seconds) {
    final intl.NumberFormat secondsNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String secondsString = secondsNumberFormat.format(seconds);

    return '${secondsString}s / questão';
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
  String get stellaCoach => 'TREINADORA ESTELAR STELLA';

  @override
  String stellaExcellent(String name) {
    return '«Excelente, $name! Você arrasou nesta missão!»';
  }

  @override
  String get stellaEncouragement =>
      '«Belo esforço, explorador! Cada erro ajuda seu cérebro a crescer!»';

  @override
  String get tryAgainTitle => 'Tente novamente!';

  @override
  String get mistakeCorrected => '🎉 Incrível! Você corrigiu seu erro!';

  @override
  String get useCountingBlocks => 'Quase! Use os blocos para contar.';

  @override
  String get close => 'Fechar';

  @override
  String chosenAnswer(String answer) {
    return 'Você escolheu: $answer';
  }

  @override
  String get noAnswer => 'Nenhuma';

  @override
  String get retry => 'Tentar de novo';

  @override
  String get countingHint =>
      'Dica: Pense com calma e use os blocos de dezenas e unidades!';

  @override
  String get correctedSuccessfully => '🌟 Corrigido com sucesso!';

  @override
  String starsEarned(int count) {
    return '$count DE 3 ESTRELAS CONQUISTADAS';
  }

  @override
  String get newBadgeUnlocked => 'NOVO EMBLEMA DESBLOQUEADO!';

  @override
  String get correctAnswerSemantics => 'Resposta correta';

  @override
  String get incorrectAnswerSemantics => 'Resposta incorreta';

  @override
  String get writtenAnswerSemantics => 'Resposta escrita';

  @override
  String get retryAnswerSemantics => 'Tente verificar a resposta novamente';

  @override
  String get tryAgain => 'Tentar novamente';

  @override
  String get checkWrittenAnswer => 'Verificar resposta';

  @override
  String get tryAgainTooltip => 'Tentar novamente';

  @override
  String get checkAnswerTooltip => 'Verificar resposta';

  @override
  String get deleteDigit => 'Apagar dígito';

  @override
  String get checkingAnswer => 'Verificando a resposta';

  @override
  String get checkingStatus => 'Verificando…';

  @override
  String examStageLabel(int current, int total) {
    return 'DESAFIO DE PROVA ($current/$total)';
  }

  @override
  String operationAdventure(String operation) {
    return 'AVENTURA DE $operation';
  }

  @override
  String adventureNamePart(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'p0': 'de esmeralda',
      'p1': 'do sol',
      'p2': 'dos sussurros',
      'p3': 'do verde',
      'p4': 'de ouro',
      'p5': 'Atol',
      'p6': 'Ilha',
      'p7': 'Costas',
      'p8': 'Prado',
      'p9': 'Refúgio',
      'p10': 'de ameixa doce',
      'p11': 'de algodão-doce',
      'p12': 'de pirulitos',
      'p13': 'de caramelo',
      'p14': 'de doces',
      'p15': 'Cânion',
      'p16': 'Ilha',
      'p17': 'Recife',
      'p18': 'Lagoa',
      'p19': 'Reino',
      'p20': 'da pré-história',
      'p21': 'do trovão',
      'p22': 'do jurássico',
      'p23': 'de âmbar',
      'p24': 'da antiguidade',
      'p25': 'Selva',
      'p26': 'Penhasco',
      'p27': 'Terras selvagens',
      'p28': 'Santuário',
      'p29': 'dos astros',
      'p30': 'de estrelas cadentes',
      'p31': 'de luz estelar',
      'p32': 'da galáxia',
      'p33': 'do cosmos',
      'p34': 'Pico',
      'p35': 'Arquipélago',
      'p36': 'Picos',
      'p37': 'Nebulosa',
      'p38': 'Agulha',
      'p39': 'das profundezas',
      'p40': 'do azul',
      'p41': 'das marés',
      'p42': 'de safira',
      'p43': 'de água-marinha',
      'p44': 'Enseada',
      'p45': 'Ilhota',
      'p46': 'Abismo',
      'p47': 'Profundeza',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String adventureLandmark(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      's0': 'Praia de seixos',
      's1': 'Bosque de bambu',
      's2': 'Vale do trevo',
      's3': 'Crista da cachoeira',
      's4': 'Fortaleza do golem',
      's5': 'Costa de gomas',
      's6': 'Trilha de marshmallows',
      's7': 'Rio de chocolate',
      's8': 'Pico dos pirulitos',
      's9': 'Castelo doce do dragão',
      's10': 'Praia dos fósseis',
      's11': 'Dossel de samambaias',
      's12': 'Ravina do raptor',
      's13': 'Encostas do vulcão',
      's14': 'Sala do trono do T-Rex',
      's15': 'Bacia de poeira estelar',
      's16': 'Ponte de meteoros',
      's17': 'Crista da aurora',
      's18': 'Poço de gravidade',
      's19': 'Observatório do titã',
      's20': 'Enseada do peixe-palhaço',
      's21': 'Caverna de conchas',
      's22': 'Galeão afundado',
      's23': 'Fossa de pérolas',
      's24': 'Covil submerso do kraken',
      's25': 'Golem de pedra',
      's26': 'Dragão de açúcar',
      's27': 'Rei matemático T-Rex',
      's28': 'Titã estelar',
      's29': 'Lorde kraken',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String gameBadgeTitle(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'speed_counter': 'Contador veloz',
      'lightning_math': 'Matemática relâmpago',
      'quick_thinker': 'Pensador rápido',
      'clean_slate': 'Herói sem erros',
      'sharp_shooter': 'Pontaria perfeita',
      'flawless_focus': 'Foco impecável',
      'early_starter': 'Primeiro hábito',
      'week_warrior': 'Guerreiro semanal',
      'fortnight_legend': 'Titã da quinzena',
      'half_century': 'Os primeiros cinquenta',
      'century_club': 'Clube dos cem',
      'grand_master_500': 'Maratonista da matemática',
      'millennium_scholar': 'Sábio do milênio',
      'addition_superhero': 'Herói da adição',
      'minus_ninja': 'Ninja da subtração',
      'times_master': 'Mestre da multiplicação',
      'division_champ': 'Campeão da partilha',
      'boss_slayer': 'Conquistador de ilhas',
      'space_detective': 'Detetive espacial',
      'quad_master': 'Grande polímata',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String gameBadgeDescription(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'speed_counter':
          'Responda 5 perguntas em menos de 5 segundos cada em uma rodada.',
      'lightning_math': 'Responda 10 perguntas corretamente em menos de 30 segundos no total.',
      'quick_thinker': 'Resolva seu primeiro problema em menos de 3 segundos.',
      'clean_slate':
          'Alcance 100% de precisão em uma rodada com pelo menos 10 perguntas.',
      'sharp_shooter': 'Acerte 5 respostas seguidas sem erros.',
      'flawless_focus': 'Conclua uma rodada de 15 ou mais perguntas com pelo menos 90% de precisão.',
      'early_starter': 'Mantenha uma sequência de aprendizado de 3 dias.',
      'week_warrior': 'Mantenha uma sequência de aprendizado de 7 dias.',
      'fortnight_legend': 'Alcance uma sequência de prática de 14 dias.',
      'half_century': 'Resolva 50 problemas no total entre todas as operações.',
      'century_club':
          'Resolva 100 problemas no total entre todas as operações.',
      'grand_master_500': 'Alcance 500 perguntas respondidas.',
      'millennium_scholar': 'Resolva um total de 1.000 perguntas!',
      'addition_superhero':
          'Resolva 100 adições com pelo menos 90% de precisão.',
      'minus_ninja': 'Resolva 100 subtrações com pelo menos 85% de precisão.',
      'times_master':
          'Alcance o nível 4 na trilha de domínio da multiplicação.',
      'division_champ': 'Resolva 75 desafios de divisão sem resto.',
      'boss_slayer': 'Derrote um chefe do mundo na Ilha da Aventura.',
      'space_detective': 'Conclua a missão diária de hoje.',
      'quad_master': 'Alcance pelo menos o nível 3 nas 4 operações.',
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
  String get welcomeTagline => 'Aprenda, jogue e conte!';

  @override
  String get profileSwitchFailed =>
      'Não foi possível trocar de perfil. Tente novamente.';

  @override
  String get addChildProfileTitle => 'Adicionar perfil infantil';

  @override
  String get createHero => 'Crie seu herói!';

  @override
  String get createHeroDescription =>
      'Escolha seu avatar e diga seu nome para começar.';

  @override
  String get chooseAvatar => 'Escolha seu avatar';

  @override
  String get explorerNamePrompt => 'Qual é o seu nome, explorador?';

  @override
  String get enterName => 'Digite seu nome';

  @override
  String get selectGrade => 'Escolha seu ano escolar';

  @override
  String get creatingProfile => 'Criando perfil…';

  @override
  String get startMyAdventure => 'Começar minha aventura! 🚀';

  @override
  String profileCreated(String name) {
    return '🎉 Boas-vindas, $name! Seu perfil foi criado e ativado.';
  }

  @override
  String get profileCreationFailed =>
      'Não foi possível criar o perfil. Tente novamente.';

  @override
  String get profileSwitcherDescription =>
      'Escolha seu perfil para continuar a aventura!';

  @override
  String get chargingBoosters => 'Carregando propulsores matemáticos...';

  @override
  String get warmingSuperpowers => 'Preparando superpoderes...';

  @override
  String get readyForAdventure => 'Pronto para a aventura! 🚀';

  @override
  String welcomeGreeting(String name) {
    return 'Olá, $name!';
  }

  @override
  String get starMath => 'MATEMÁTICA ESTELAR';

  @override
  String get onboardingWelcomeTitle => 'Boas-vindas ao MathQuest!';

  @override
  String get onboardingWelcomeDescription =>
      'Transforme a matemática em uma aventura cósmica em que aprender é tão divertido quanto brincar.';

  @override
  String get onboardingBlocksTitle => 'Blocos visuais para contar';

  @override
  String get onboardingBlocksDescription =>
      'Dê vida aos números com blocos de base 10! Conte dezenas e unidades para aprender a somar com reagrupamento.';

  @override
  String get onboardingAdventureTitle => 'Derrote chefes e ganhe troféus';

  @override
  String get onboardingAdventureDescription =>
      'Explore a Ilha da Aventura, desbloqueie mundos, colecione emblemas e dispute duelos de dois jogadores!';

  @override
  String get getStarted => 'Começar 🚀';

  @override
  String get next => 'Próximo';

  @override
  String get gradeKindergarten => 'Pré-escola';

  @override
  String gradeAgeRange(int min, int max) {
    return 'Idade $min-$max';
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
  String get switchProfileAction => 'Trocar perfil';

  @override
  String get allBadgesTitle => 'Todos os emblemas e troféus';

  @override
  String get badgeUnlockedCaps => '✅ DESBLOQUEADO';

  @override
  String get badgeLockedCaps => '🔒 BLOQUEADO';

  @override
  String get badgeUnlocked => '✅ Desbloqueado';

  @override
  String get badgeLocked => '🔒 Bloqueado';

  @override
  String get gotIt => 'Entendi!';

  @override
  String get awesome => 'Incrível!';

  @override
  String viewAllCount(int count) {
    return 'Ver todos ($count)';
  }

  @override
  String operationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count operações',
      one: '1 operação',
    );
    return '$_temp0';
  }

  @override
  String get parentDiagnosticTitle => 'Relatório de diagnóstico para os pais';

  @override
  String get superMathematician => 'SUPER MATEMÁTICO!';

  @override
  String get keepShining =>
      'Continue brilhando! Você está alcançando suas metas diárias.';

  @override
  String get totalSolvedLabel => 'TOTAL RESOLVIDO';

  @override
  String get accuracyLabel => 'PRECISÃO';

  @override
  String get unstoppable => 'Imparável! 🔥';

  @override
  String get trophiesLabel => 'TROFÉUS';

  @override
  String badgesRemaining(int count) {
    return 'Faltam $count para desbloquear';
  }

  @override
  String dailyProblemGoal(int count) {
    return 'Meta diária: $count problemas';
  }

  @override
  String get weeklyGoalMet => '🎯 Meta atingida!';

  @override
  String get weeklyKeepGoing => 'Continue praticando!';

  @override
  String get noWeeklyData => 'Ainda sem prática';

  @override
  String get noCategoryBadges => 'Ainda não há emblemas nesta categoria.';

  @override
  String get noMasteryData => 'Comece a praticar para ver seu progresso.';

  @override
  String shortAccuracy(int percent) {
    return '$percent% acertos';
  }

  @override
  String masteryRank(String icon, String title, int level) {
    return '$icon $title (Nível $level)';
  }

  @override
  String masteryProgress(int solved, int remaining, int level) {
    return '$solved resolvidos • faltam $remaining para o nível $level';
  }

  @override
  String masteryMaxProgress(int solved) {
    return '$solved resolvidos • Nível máximo! 👑';
  }

  @override
  String get curriculumBreakdown => 'Detalhamento das operações do currículo';

  @override
  String get activeStudent => 'Estudante ativo';

  @override
  String gradeAligned(String grade) {
    return '$grade • Alinhado ao Common Core';
  }

  @override
  String reportDate(String date) {
    return 'Data do relatório: $date';
  }

  @override
  String get readinessIndex => 'ÍNDICE DE PREPARAÇÃO ESCOLAR';

  @override
  String get noOperationData => 'Ainda não há dados de operações.';

  @override
  String get stellaObservations =>
      'Observações da professora e treinadora Stella';

  @override
  String get identifiedStrength => 'Ponto forte identificado:';

  @override
  String get recommendedFocus => 'Foco recomendado:';

  @override
  String get baselineGathering => 'Coletando dados iniciais';

  @override
  String masteryPercent(int percent) {
    return '$percent% de domínio';
  }

  @override
  String readinessStrong(String name) {
    return '$name demonstra uma base numérica sólida e avança para níveis mais complexos.';
  }

  @override
  String readinessStarting(String name) {
    return '$name está desenvolvendo habilidades básicas. Recomendam-se sessões diárias de 10 minutos.';
  }

  @override
  String get noRoundsCompleted => 'Nenhuma rodada concluída';

  @override
  String questionsAnswered(int count) {
    return '$count perguntas respondidas';
  }

  @override
  String get diagnosticPending => 'Avaliação pendente';

  @override
  String get diagnosticNeedsPractice => 'Precisa praticar 🎯';

  @override
  String get diagnosticOnTrack => 'No caminho certo ⚡';

  @override
  String get diagnosticMastered => 'Dominado ✅';

  @override
  String get closeParentVerification => 'Fechar verificação dos pais';

  @override
  String get adultVerificationCaps => 'VERIFICAÇÃO DE ADULTO';

  @override
  String get adultVerification => 'Verificação de adulto';

  @override
  String get parentControlsProtected =>
      'Esta verificação ajuda a proteger os controles dos adultos.';

  @override
  String get parentAnswerSemantics => 'Resposta de verificação dos pais';

  @override
  String get answer => 'Resposta';

  @override
  String get gateAnswerRequired => 'Digite uma resposta para continuar.';

  @override
  String get gateNumbersOnly => 'Use apenas números.';

  @override
  String get gateAnswerIncorrect => 'Não está correto. Tente novamente.';

  @override
  String parentVerificationPrompt(String first, String second) {
    return 'Quanto é $first × $second?';
  }

  @override
  String get timeForRest => 'Hora de descansar!';

  @override
  String get restDescription =>
      'Bom trabalho na aventura de hoje! Starry está tirando uma soneca. Peça ajuda a um adulto se quiser jogar mais.';

  @override
  String get parentUnlock => 'Desbloqueio dos pais 🛡️';

  @override
  String get gateSettingsTitle => 'Configurações dos pais';

  @override
  String get gateSettingsDescription =>
      'Confirme que você é um adulto antes de abrir as configurações protegidas.';

  @override
  String get unlockSettings => 'Desbloquear configurações';

  @override
  String get gateScreenLimitTitle => 'Alterar limite de tela';

  @override
  String get gateScreenLimitDescription =>
      'Confirme que você é um adulto antes de alterar o tempo diário de jogo.';

  @override
  String get gateLearningTitle => 'Alterar meta de aprendizado';

  @override
  String get gateLearningDescription =>
      'Confirme que você é um adulto antes de alterar o nível de matemática desejado.';

  @override
  String get gateResetTitle => 'Reiniciar progresso de aventura';

  @override
  String get gateResetDescription =>
      'Esta ação é protegida. Confirme que você é um adulto para continuar.';

  @override
  String get gateExtraTimeTitle => 'Adicionar tempo de jogo';

  @override
  String get gateExtraTimeDescription =>
      'Confirme que você é um adulto antes de adicionar mais 15 minutos.';

  @override
  String get addFifteenMinutes => 'Adicionar 15 minutos';

  @override
  String badgeCategory(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'ALL': 'TODOS',
      'SPEED': 'VELOCIDADE',
      'ACCURACY': 'PRECISÃO',
      'STREAK': 'SEQUÊNCIA',
      'MILESTONE': 'CONQUISTAS',
      'MASTERY': 'DOMÍNIO',
      'ADVENTURE': 'AVENTURA',
      'DAILY': 'DIÁRIOS',
      'LEGENDARY': 'LENDÁRIOS',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String badgeTier(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'bronze': 'BRONZE',
      'silver': 'PRATA',
      'gold': 'OURO',
      'diamond': 'DIAMANTE',
      'other': '$key',
    });
    return '$_temp0';
  }

  @override
  String masteryTierTitle(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'l1': 'Explorador iniciante',
      'l2': 'Cadete dos números',
      'l3': 'Aventureiro da matemática',
      'l4': 'Estrela em ascensão',
      'l5': 'Mago dos números',
      'l6': 'Super-herói da matemática',
      'l7': 'Campeão cósmico',
      'l8': 'Mente brilhante',
      'l9': 'Grande titã',
      'l10': 'Lenda suprema da matemática!',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String gateNumberWord(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'n0': 'zero',
      'n1': 'um',
      'n2': 'dois',
      'n3': 'três',
      'n4': 'quatro',
      'n5': 'cinco',
      'n6': 'seis',
      'n7': 'sete',
      'n8': 'oito',
      'n9': 'nove',
      'n10': 'dez',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String weekdayShort(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'd0': 'Seg',
      'd1': 'Ter',
      'd2': 'Qua',
      'd3': 'Qui',
      'd4': 'Sex',
      'd5': 'Sáb',
      'd6': 'Dom',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String solvedToday(int count) {
    return '+$count hoje';
  }

  @override
  String get practiceAccuracy => 'Nas operações praticadas';

  @override
  String get explorerLabel => 'Explorador';

  @override
  String get observationNeedsPractice =>
      'Complete uma sessão de prática para descobrir seus pontos fortes.';

  @override
  String get observationBuilding =>
      'As habilidades ainda estão se desenvolvendo. Continue praticando para melhorar a precisão.';

  @override
  String observationStrength(String operation, int percent, int count) {
    return '$operation: $percent% de precisão em $count perguntas respondidas.';
  }

  @override
  String get observationStart =>
      'Experimente uma sessão curta de prática para começar a avaliação.';

  @override
  String get observationMaintain =>
      'Continue praticando todas as operações para manter a precisão.';

  @override
  String observationTry(String operation) {
    return 'Experimente $operation para reunir dados de avaliação.';
  }

  @override
  String observationFocus(String operation, int percent) {
    return 'Pratique $operation, atualmente com $percent% de precisão.';
  }

  @override
  String get appTagline => 'Um pouco de prática. Uma grande aventura.';

  @override
  String get aboutSectionTitle => 'SOBRE';

  @override
  String get aboutAppTitle => 'Sobre o MathQuest';

  @override
  String get aboutAppSubtitle => 'Uma pequena ideia, inspirada por Dion';

  @override
  String get aboutAppStory =>
      'Criei o MathQuest para ajudar meu filho Dion a estudar matemática. Como nem sempre temos lápis e papel à mão, queria uma forma simples de transformar qualquer tempinho livre em uma oportunidade de aprender juntos.';

  @override
  String get aboutPracticeTitle => 'Pratique em qualquer lugar';

  @override
  String get aboutPracticeBody =>
      'Alguns minutos de matemática, onde quer que o dia leve você.';

  @override
  String get aboutPaceTitle => 'No próprio ritmo';

  @override
  String get aboutPaceBody =>
      'Diferentes séries e atividades para acompanhar cada pequeno explorador.';

  @override
  String get aboutFamilyTitle => 'Para aprender em família';

  @override
  String get aboutFamilyBody =>
      'Um projeto que nasceu em casa para fazer da matemática parte do dia a dia.';

  @override
  String get aboutDeveloperTitle => 'Sobre o desenvolvedor';

  @override
  String get aboutDeveloperSubtitle => 'A pessoa por trás do MathQuest';

  @override
  String get aboutDeveloperBio =>
      'Olá, sou @christhoval, engenheiro fullstack e Tech Lead Front-End no Panamá. Trabalho com JavaScript e Python e crio ferramentas CLI, pacotes npm e aplicativos móveis. Meu foco é criar produtos úteis, cuidar da experiência de uso e da privacidade desde o início. O MathQuest nasceu de um desejo simples: ajudar Dion a gostar de aprender matemática.';

  @override
  String get developerRoleTitle => 'Cargo atual';

  @override
  String get developerRoleBody => 'Engenheiro fullstack e Tech Lead Front-End.';

  @override
  String get developerStackTitle => 'Principais tecnologias';

  @override
  String get developerStackBody =>
      'JavaScript, TypeScript, Python, Flutter, CLI e npm.';

  @override
  String get developerFocusTitle => 'Foco';

  @override
  String get developerFocusBody =>
      'Produto, experiência do usuário e privacidade desde o início.';

  @override
  String get contactSupportTitle => 'Contato / Suporte';

  @override
  String get contactSupportSubtitle =>
      'Relate um erro ou compartilhe uma ideia';

  @override
  String get supportEmailSubject => 'MathQuest — Suporte';

  @override
  String get supportEmailBody =>
      'Olá, Christhoval,\n\nEstou entrando em contato sobre o MathQuest:\n\n';

  @override
  String get supportEmailUnavailable =>
      'Nenhum aplicativo de e-mail está disponível. Você pode me escrever no endereço abaixo.';

  @override
  String get copyEmail => 'Copiar endereço de e-mail';

  @override
  String get emailCopied => 'Endereço de e-mail copiado';
}
