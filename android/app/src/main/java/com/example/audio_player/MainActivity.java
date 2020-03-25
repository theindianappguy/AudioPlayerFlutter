package com.example.audio_player;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.MediaPlayer;
import android.os.BatteryManager;
import android.os.Build;
import android.widget.Toast;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "samples.flutter.dev/battery";

    MediaPlayer player;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("getBatteryLevel")) {
                                int batteryLevel = getBatteryLevel();

                                if (batteryLevel != -1) {
                                    result.success(batteryLevel);
                                } else {
                                    result.error("UNAVAILABLE", "Battery level not available.", null);
                                }
                            }

                            if(call.method.equals("playAudio")){
                                if(player == null){
                                    player = MediaPlayer.create(this, R.raw.bloomeforever);
                                    result.success(true);
                                }
                                player.start();
                            }

                            if(call.method.equals("pauseAudio")){
                                if(player != null){
                                    player.pause();
                                    result.success(false);
                                }
                            }

                            if(call.method.equals("stopAudio")){
                                result.success(stopPlayer());
                            }

                            /*else{
                                result.notImplemented();
                            }*/
                        }
                );
    }

    private boolean stopPlayer(){
        if(player != null){
            player.release();
            player = null;
            Toast.makeText(this, "Media Player Released", Toast.LENGTH_SHORT).show();
        }
        return  false;
    }

    private int getBatteryLevel() {
        int batteryLevel = -1;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }

        return batteryLevel;
    }

    public  void playMusic(){

    }

    public  void pauserPlayer(){

    }

    @Override
    protected void onStop() {
        super.onStop();
        stopPlayer();
    }
}
