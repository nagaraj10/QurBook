package com.ventechsolutions.myFHB.bluetooth.exception;


public class OtherException extends BleException {

    public OtherException(String description) {
        super(ERROR_CODE_OTHER, description);
    }

}
