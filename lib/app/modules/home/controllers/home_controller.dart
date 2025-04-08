import 'package:get/get.dart';

final isAudioOn = true.obs;

class HomeController extends GetxController {
  void toggleAudio() {
    isAudioOn.value = !isAudioOn.value;
  }
}
