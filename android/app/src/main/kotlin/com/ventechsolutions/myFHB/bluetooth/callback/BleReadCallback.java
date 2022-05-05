package com.ventechsolutions.myFHB.bluetooth.callback;


import com.ventechsolutions.myFHB.bluetooth.exception.BleException;

public abstract class BleReadCallback extends BleBaseCallback {

    public abstract void onReadSuccess(byte[] data);

    public abstract void onReadFailure(BleException exception);

}
