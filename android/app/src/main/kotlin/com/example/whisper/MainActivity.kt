package com.example.whisper

import android.media.MediaPlayer
import android.media.MediaRecorder
import android.os.Environment
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "myapp/audio"
    private var recorder: MediaRecorder? = null
    private var filePath: String? = null
    private var player: MediaPlayer? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "startRecording" -> {
                    startRecording()
                    result.success(null)
                }
                "stopRecording" -> {
                    val path = stopRecording()
                    result.success(path)
                }
                "playAudio" -> {
                    val path = call.argument<String>("path")
                    if (path != null) playAudio(path)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startRecording() {
        val dir = externalCacheDir
        val file = File(dir, "rec_${System.currentTimeMillis()}.m4a")
        filePath = file.absolutePath

        recorder = MediaRecorder().apply {
            setAudioSource(MediaRecorder.AudioSource.MIC)
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            setOutputFile(filePath)
            setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
            prepare()
            start()
        }
    }

    private fun stopRecording(): String? {
        return try {
            recorder?.apply {
                try {
                    stop() // may throw RuntimeException if too short
                } catch (e: RuntimeException) {
                    // If stop fails, delete corrupted file
                    filePath?.let { File(it).delete() }
                    filePath = null
                } finally {
                    release()
                }
            }
            filePath
        } catch (e: Exception) {
            e.printStackTrace()
            null
        } finally {
            recorder = null
        }
    }


    private fun playAudio(path: String) {
        player?.release()
        player = MediaPlayer().apply {
            setDataSource(path)
            prepare()
            start()
        }
    }
}
