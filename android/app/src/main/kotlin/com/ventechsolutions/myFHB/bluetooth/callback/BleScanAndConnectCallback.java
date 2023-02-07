package com.ventechsolutions.myFHB.bluetooth.callback;


import com.ventechsolutions.myFHB.bluetooth.data.BleDevice;

public abstract class BleScanAndConnectCallback extends BleGattCallback implements BleScanPresenterImp {

    public abstract void onScanFinished(BleDevice scanResult);

    public void onLeScan(BleDevice bleDevice) {
    }

}
