package com.globalmantrainnovations.myfhb;

import android.app.Activity;
import android.app.Application;

import androidx.annotation.CallSuper;

import com.amazonaws.services.chime.sdk.meetings.audiovideo.AudioVideoFacade;

import io.flutter.view.FlutterMain;

public class MyApp extends Application {
    public AudioVideoFacade getAudioVideoFacade() {
        return audioVideoFacade;
    }

    public void setAudioVideoFacade(AudioVideoFacade AVFacade) {
        audioVideoFacade = AVFacade;
    }

    private static AudioVideoFacade audioVideoFacade;
    @Override
    @CallSuper
    public void onCreate() {
        super.onCreate();
        FlutterMain.startInitialization(this);
    }

    private Activity mCurrentActivity = null;

    public Activity getCurrentActivity() {
        return mCurrentActivity;
    }

    public void setCurrentActivity(Activity mCurrentActivity) {
        this.mCurrentActivity = mCurrentActivity;
    }
}
