import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/app/modules/online/model/room_model.dart';
import 'package:tic_tac_toe/main.dart';

class GameController extends GetxController {
  RxBool oTurn = true.obs;
  RxString winner = ''.obs;
  List<String> list = List.filled(9, '').obs;
  List<int> matchedIndex = <int>[].obs;
  RxString headingText = ''.obs;
  RxInt filledBox = 0.obs;
  RxBool isRefreshNeeded = false.obs;
  RxString id = ''.obs;
  Rxn<Game> game = Rxn<Game>();
  RxBool isOnline = false.obs;

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
  void onInit() {
    winner.value = '';
    super.onInit();
  }

  @override
  void onReady() {
    if (id.value != '') {
      isOnline.value = true;
      database.ref('rooms/$id/game').onValue.listen((event) {
        debugPrint(event.snapshot.value.toString());
        game.value = Game.fromJson(event.snapshot.value as Map);
        print(game.value.toString());
        game.value!.currentTurn == 'X'
            ? {oTurn.value = true, headingText.value = "X's Turn"}
            : {oTurn.value = false, headingText.value = "O's Turn"};
      });
    } else {
      headingText.value = oTurn.value ? "O's Turn" : "X's Turn";
    }
    super.onReady();
  }

  @override
  void onClose() {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    super.onClose();
  }

  void onTapped(int index) {
    if (id.value != '') {
      if (oTurn.value && game.value!.board[index] == '') {
        game.value!.board[index] = 'X';
        database.ref('rooms/$id/game').update({
          "currentTurn": 'O',
          'nextTurn': 'X',
          'board': game.value!.board,
        });
      } else if (!oTurn.value && game.value!.board[index] == '') {
        game.value!.board[index] = 'O';
        database.ref('rooms/$id/game').update({
          "currentTurn": 'X',
          'nextTurn': 'O',
          'board': game.value!.board,
        });
      }

      filledBox++;
    } else {
      // heading text
      headingText.value = !oTurn.value ? "O's Turn" : "X's Turn";

      if (winner.value == '' && filledBox.value != 9) {
        if (oTurn.value && list[index] == '') {
          list[index] = 'O';
        } else if (!oTurn.value && list[index] == '') {
          list[index] = 'X';
        }
        oTurn.value = !oTurn.value;
        filledBox++;
      }

      checkForWinner();

      if (filledBox.value == 9 && winner.value == '') {
        winner.value = 'Game Draw';
        isRefreshNeeded.value = true;
        headingText.value = "Game Draw";
        showReset();
      }
    }
  }

  void checkForWinner() {
    for (final combination in winningCombinations) {
      if (checkWinner(combination)) {
        winner.value = list[combination[0]];
        matchedIndex.assignAll(combination);
        isRefreshNeeded.value = true;
        headingText.value = "${winner.value} won";
        showReset();
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

  void resetGame() {
    if (!isOnline.value) {
      list.assignAll(List.filled(9, ''));
      oTurn.value = true;
      winner.value = '';
      matchedIndex.clear();
      headingText.value = "O's Turn";
      filledBox.value = 0;
      isRefreshNeeded.value = false;
    } else {
      database.ref('rooms/$id/game').update({
        "currentTurn": 'O',
        'nextTurn': 'X',
        'board': ['', '', '', '', '', '', '', '', ''],
        'gameOver': false,
        'draw': false,
        'winner': 'nill',
      });
    }
  }
}
