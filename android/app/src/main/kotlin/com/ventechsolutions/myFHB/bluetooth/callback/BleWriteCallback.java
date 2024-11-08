package com.ventechsolutions.myFHB.bluetooth.callback;


import com.ventechsolutions.myFHB.bluetooth.exception.BleException;

public abstract class BleWriteCallback extends BleBaseCallback{

    public abstract void onWriteSuccess(int current, int total, byte[] justWrite);

    public abstract void onWriteFailure(BleException exception);

}
