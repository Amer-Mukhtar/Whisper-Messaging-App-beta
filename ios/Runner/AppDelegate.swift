import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var audioRecorder: AVAudioRecorder?
  var audioPlayer: AVAudioPlayer?
  var filePath: String = ""

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "myapp/audio",
                                      binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "startRecording":
        self.startRecording()
        result(nil)
      case "stopRecording":
        result(self.stopRecording())
      case "playAudio":
        if let args = call.arguments as? [String: Any],
           let path = args["path"] as? String {
          self.playAudio(path: path)
        }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func startRecording() {
    let fileName = "rec_\(Int(Date().timeIntervalSince1970)).m4a"
    let path = NSTemporaryDirectory().appending(fileName)
    filePath = path

    let url = URL(fileURLWithPath: path)
    let settings: [String: Any] = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 44100,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]

    do {
      audioRecorder = try AVAudioRecorder(url: url, settings: settings)
      audioRecorder?.record()
    } catch {
      print("Failed to record: \(error)")
    }
  }

  func stopRecording() -> String {
    audioRecorder?.stop()
    return filePath
  }

  func playAudio(path: String) {
    let url = URL(fileURLWithPath: path)
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: url)
      audioPlayer?.play()
    } catch {
      print("Playback failed: \(error)")
    }
  }
}
