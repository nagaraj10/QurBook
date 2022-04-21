package com.ventechsolutions.myFHB.bluetooth.callback;




import com.ventechsolutions.myFHB.bluetooth.data.BleDevice;

import java.util.List;

public abstract class BleScanCallback implements BleScanPresenterImp {

    public abstract void onScanFinished(List<BleDevice> scanResultList);

    public void onLeScan(BleDevice bleDevice) {
    }
}
