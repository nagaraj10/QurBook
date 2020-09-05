package com.ventechsolutions.myFHB;

import android.app.Activity;
import android.app.Application;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;

import androidx.annotation.CallSuper;
import androidx.core.app.NotificationManagerCompat;

import com.ventechsolutions.myFHB.services.OnTapNotification;

import java.util.Map;

import io.flutter.view.FlutterMain;

public class MyApp extends Application {
    @Override
    @CallSuper
    public void onCreate() {
        super.onCreate();
        FlutterMain.startInitialization(this);
    }

    public static Context getmContext() {
        return mContext;
    }

    public static void setmContext(Context mContext) {
        MyApp.mContext = mContext;
    }

    public static Context mContext;

    public static boolean isMissedNSShown=true;

    private Activity mCurrentActivity = null;

    public Activity getCurrentActivity() {
        return mCurrentActivity;
    }

    public void setCurrentActivity(Activity mCurrentActivity) {
        this.mCurrentActivity = mCurrentActivity;
    }

    // public static void createAckNotification(Map<String,String> data){
    //     int  NS_ID=1001;
    //     String CHANNEL_NAME = "cha_ack";
    //     String meetingId=data.get("meeting_id");
    //     String userName=data.get("username");
    //     String title=data.get("title");
    //     String body=data.get("body");


    //     // define sound URI, the sound to be played when there's a notification
    //     Uri soundUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + mContext.getPackageName() + "/" + R.raw.msg_tone);

    //     // intent triggered, you can add other intent for other actions
    //     Intent onTapNS = new Intent(mContext, OnTapNotification.class);
    //     onTapNS.putExtra(mContext.getString(R.string.nsid), NS_ID);
    //     onTapNS.putExtra(mContext.getString(R.string.meetid), meetingId);
    //     onTapNS.putExtra(mContext.getString(R.string.username), userName);
    //     PendingIntent pIntent = PendingIntent.getActivity(mContext, 0, onTapNS, 0);

    //     if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.O){
    //         NotificationManager notificationManager = (NotificationManager) mContext.getSystemService(NOTIFICATION_SERVICE);
    //         NotificationChannel channel = new NotificationChannel(CHANNEL_NAME,mContext.getString(R.string.channel_ack),NotificationManager.IMPORTANCE_DEFAULT);
    //         channel.setDescription(mContext.getString(R.string.channel_ack_desc));
    //         notificationManager.createNotificationChannel(channel);
    //     }

    //     // this is it, we'll build the notification!
    //     // in the addAction method, if you don't want any icon, just set the first param to 0
    //     Notification mNotification = new Notification.Builder(mContext)

    //             .setContentTitle(title)
    //             .setContentText(body)
    //             .setSmallIcon(R.mipmap.app_ns_icon)
    //             .setContentIntent(pIntent)
    //             .setSound(soundUri)
    //             .setAutoCancel(true)
    //             .build();



    //     // If you want to hide the notification after it was selected, do the code below
    //     // myNotification.flags |= Notification.FLAG_AUTO_CANCEL;
    //     NotificationManager notificationManager = (NotificationManager) mContext.getSystemService(NOTIFICATION_SERVICE);
    //     notificationManager.notify(NS_ID, mNotification);
    // }
}