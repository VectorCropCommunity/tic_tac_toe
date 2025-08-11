import 'package:get/get.dart';

import '../controllers/game_controller.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() {
    // Not permanent so that each game session starts fresh (player names, mode)
    Get.put(GameController());
  }
}
