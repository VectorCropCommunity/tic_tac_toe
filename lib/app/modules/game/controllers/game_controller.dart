import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tic_tac_toe/assets.dart';

class GameController extends GetxController {
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
    headingText.value = oTurn.value ? "O's Turn" : "X's Turn";
    winner.value = '';
    await winnerAudioplayer.setAsset(AssetAudios.winner);
    await clickAudioPlayer.setAsset(AssetAudios.click);
    // player.setLoopMode(LoopMode.one);
    super.onInit();
  }

  @override
  void onClose() {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    confettiController.dispose();
    super.onClose();
  }

  Future<void> onTapped(int index) async {
    // heading text
    headingText.value = !oTurn.value ? "O's Turn" : "X's Turn";
    if (winner.value == '' && filledBox.value != 9) {
      if (oTurn.value && list[index] == '') {
        list[index] = 'O';
      } else if (!oTurn.value && list[index] == '') {
        list[index] = 'X';
      }
      // clickAudioPlayer.play();

      oTurn.value = !oTurn.value;
      filledBox++;
    }

    // clickAudioPlayer.stop();
    // clickAudioPlayer.setAsset(AssetAudios.click);

    checkForWinner();

    if (filledBox.value == 9 && winner.value == '') {
      winner.value = 'Game Draw';
      isRefreshNeeded.value = true;
      headingText.value = "Game Draw";
      // showReset();
    }
  }

  Future<void> checkForWinner() async {
    for (final combination in winningCombinations) {
      if (checkWinner(combination)) {
        winner.value = list[combination[0]];
        matchedIndex.assignAll(combination);
        isRefreshNeeded.value = true;
        headingText.value = "${winner.value} won";
        confettiController.play();
        winnerAudioplayer.play();
        await Future.delayed(const Duration
        (seconds: 2));
        confettiController.stop();
        break;
      }
    }
  }

  bool checkWinner(List<int> combination) {
    return list[combination[0]] == list[combination[1]] &&
        list[combination[0]] == list[combination[2]] &&
        list[combination[0]] != '';
  }

  void showReset() {
    Get.dialog(
      AlertDialog(
        title: Text(headingText.value),
        content: const Text("Want to play again?"),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.all(8.0),
        actions: [
          MaterialButton(
            minWidth: Get.width * 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.blue,
            onPressed: () {
              resetGame();
              Get.back();
            },
            child: const Text('Reset'),
          )
        ],
      ),
    );
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
}
