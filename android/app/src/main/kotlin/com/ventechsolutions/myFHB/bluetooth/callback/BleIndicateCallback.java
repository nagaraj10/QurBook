package com.ventechsolutions.myFHB.bluetooth.callback;


import com.ventechsolutions.myFHB.bluetooth.exception.BleException;

public abstract class BleIndicateCallback extends BleBaseCallback{

    public abstract void onIndicateSuccess();

    public abstract void onIndicateFailure(BleException exception);

    public abstract void onCharacteristicChanged(byte[] data);
}
