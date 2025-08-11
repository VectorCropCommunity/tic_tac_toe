import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shake/shake.dart';
import 'package:tic_tac_toe/app/modules/home/controllers/home_controller.dart';
import 'package:tic_tac_toe/assets.dart';

class GameController extends GetxController {
  late ShakeDetector shakeDetector;
  final winnerAudioplayer = AudioPlayer();
  final clickAudioPlayer = AudioPlayer();
  ConfettiController confettiController = ConfettiController();
  RxBool oTurn = true.obs;
  RxString winner = ''.obs;
  List<String> list = List.filled(9, '').obs;
  List<int> matchedIndex = <int>[].obs;
  RxString headingText = ''.obs;
  RxInt filledBox = 0.obs;
  RxBool isRefreshNeeded = false.obs;
  final RxInt tappedIndex = (-1).obs;
  final RxBool isLoading = true.obs;
  final RxBool isVsAI = false.obs;
  final RxString difficulty = 'easy'.obs; // Default
  // Score tracking
  final RxInt xScore = 0.obs;
  final RxInt oScore = 0.obs;
  final RxInt drawScore = 0.obs;

  // Player names
  final RxString playerXName = 'Player X'.obs; // X marker owner
  final RxString playerOName = 'Player O'.obs; // O marker owner
  bool _namesAsked = false;

  // Symbols (currently human = O starts first, AI = X second)
  final String humanSymbol = 'O';
  final String aiSymbol = 'X';

  bool hasGameStarted() => list.any((e) => e != '');

  final List<List<int>> winningCombinations = [
    [0, 1, 2], // Rows
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6], // Columns
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8], // Diagonals
    [6, 4, 2],
  ];

  @override
  Future<void> onInit() async {
    // Start loading state
    isLoading.value = true;
    try {
      // Safely read arguments (may be null)
      final args = Get.arguments as Map<String, dynamic>?;
      isVsAI.value = (args?['vsAI'] as bool?) ?? false;

      headingText.value = "O's Turn";
      winner.value = '';
      isLoading.value = false; // Hide loader after assets are ready

      // Set default AI name if needed
      if (isVsAI.value) {
        playerXName.value = 'AI';
      }

      // Ask for player name(s) after first frame
      Future.delayed(Duration.zero, () => askForNamesIfNeeded());

      // Preload audio assets; if this fails we still proceed to show UI
      // await Future.wait([
      //   winnerAudioplayer.setAsset(AssetAudios.winner),
      //   clickAudioPlayer.setAsset(AssetAudios.click),
      // ]);

      shakeDetector = ShakeDetector.autoStart(
        onPhoneShake: (event) {
          if (isRefreshNeeded.value) {
            resetGame();
            if (Get.isDialogOpen!) Get.back();
          }
        },
      );
    } catch (e, st) {
      // Log & degrade gracefully (keep game playable even if audio fails)
      debugPrint('GameController onInit error: $e\n$st');
      Get.snackbar(
        'Init Error',
        'Some assets failed to load. Continuing without audio.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false; // Always hide loader
      super.onInit();
    }
  }

  @override
  void onClose() {
    shakeDetector.stopListening();
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    confettiController.dispose();
    super.onClose();
  }

  void changeAiDiffuclty(String value) {
    difficulty.value = value;
  }

  Future<void> onTapped(int index) async {
    if (winner.value != '' || list[index] != '') return;

    tappedIndex.value = index;
    if (isAudioOn.value) {
      clickAudioPlayer
        ..seek(Duration.zero)
        ..play();
    }

    if (oTurn.value) {
      list[index] = 'O';
    } else {
      list[index] = 'X';
    }

    oTurn.value = !oTurn.value;
    filledBox++;
    headingText.value = oTurn.value ? "O's Turn" : "X's Turn";

    await checkForWinner();

    if (filledBox.value == 9 && winner.value == '') {
      winner.value = 'Game Draw';
      headingText.value = "Game Draw";
      isRefreshNeeded.value = true;
      drawScore.value++;
      Future.delayed(const Duration(milliseconds: 500), showReset);
    }

    /// 👇 Call AI move if it's AI's turn and game not over
    if (isVsAI.value && !oTurn.value && winner.value == '') {
      Future.delayed(const Duration(milliseconds: 500), () {
        makeAIMove();
      });
    }
  }

  Future<void> checkForWinner() async {
    for (final combination in winningCombinations) {
      if (checkWinner(combination) && !isRefreshNeeded.value) {
        winner.value = list[combination[0]];
        matchedIndex.assignAll(combination);
        isRefreshNeeded.value = true;
        headingText.value = "${winner.value} won";

        // Update scores
        if (winner.value == 'X') {
          xScore.value++;
        } else if (winner.value == 'O') {
          oScore.value++;
        }

        confettiController.play();
        if (isAudioOn.value) {
          winnerAudioplayer.play();
        }

        await Future.delayed(const Duration(seconds: 2));
        confettiController.stop();
        showReset();
      }
    }
  }

  bool checkWinner(List<int> combination) {
    return list[combination[0]] == list[combination[1]] &&
        list[combination[0]] == list[combination[2]] &&
        list[combination[0]] != '';
  }

  void showReset() {
    // ✅ 1. Avoid duplicate dialogs and reset logic
    if (isRefreshNeeded.value && !Get.isDialogOpen!) {
      final scheme = Get.theme.colorScheme;
      final isDraw = winner.value.toLowerCase().contains("draw");
      final titleIcon = isDraw ? "🤝" : (winner.value == "X" ? "❌" : "⭕");

      // ✅ 2. Show nice dialog
      Get.dialog(
        PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: scheme.surface,
            titlePadding: const EdgeInsets.only(top: 24),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            actionsPadding: const EdgeInsets.only(bottom: 16),
            title: Column(
              children: [
                Text(titleIcon, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text(
                  headingText.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
            content: Text(
              isDraw
                  ? "That was close! Wanna play another round?"
                  : "${winner.value} wins this round! Want to play again?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: scheme.onSurfaceVariant),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton.icon(
                icon: const Icon(Icons.replay),
                label: const Text("Play Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  resetGame();
                  Get.back(); // ✅ Close dialog safely
                },
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    } else if (isRefreshNeeded.value && Get.isDialogOpen!) {
      // ✅ 3. If already showing dialog, just reset game and show snackbar
      resetGame();
      Get.back(); // close dialog if it's open
      Get.snackbar(
        "Game Reset",
        "Shake detected – New round started!",
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
    }
  }

  Future<void> resetGame() async {
    winnerAudioplayer.stop();
    winnerAudioplayer.setAsset(AssetAudios.winner);
    list.assignAll(List.filled(9, ''));
    oTurn.value = true;
    winner.value = '';
    matchedIndex.clear();
    headingText.value = "O's Turn";
    filledBox.value = 0;
    isRefreshNeeded.value = false;
  }

  /// Completely reset including scores
  void resetAll() {
    xScore.value = 0;
    oScore.value = 0;
    drawScore.value = 0;
    resetGame();
  }

  void askForNamesIfNeeded() {
    if (_namesAsked) return;
    _namesAsked = true;
    // If user already customized (e.g. coming back) skip
    if (isVsAI.value) {
      if (playerOName.value != 'Player O') return; // already set
      _showNameDialog(singlePlayer: true);
    } else {
      if (playerOName.value != 'Player O' || playerXName.value != 'Player X')
        return;
      _showNameDialog(singlePlayer: false);
    }
  }

  void _showNameDialog({required bool singlePlayer}) {
    final scheme = Get.theme.colorScheme;
    final oController = TextEditingController();
    final xController = TextEditingController();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: scheme.surface,
        title: Text(
          singlePlayer ? 'Enter your name' : 'Enter player names',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: scheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oController,
              autofocus: true,
              textInputAction:
                  singlePlayer ? TextInputAction.done : TextInputAction.next,
              decoration: InputDecoration(
                labelText: singlePlayer ? 'Your name (O)' : 'Player O name',
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) {
                if (singlePlayer) _submitNames(oController.text, null);
              },
            ),
            if (!singlePlayer) const SizedBox(height: 12),
            if (!singlePlayer)
              TextField(
                controller: xController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Player X name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted:
                    (_) => _submitNames(oController.text, xController.text),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Keep defaults
              Get.back();
            },
            child: const Text('Skip'),
          ),
          ElevatedButton(
            onPressed:
                () => _submitNames(
                  oController.text,
                  singlePlayer ? null : xController.text,
                ),
            child: const Text('Start'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _submitNames(String oName, String? xName) {
    if (oName.trim().isNotEmpty) playerOName.value = oName.trim();
    if (isVsAI.value) {
      // X is AI already named
    } else {
      if (xName != null && xName.trim().isNotEmpty)
        playerXName.value = xName.trim();
    }
    if (Get.isDialogOpen!) Get.back();
  }

  void makeAIMove() {
    // AI logic to make a move

    // final emptyIndices = <int>[];
    // for (int i = 0; i < list.length; i++) {
    //   if (list[i] == '') emptyIndices.add(i);
    // }

    // if (emptyIndices.isNotEmpty) {
    //   final randomIndex = emptyIndices[Random().nextInt(emptyIndices.length)];
    //   onTapped(randomIndex); // recursive call (but safe)
    // }

    // AI logic to make a move
    switch (difficulty.value) {
      case 'easy':
        makeRandomMove();
        break;
      case 'medium':
        makeMediumMove();
        break;
      case 'hard':
        makeHardMove();
        break;
      default:
        makeRandomMove();
    }
  }

  void makeRandomMove() {
    final emptyIndices = <int>[];
    for (int i = 0; i < list.length; i++) {
      if (list[i] == '') emptyIndices.add(i);
    }

    if (emptyIndices.isNotEmpty) {
      final index = emptyIndices[Random().nextInt(emptyIndices.length)];
      onTapped(index);
    }
  }

  void makeMediumMove() {
    int? move;

    // 1. Try to win
    move = _findBestMove(forPlayer: aiSymbol);
    if (move != null) {
      onTapped(move);
      return;
    }

    // 2. Block opponent
    move = _findBestMove(forPlayer: humanSymbol);
    if (move != null) {
      onTapped(move);
      return;
    }

    // 3. Take center if free
    if (list[4] == '') {
      onTapped(4);
      return;
    }

    // 4. Take any corner if free
    for (var i in [0, 2, 6, 8]) {
      if (list[i] == '') {
        onTapped(i);
        return;
      }
    }

    // 5. Random fallback
    makeRandomMove();
  }

  int? _findBestMove({required String forPlayer}) {
    for (final combo in winningCombinations) {
      final a = combo[0], b = combo[1], c = combo[2];
      final values = [list[a], list[b], list[c]];

      if (values.where((v) => v == forPlayer).length == 2 &&
          values.contains('')) {
        return combo[values.indexOf('')];
      }
    }
    return null;
  }

  void makeHardMove() {
    int bestScore = -1000;
    int move = -1;

    for (int i = 0; i < list.length; i++) {
      if (list[i] == '') {
        list[i] = aiSymbol; // simulate AI move
        int score = _minimax(0, false);
        list[i] = '';
        if (score > bestScore) {
          bestScore = score;
          move = i;
        }
      }
    }

    if (move != -1) {
      onTapped(move);
    } else {
      makeRandomMove(); // should never reach here
    }
  }

  int _minimax(int depth, bool isMaximizing) {
    final score = _evaluate();
    if (score != 0) return score - depth; // Prefer fast win / slow loss
    if (filledBox.value + depth == 9) return 0; // Draw

    if (isMaximizing) {
      int best = -1000;
      for (int i = 0; i < list.length; i++) {
        if (list[i] == '') {
          list[i] = aiSymbol;
          best = max(best, _minimax(depth + 1, false));
          list[i] = '';
        }
      }
      return best;
    } else {
      int best = 1000;
      for (int i = 0; i < list.length; i++) {
        if (list[i] == '') {
          list[i] = humanSymbol;
          best = min(best, _minimax(depth + 1, true));
          list[i] = '';
        }
      }
      return best;
    }
  }

  int _evaluate() {
    for (final combo in winningCombinations) {
      final a = combo[0], b = combo[1], c = combo[2];
      if (list[a] == list[b] && list[b] == list[c] && list[a] != '') {
        if (list[a] == aiSymbol) return 10;
        if (list[a] == humanSymbol) return -10;
      }
    }
    return 0;
  }
}
