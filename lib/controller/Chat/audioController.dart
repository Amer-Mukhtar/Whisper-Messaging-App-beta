import 'package:flutter/services.dart';

class NativeAudio {
  static const _channel = MethodChannel("myapp/audio");

  static Future<void> startRecording() async {
    await _channel.invokeMethod("startRecording");
  }

  static Future<String?> stopRecording() async {
    return await _channel.invokeMethod("stopRecording");
  }

  static Future<void> playAudio(String path) async {
    await _channel.invokeMethod("playAudio", {"path": path});
  }

}
