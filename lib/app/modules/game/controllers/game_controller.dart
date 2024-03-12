import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameController extends GetxController {
  RxBool oTurn = true.obs;
  List<String> list = ['', '', '', '', '', '', '', '', ''].obs;
  RxString winner = ''.obs;
  List matchedIndex = [].obs;
  RxString headingText = "".obs;
  RxInt filledBox = 0.obs;
  RxBool oRrefresh = false.obs;
  RxDouble angle = 0.0.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void onTapped(int index) {
    if (winner.value == '' && filledBox.value != 9) {
      if (oTurn.value == true && list[index] == '') {
        oTurn.value = false;
        list[index] = 'O';
        filledBox++;
      } else if (oTurn.value == false && list[index] == '') {
        list[index] = 'X';
        oTurn.value = true;
        filledBox++;
      }
    }

    checkWinner();

    if (filledBox.value == 9 && winner.value == '') {
      print("no Winner");
    }
  }

  void checkWinner() {
    if (list[0] == list[1] && list[0] == list[2] && list[0] != '') {
      winner.value = list[0];
      matchedIndex = [0, 1, 2];
      angle.value = 0;
    }
    if (list[3] == list[4] && list[3] == list[5] && list[3] != '') {
      winner.value = list[3];
      matchedIndex = [3, 4, 5];
      angle.value = 0;
    }
    if (list[6] == list[7] && list[6] == list[8] && list[6] != '') {
      winner.value = list[6];
      matchedIndex = [6, 7, 8];
      angle.value = 0;
    }
    if (list[0] == list[3] && list[0] == list[6] && list[0] != '') {
      winner.value = list[1];
      matchedIndex = [0, 3, 6];
      angle.value = 7.86;
    }
    if (list[1] == list[4] && list[1] == list[7] && list[1] != '') {
      winner.value = list[1];
      matchedIndex = [1, 4, 7];
      angle.value = 7.86;
    }
    if (list[2] == list[5] && list[2] == list[8] && list[2] != '') {
      winner.value = list[2];
      matchedIndex = [2, 5, 8];
      angle.value = 7.86;
    }
    if (list[0] == list[4] && list[0] == list[8] && list[0] != '') {
      winner.value = list[0];
      matchedIndex = [0, 4, 8];
      angle.value = 4;
    }
    if (list[6] == list[4] && list[6] == list[2] && list[6] != '') {
      winner.value = list[6];
      matchedIndex = [6, 4, 2];
      angle.value = -4;
    }
    checkToRefresh();
  }

  void checkToRefresh() {

    if (winner.value != '' || filledBox.value == 9) {
      oRrefresh.value = true;
      showReset();
    } else {
      oRrefresh.value = false;
    }
  }

  void showReset() {
    Future.delayed(const Duration(seconds: 0)).then((value) {
      Get.showSnackbar(GetSnackBar(
        padding: const EdgeInsets.all(20),
        title: "Game Over",
        message: "reset to play again",
        icon: const Icon(
          Icons.refresh,
          color: Colors.white,
          size: 30,
        ),
        mainButton: MaterialButton(
          onPressed: () {
            Get.back(canPop: true);
            resetGame();
          },
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.white)),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Reset"),
          ),
        ),
        overlayBlur: 2.0,
      ));
    });
  }

  void resetGame() {
    list.clear();
    var blank = <String>['', '', '', '', '', '', '', '', ''];
    list.addAll(blank);
    oTurn.value = true;
    winner.value = '';
    matchedIndex = [];
    headingText.value = "";
    filledBox.value = 0;
    oRrefresh.value = false;
  }
}
