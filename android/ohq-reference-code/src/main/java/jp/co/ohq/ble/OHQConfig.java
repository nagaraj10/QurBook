package jp.co.ohq.ble;

import jp.co.ohq.androidcorebluetooth.CBConfig;

public class OHQConfig extends CBConfig {

    public enum Key {
        CreateBondOption,
        RemoveBondOption,
        AssistPairingDialogEnabled,
        AutoPairingEnabled,
        AutoEnterThePinCodeEnabled,
        PinCode,
        StableConnectionEnabled,
        StableConnectionWaitTime,
        ConnectionRetryEnabled,
        ConnectionRetryDelayTime,
        ConnectionRetryCount,
        UseRefreshWhenDisconnect,
    }
}
