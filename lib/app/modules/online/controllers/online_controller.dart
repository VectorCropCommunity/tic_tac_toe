import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/app/modules/online/model/room_model.dart';
import 'package:tic_tac_toe/app/routes/app_pages.dart';
import 'package:tic_tac_toe/main.dart';

class OnlineController extends GetxController {
  Rxn<UserCredential> userCred = Rxn<UserCredential>();
  RxList<Room> rooms = <Room>[].obs;

  @override
  void onInit() {
    listenDB();
    super.onInit();
  }

  void listenDB() {
    database.ref('rooms').onChildAdded.listen((event) {
      debugPrint(event.snapshot.value.toString());
      rooms.add(Room.fromJson(event.snapshot.value as Map));
    });
    database.ref('rooms').onChildChanged.listen((event) {
      for (var element in event.snapshot.children) {
        if (rooms.any((room) => room.id == element.key)) {
          rooms.removeWhere((room) => room.id == element.key);
        }
      }
    });
    database.ref('rooms').onChildRemoved.listen((event) {
      rooms.removeWhere((room) => room.id == event.snapshot.key);
    });
  }

  void createRoom() {
    print("creating room");
    Get.showOverlay(
      asyncFunction: () async {
        String id = FirebaseAuth.instance.currentUser!.uid;
        await database.ref('rooms/$id').set(
          {
            'id': id,
            'name': 'My Room',
            'players': [
              '$id',
            ],
            'game': {
              'id': id,
              'nextTurn': 'X',
              'currentTurn': 'O',
              'winner': 'nill',
              'board': ['', '', '', '', '', '', '', '', ''],
              'gameOver': false,
              'draw': false,
            }
          },
        ).then((value) {
          joinRoom(id);
        });
      },
    );
  }

  void joinRoom(id) {
    print("joining room $id");
    Get.toNamed(Routes.GAME, arguments: id);
  }
}
