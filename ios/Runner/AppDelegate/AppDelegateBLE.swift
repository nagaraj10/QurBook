//
//  AppDelegateBLE.swift
//  Runner
//
//  Created by Venkatesh on 18/10/22.
//  Copyright © 2022 The Chromium Authors. All rights reserved.
//

import BleManager
import GSH601_DeviceManager
import DB62M_DeviceManager
import LS202_DeviceManager

extension AppDelegate:FlutterStreamHandler, CBCentralManagerDelegate, CBPeripheralDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            eventSink?("enablebluetooth|please enable bluetooth")
        case .resetting:
            eventSink?("enablebluetooth|please enable bluetooth")
        case .unsupported:
            eventSink?("enablebluetooth|please enable bluetooth")
        case .unauthorized:
            eventSink?("permissiondenied|no permission granted")
        case .poweredOff:
            eventSink?("enablebluetooth|please enable bluetooth")
        case .poweredOn:
            eventSink?("scanstarted|connection started")
            centralManager.scanForPeripherals(withServices: [])
        default:
            eventSink?("enablebluetooth|please enable bluetooth")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let name = advertisementData[Constants.BLENameData] as? String,
           name.lowercased().contains("blesmart"){
            centralManager.stopScan()
            let tempMacId = String(name.suffix(12))
            let macID = tempMacId.inserting(reverse: false)
            OHQDeviceManager.shared().scanForDevices(with: OHQDeviceCategory.any) {[weak self] deviceInfoKeys in
                guard let self = self else { return  }
                OHQDeviceManager.shared().stopScan()
                self.idForBP = deviceInfoKeys[OHQDeviceInfoKey.identifierKey] as? UUID
                if (self.idForBP) != nil{
                    OHQDeviceManager.shared().startSession(withDevice: self.idForBP!, usingDataObserver: { dataType, data in
                        if let ArrayData =  data as? NSArray,ArrayData.count > 0,let lastObj = ArrayData.lastObject as? NSDictionary{
                            let lsOBj : [String:Any] = [
                                "Status" : "Measurement",
                                "deviceType" : "BP",
                                "Data" : [
                                    "Systolic" :  lastObj["systolic"],
                                    "Diastolic" : lastObj["diastolic"],
                                    "Pulse" :  lastObj["pulseRate"]
                                ]
                            ];
                            if let serlized = lsOBj.jsonStringRepresentation{
                                print(serlized)
                                self.eventSink?("measurement|"+serlized)
                                self.eventSink = nil
                                if self.idForBP != nil {
                                    OHQDeviceManager.shared().cancelSession(withDevice: self.idForBP!)
                                    self.idForBP = nil
                                }
                            }
                        }
                    }, connectionObserver: {[weak self] state in
                        guard let self = self else { return }
                        if (state == OHQConnectionState.connected){
                            self.eventSink?("macid|"+macID)
                            self.eventSink?("bleDeviceType|BP")
                        }
                    }, completion: { completionReason in
                        if (completionReason == OHQCompletionReason.busy || completionReason == OHQCompletionReason.poweredOff){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [self] in
                                print("restarted");
                                self.centralManager = CBCentralManager(delegate: self, queue: nil)
                                self.centralManager.scanForPeripherals(withServices: [])
                            }
                        }
                    }, options: [
                        OHQSessionOptionKey.readMeasurementRecordsKey : true,
                        OHQSessionOptionKey.connectionWaitTimeKey : 60
                    ])
                }
            } completion: { completionReason in
                if (completionReason == OHQCompletionReason.busy || completionReason == OHQCompletionReason.poweredOff){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
                        print("restarted");
                        self.centralManager = CBCentralManager(delegate: self, queue: nil)
                        self.centralManager.scanForPeripherals(withServices: [])
                    }
                }
            }
        }else if let newdata =  advertisementData[Constants.BLEManuData] as? Data,
                 let serviceIdArray =  advertisementData[Constants.BLEAdvDataServiceUUIDs] as? NSArray,
                 serviceIdArray.count > 0,
                 let serviceId = serviceIdArray.firstObject as? CBUUID{
            let decodedString = newdata.hexEncodedString()
            let macID = decodedString.inserting()
            centralManager.stopScan()
            guard let deviceName = advertisementData[Constants.BLENameData] as? String else {
                eventSink?("Failed|Failed to get the device details")
                return
            }
            if(deviceName == Constants.WOWGOSPO2){
                eventSink?("macid|"+macID)
                eventSink?("bleDeviceType|SPO2")
                SPO2Manager = GoldenSPO2Manager(delegate: self)
                SPO2Manager.scanLeDevice(true)
                centralManager = nil
            }else if (deviceName == Constants.Mike){
                eventSink?("macid|"+macID)
                eventSink?("bleDeviceType|SPO2")
                poPeripheral = peripheral
                poPeripheral.delegate = self
                centralManager.connect(poPeripheral)
            } else if((deviceName == Constants.WOWGOBP) || (deviceName == Constants.WOWGOBPB)){
                eventSink?("macid|"+macID)
                eventSink?("bleDeviceType|BP")
                BloodpressureManager = GoldenBloodpressureManager(delegate: self)
                BloodpressureManager.scanLeDevice(true)
                centralManager = nil
            }else if((deviceName == Constants.WOWGOWT1) || (deviceName == Constants.WOWGOWT2) || (deviceName == Constants.WOWGOWT3)){
                eventSink?("macid|"+macID)
                eventSink?("bleDeviceType|weight")
                LS202DeviceManager = GoldenLS202DeviceManager(delegate: self)
                LS202DeviceManager.scanLeDevice(true)
                centralManager = nil
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        eventSink?("connected|connected successfully!!!")
        poPeripheral.discoverServices([Constants.poServiceCBUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case Constants.poMeasurementCharacteristicCBUUID:
            spoReading(from: characteristic,peripheral:peripheral)
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    func spoReading(from characteristic: CBCharacteristic, peripheral: CBPeripheral)  {
        guard let characteristicData = characteristic.value else { return  }
        var index = 0
        let byteArray = [UInt8](characteristicData)
        while(index<byteArray.count){
            let fingure = byteArray[index+2] & Constants.BIT_FINGER
            var pulse = byteArray[index+2] & Constants.BIT_PLUSE_RATE_BIT7 << 1
            pulse += byteArray[index+3] & Constants.BIT_PLUSE_RATE_BIT0_6
            let spo = byteArray[index+4] & Constants.BIT_SPO2
            if(fingure == 0 && spo < 101 && pulse != 127 && pulse != 255){
                let data : [String:Any] = [
                    "Status" : "Measurement",
                    "deviceType" : "SPO2",
                    "Data" : [
                        "SPO2" : String(describing: spo),
                        "Pulse" : String(describing: pulse)
                    ]
                ]
                if let serlized = data.jsonStringRepresentation{
                    print(serlized)
                    eventSink?("measurement|"+serlized)
                    eventSink = nil
                    centralManager.stopScan()
                    if( characteristic.isNotifying){
                        peripheral.setNotifyValue(false, for: characteristic)
                    }
                }
            }
            index += 5
        }
    }
    
    func onListen(withArguments arguments: Any?,
                  eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        centralManager = CBCentralManager(delegate: self, queue: nil)
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        if(centralManager != nil){
            centralManager.stopScan()
            centralManager = nil
        }
        if idForBP != nil {
            OHQDeviceManager.shared().cancelSession(withDevice: idForBP!)
            idForBP = nil
        }
        if(SPO2Manager != nil){
            SPO2Manager.scanLeDevice(false)
            SPO2Manager.destroy()
            SPO2Manager = nil
        }
        if(BloodpressureManager != nil){
            BloodpressureManager.scanLeDevice(false)
            BloodpressureManager.destroy()
            BloodpressureManager = nil
        }
        
        if(LS202DeviceManager != nil){
            LS202DeviceManager.scanLeDevice(false)
            LS202DeviceManager.destroy()
            LS202DeviceManager = nil
        }
        return nil
    }
    
}

extension AppDelegate:GoldenSPO2ManagerCallback,GoldenBloodpressureManagerCallback,GoldenLS202DeviceManagerCallback{
    
    func onDiscoverDevice(_ device: Any!) {
        
    }
    
    func onConnectStatusChange(_ device: Any!, status: Int32) {
        switch Int(status) {
        case G_BLE_STATUS_SCANNING:
            print("Scanning")
            break;
        case G_BLE_STATUS_CONNECTING:
            print("CONNECTING")
            
            break;
        case G_BLE_STATUS_CONNECTED:
            print("CONNECTED")
            eventSink?("connected|connected successfully!!!")
            break;
        case G_BLE_STATUS_DISCONNECTED:
            print("disCONNECTED")
            
            break;
        case G_BLE_STATUS_DISCONNECTED_BYUSER:
            /*User click stop or disconnect GSH BLE device**/
            //"G_BLE_STATUS_DISCONNECTED_BYUSER"
            break;
        case G_BLE_ERROR:
            print("error found")
            break;
        default:
            break;
        }
    }
    
    
    func onReceiveMeasurementData(_ device: Any!, spO2Value SpO2Value: UInt, pulseRateValue: UInt, waveAmplitude: UInt) {
        let _device : BaseBLEDevice = (device as? BaseBLEDevice)!
        if (_device.showName == Constants.WOWGOSPO2){
            if(SpO2Value < 101 && pulseRateValue != 127 && pulseRateValue != 255 && eventSink != nil ){
                let data : [String:Any] = [
                    "Status" : "Measurement",
                    "deviceType" : "SPO2",
                    "Data" : [
                        "SPO2" : String(describing: SpO2Value),
                        "Pulse" : String(describing: pulseRateValue)
                    ]
                ]
                if let serlized = data.jsonStringRepresentation{
                    print(serlized)
                    eventSink?("measurement|"+serlized)
                    eventSink = nil
                }
            }
            print("SPO2 is %d PulseRate is %d",SpO2Value,pulseRateValue)
        }
    }
    
    
    func onReceiveMeasurementData(_ device: Any!, dia: Int32, sys: Int32, pulse: Int32) {
        let _device : BaseBLEDevice = (device as? BaseBLEDevice)!
        if( (_device.showName == Constants.WOWGOBP) || (_device.showName == Constants.WOWGOBPB)){
            if( eventSink != nil ){
                let data : [String:Any] = [
                    "Status" : "Measurement",
                    "deviceType" : "BP",
                    "Data" : [
                        "Systolic" : String(describing: sys),
                        "Diastolic" : String(describing: dia),
                        "Pulse" : String(describing: pulse)
                    ]
                ]
                if let serlized = data.jsonStringRepresentation{
                    print(serlized)
                    eventSink?("measurement|"+serlized)
                    eventSink = nil
                }
            }
            print("BP is systolic is %d,diastolic is %d and PulseRate is %d",sys,dia,pulse)
        }
    }
    
    func onReceiveMeasurementData(_ device: Any!, weight: Double, bmi BMI: Double, bodyFatRate: Double, waterRate: Double, muscle: Double, bone: Double, bmr: Double, visceralFatLevel: Double, proteinRate: Double, errorCode errorcode: MEASUREMENT_ERROR) {
        let _device : BaseBLEDevice = (device as? BaseBLEDevice)!
        if ((_device.showName == Constants.WOWGOWT1) || (_device.showName == Constants.WOWGOWT2) || (_device.showName == Constants.WOWGOWT3)){
            if( eventSink != nil ){
                let data : [String:Any] = [
                    "Status" : "Measurement",
                    "deviceType" : "weight",
                    "Data" : [
                        "Weight" : String(format: "%.2f", weight),
                    ]
                ]
                if let serlized = data.jsonStringRepresentation{
                    print(serlized)
                    eventSink?("measurement|"+serlized)
                    eventSink = nil
                }
            }
            print("Weight is %d",weight)
        }
    }
    
    func showLogMessage(_ log: String!) {
        print("GoldenBleDeviceManager Log : ",log!);
    }
}
