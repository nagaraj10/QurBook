package com.ventechsolutions.myFHB.bluetooth.callback;


import com.ventechsolutions.myFHB.bluetooth.exception.BleException;

public abstract class BleNotifyCallback extends BleBaseCallback {

    public abstract void onNotifySuccess();

    public abstract void onNotifyFailure(BleException exception);

    public abstract void onCharacteristicChanged(byte[] data);

}
