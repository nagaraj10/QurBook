package com.ventechsolutions.myFHB;

import android.app.Activity;
import android.app.Application;

import androidx.annotation.CallSuper;

import io.flutter.view.FlutterMain;

public class MyApp extends Application {
    @Override
    @CallSuper
    public void onCreate() {
        super.onCreate();
        FlutterMain.startInitialization(this);
    }

    public static boolean isMissedNSShown=true;

    private Activity mCurrentActivity = null;

    public Activity getCurrentActivity() {
        return mCurrentActivity;
    }

    public void setCurrentActivity(Activity mCurrentActivity) {
        this.mCurrentActivity = mCurrentActivity;
    }
}