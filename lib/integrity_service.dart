// import 'package:flutter/services.dart';

// class PlayIntegrityService {
//   static const _channel = MethodChannel("play_integrity");

//   static Future<String?> getIntegrityToken(String nonce) async {
//     try {
//       final token = await _channel.invokeMethod("requestIntegrityToken", {
//         "nonce": nonce,
//       });
//       return token;
//     } catch (e) {
//       print("Play Integrity Error: $e");
//       return null;
//     }
//   }
// }
