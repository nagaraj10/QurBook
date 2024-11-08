package jp.co.ohq.ble.enumerate;

public enum OHQDetailedState {
    Unconnected,
    ConnectStarting,
    PairRemoving,
    Pairing,
    GattConnecting,
    ServiceDiscovering,
    ConnectCanceling,
    CleanupConnection,
    ConnectionRetryReady,
    CommunicationReady,
    DescValueReading,
    CharValueReading,
    NotificationEnabling,
    UserRegistering,
    UserAuthenticating,
    UserDataDeleting,
    WaitingForUpdateOfDatabaseChangeIncrement,
    WriteUserDataPreparing,
    UserDataWriting,
    MeasurementRecordAccessControlling,
    PlxMeasurementRecordAccessControlling,
    Idle,
    Disconnecting,
    Disconnected,
    ConnectCanceled,
    ConnectionFailed,
}
