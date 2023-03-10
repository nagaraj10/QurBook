package com.ventechsolutions.myFHB;

import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.EventChannel;

class MainThreadEventSink implements EventChannel.EventSink {
    private EventChannel.EventSink eventSink;
    private Handler handler;

    MainThreadEventSink(EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
        handler = new Handler(Looper.getMainLooper());
    }

    @Override
    public void success(final Object o) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                eventSink.success(o);
            }
        });
    }

    @Override
    public void error(final String s, final String s1, final Object o) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                eventSink.error(s, s1, o);
            }
        });
    }

    @Override
    public void endOfStream() {

    }
}
