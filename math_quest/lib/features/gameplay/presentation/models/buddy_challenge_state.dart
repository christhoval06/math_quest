import 'dart:collection';

import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';

enum BuddyChallengePhase { setup, playing, finished }

class BuddyChallengeSettings {
  static const allowedPointsToWin = [5, 6, 7, 8, 9, 10];

  final String player1Name;
  final String player2Name;
  final List<MathOperation> operations;
  final DifficultyLevel difficulty;
  final int pointsToWin;

  BuddyChallengeSettings({
    this.player1Name = 'Player 1',
    this.player2Name = 'Player 2',
    List<MathOperation> operations = const [MathOperation.addition],
    this.difficulty = DifficultyLevel.easy,
    this.pointsToWin = 5,
  }) : operations = UnmodifiableListView(List<MathOperation>.from(operations));

  bool get canStart =>
      player1Name.trim().isNotEmpty &&
      player2Name.trim().isNotEmpty &&
      operations.isNotEmpty &&
      allowedPointsToWin.contains(pointsToWin);

  BuddyChallengeSettings copyWith({
    String? player1Name,
    String? player2Name,
    List<MathOperation>? operations,
    DifficultyLevel? difficulty,
    int? pointsToWin,
  }) {
    return BuddyChallengeSettings(
      player1Name: player1Name ?? this.player1Name,
      player2Name: player2Name ?? this.player2Name,
      operations: operations ?? this.operations,
      difficulty: difficulty ?? this.difficulty,
      pointsToWin: pointsToWin ?? this.pointsToWin,
    );
  }
}

class BuddyProblemViewData {
  final String equation;
  final int correctAnswer;
  final List<int> options;
  final int revision;

  BuddyProblemViewData({
    required this.equation,
    required this.correctAnswer,
    required List<int> options,
    required this.revision,
  }) : options = UnmodifiableListView(List<int>.from(options));
}

class BuddyChallengeState {
  final BuddyChallengePhase phase;
  final BuddyChallengeSettings settings;
  final BuddyProblemViewData? problem;
  final int player1Score;
  final int player2Score;
  final int? winner;
  final Set<int> answeredPlayers;

  BuddyChallengeState({
    required this.phase,
    required this.settings,
    this.problem,
    this.player1Score = 0,
    this.player2Score = 0,
    this.winner,
    Set<int> answeredPlayers = const {},
  }) : answeredPlayers = UnmodifiableSetView(Set<int>.from(answeredPlayers));

  bool hasAnswered(int playerNumber) => answeredPlayers.contains(playerNumber);

  String get winnerName => winner == 1
      ? settings.player1Name
      : winner == 2
      ? settings.player2Name
      : '';
}
