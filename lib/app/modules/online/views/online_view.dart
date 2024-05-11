import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tic_tac_toe/app/modules/online/model/room_model.dart';

import '../controllers/online_controller.dart';

class OnlineView extends GetView<OnlineController> {
  const OnlineView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var arguments = Get.arguments;
    print(arguments);
    controller.userCred.value = arguments["user"];
    return Scaffold(
        appBar: AppBar(
          title: const Text('PLAY ONLINE'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                controller.createRoom();
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: Obx(
          () => ListView.builder(
            itemCount: controller.rooms.length,
            itemBuilder: (BuildContext context, int index) {
              return roomList(controller.rooms[index]);
            },
          ),
        ));
  }

  Widget roomList(Room room) {
    return ListTile(
      leading: const Icon(Icons.games),
      title: Text(room.name),
      subtitle: Text('players : ${room.players.length.toString()}'),
      trailing: const Icon(Icons.play_arrow),
      onTap: () {
        controller.joinRoom(room.id);
      },
    );
  }
}
