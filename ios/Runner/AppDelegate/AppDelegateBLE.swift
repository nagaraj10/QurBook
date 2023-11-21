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
import Flutter
import LSBluetoothPlugin

enum BLEDeviceManufacture {
    case WOWGo,Transteck
}

enum BLEDeviceType {
    case SPO2(deviceID : String?),BP(deviceID : String?),Weight(deviceID : String?),BGL(deviceID : String?)
}

enum BLEDeviceFilter {
    case All,Single
}

class SelectedDevices:NSObject {
    var selectedDevicesFilter:BLEDeviceFilter?
    var selectedDevicesType:BLEDeviceType?
    var selectedManufacturer:BLEDeviceManufacture?
    
    init(selectedDevicesFilter:BLEDeviceFilter? = nil,selectedDevicesType:BLEDeviceType? = nil ,selectedManufacturer:BLEDeviceManufacture? = nil){
        super.init()
        self.selectedDevicesType = selectedDevicesType
        self.selectedManufacturer = selectedManufacturer
        self.selectedDevicesFilter = selectedDevicesFilter
    }
}

//WOW GO
extension AppDelegate : FlutterStreamHandler, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    func setupBLEMethodChannels(){
        let evChannel =  FlutterEventChannel(name: Constants.devicesEventChannel, binaryMessenger: flutterController.binaryMessenger)
        evChannel.setStreamHandler(self)
        let devicesMethodChannel =  FlutterMethodChannel(name: Constants.devicesMethodChannel, binaryMessenger: flutterController.binaryMessenger)
        devicesMethodChannel.setMethodCallHandler {[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else{
                result(FlutterMethodNotImplemented)
                return
            }
            if call.method == Constants.scanForAllDevices{
                //self.selectedDevicesFilter = BLEDeviceFilter.All
                self.selectedDevicesList = [SelectedDevices(selectedDevicesFilter: .All)]
                self.centralManager = CBCentralManager(delegate: self, queue: nil)
            }
            else if call.method == Constants.scanForSingleDevices{
                self.selectedDevicesList = []
                if let data = call.arguments as? NSArray{
                    for currentItem in data {
                        if let currentItem = currentItem as? NSDictionary{
                            print(data)
                            var currentSelectedDevice = SelectedDevices()
                            if let deviceType = currentItem["deviceType"] as? String{
                                if (deviceType == "SPO2"){
                                    var deviceID:String? = nil
                                    if let device = currentItem["deviceId"] as? String{
                                        deviceID = device
                                    }
                                    currentSelectedDevice.selectedDevicesType = BLEDeviceType.SPO2(deviceID: deviceID)
                                    
                                }else if (deviceType == "BP"){
                                    var deviceID:String? = nil
                                    if let device = currentItem["deviceId"] as? String{
                                        deviceID = device
                                    }
                                    currentSelectedDevice.selectedDevicesType = BLEDeviceType.BP(deviceID: deviceID)
                                }else if (deviceType.lowercased() == "weight"){
                                    var deviceID:String? = nil
                                    if let device = currentItem["deviceId"] as? String{
                                        deviceID = device
                                    }
                                    currentSelectedDevice.selectedDevicesType = BLEDeviceType.Weight(deviceID: deviceID)
                                }else if (deviceType == "BGL"){
                                    var deviceID:String? = nil
                                    if let device = currentItem["deviceId"] as? String{
                                        deviceID = device
                                    }
                                    currentSelectedDevice.selectedDevicesType = BLEDeviceType.BGL(deviceID: deviceID)
                                }
                            }
                            if let manu = currentItem["manufacture"] as? String{
                                if manu == "WOWGo"{
                                    currentSelectedDevice.selectedDevicesFilter = .Single
                                    currentSelectedDevice.selectedManufacturer = .WOWGo
                                }else if manu == "Transteck"{
                                    currentSelectedDevice.selectedDevicesFilter = .Single
                                    currentSelectedDevice.selectedManufacturer = .Transteck
                                }
                            }
                            self.selectedDevicesList.append(currentSelectedDevice)
                        }
                    }
                }
                self.centralManager = CBCentralManager(delegate: self, queue: nil)
            }
        }
    }
    
    // Event channel call backs
    func onListen(withArguments arguments: Any?,
                  eventSink: @escaping FlutterEventSink) -> FlutterError? {
        _ = onCancel(withArguments: [])
        deviceSearched = false
        self.eventSink = eventSink
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        selectedDevicesList = []
        if(centralManager != nil){
            centralManager.stopScan()
            centralManager = nil
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
        LSBluetoothManager.default()?.stopSearch()
        LSBluetoothManager.default()?.stopDeviceSync()
        //        var devices = LSBluetoothManager.default().getDevices()
        //        for currentDevice in devices ?? [] {
        //            if let device = currentDevice as? LSDeviceInfo,let broadcastId = device.broadcastId{
        //                LSBluetoothManager.default()?.deleteDevice(broadcastId)
        //            }
        //        }
        return nil
    }
    //    Call this function to start the BLE which filters out the scan level.
    func startBLEScan(){
        for currentItem in selectedDevicesList {
            if(currentItem.selectedDevicesFilter != nil){
                switch currentItem.selectedDevicesFilter{
                case .All :
                    startAllDevicesScan()
                    break
                case .Single:
                    
                    startBLEScanForSingleManufacturer(selectedManufacturer: currentItem.selectedManufacturer,selectedDevicesType: currentItem.selectedDevicesType)
                    break
                case .none:
                    break
                }
            }
        }
        
    }
    
    func startBLEScanForSingleManufacturer(selectedManufacturer:BLEDeviceManufacture? = nil,selectedDevicesType:BLEDeviceType? = nil){
        if(selectedManufacturer != nil){
            switch selectedManufacturer {
            case .WOWGo:
                if (selectedDevicesType != nil){
                    switch selectedDevicesType{
                    case .SPO2(deviceID: _):
                        startWOWGoSPO2DeviceScan()
                        break
                    case .BP(deviceID: _):
                        startWOWGoBPDeviceScan()
                        break
                    case .BGL(deviceID: _): break
                    case .Weight(deviceID: _):
                        startWOWGoWeighingDeviceScan()
                        break
                    case .none:break
                    }
                }else{
                    
                }
                break
            case .Transteck:
                startAllDevicesScanForTransteck()
                break
            case .none:
                break
            }
        }
    }
    //Call This function to Scan for all the devices from all the Manufactures
    func startAllDevicesScan(){
        //Add function if there is a new device added
        startAllDevicesScanForWOWGo()
        startAllDevicesScanForTransteck()
    }
    
    
    //Native BLE callbacks
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            eventSink?("unknown|Please turn on your Bluetooth and try again")
        case .resetting:
            eventSink?("resetting|Please turn on your Bluetooth and try again")
        case .unsupported:
            eventSink?("unsupported|Please turn on your Bluetooth and try again")
        case .unauthorized:
            eventSink?("unauthorized|no permission granted")
        case .poweredOff:
            eventSink?("poweredOff|Please turn on your Bluetooth and try again")
        case .poweredOn:
            eventSink?("scanstarted|connection started")
            startBLEScan()
        default:
            eventSink?("enablebluetooth|Please turn on your Bluetooth and try again")
        }
    }
}

//WOWGo devices callbacks
extension AppDelegate:GoldenSPO2ManagerCallback,
                      GoldenBloodpressureManagerCallback,
                      GoldenLS202DeviceManagerCallback{
    
    
    //Single Manufacture with All the devices
    func startAllDevicesScanForWOWGo(){
        //Add function if there is a new device added
        startWOWGoSPO2DeviceScan()
        startWOWGoBPDeviceScan()
        startWOWGoWeighingDeviceScan()
    }
    //Call these functions to scan for specific devices with specific types from a specific Manufactures.
    func startWOWGoSPO2DeviceScan(deviceId : String? = nil){
        if(SPO2Manager == nil){
            SPO2Manager = GoldenSPO2Manager(delegate: self)
        }
        SPO2Manager.scanLeDevice(true)
    }
    
    func startWOWGoBPDeviceScan(deviceId : String? = nil){
        if(BloodpressureManager == nil){
            BloodpressureManager = GoldenBloodpressureManager(delegate: self)
        }
        BloodpressureManager.scanLeDevice(true)
    }
    
    func startWOWGoWeighingDeviceScan(deviceId : String? = nil){
        if(LS202DeviceManager == nil){
            LS202DeviceManager = GoldenLS202DeviceManager(delegate: self)
        }
        LS202DeviceManager.scanLeDevice(true)
    }
    
    
    func onDiscoverDevice(_ device: Any!) {
        
        if let _device = device  as? BaseBLEDevice{
            if((_device.deviceName == Constants.WOWGOWT1) || (_device.deviceName == Constants.WOWGOWT2) || (_device.deviceName == Constants.WOWGOWT3)){
                eventSink?("macid|"+_device.connectIOSUUID)
                eventSink?("manufacturer|WOWGo")
                eventSink?("bleDeviceType|WEIGHT")
            }else  if(_device.deviceName == Constants.WOWGOSPO2){
                eventSink?("macid|"+_device.connectIOSUUID)
                eventSink?("manufacturer|WOWGo")
                eventSink?("bleDeviceType|SPO2")
            }else if((_device.deviceName == Constants.WOWGOBP) || (_device.deviceName == Constants.WOWGOBPB)){
                eventSink?("macid|"+_device.connectIOSUUID)
                eventSink?("manufacturer|WOWGo")
                eventSink?("bleDeviceType|BP")
            }else if((_device.showName == Constants.WOWGOWT1) || (_device.showName == Constants.WOWGOWT2) || (_device.showName == Constants.WOWGOWT3)){
                eventSink?("macid|"+_device.connectIOSUUID)
                eventSink?("manufacturer|WOWGo")
                eventSink?("bleDeviceType|WEIGHT")
            }
        }
    }
    
    func onConnectStatusChange(_ device: Any!, status: Int32) {
        switch Int(status) {
        case G_BLE_STATUS_SCANNING:
            break;
        case G_BLE_STATUS_CONNECTING:
            break;
        case G_BLE_STATUS_CONNECTED:
            eventSink?("connected|connected successfully!!!")
            break;
        case G_BLE_STATUS_DISCONNECTED:
            eventSink?("disconnected|Bluetooth disconnected")
            break;
        case G_BLE_STATUS_DISCONNECTED_BYUSER:
            eventSink?("disconnected|Bluetooth disconnected")
            break;
        case G_BLE_ERROR:
            eventSink?("error|Bluetooth disconnected")
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
                    eventSink?("measurement|"+serlized)
                    eventSink = nil
                }
            }
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
                    eventSink?("measurement|"+serlized)
                    eventSink = nil
                }
            }
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
                    eventSink?("measurement|"+serlized)
                    eventSink = nil
                }
            }
        }
    }
    
    func showLogMessage(_ log: String!) {
        eventSink?("error|Bluetooth disconnected")
    }
}

// Transteck Devices
extension AppDelegate : LSBluetoothStatusDelegate,LSDeviceDataDelegate,LSDevicePairingDelegate{
    
    
    //Single Manufacture with All the devices
    func startAllDevicesScanForTransteck(){
        LSBluetoothManager.default()?.initManager(withDispatch: DispatchQueue.init(label: "bluetoothQueue"));
        LSBluetoothManager.default()?.checkingBluetoothStatus(self);
    }
    
    func systemDidBluetoothStatusChange(_ bleState: CBManagerState) {
        switch bleState {
        case .unknown:
            eventSink?("enablebluetooth|Please turn on your Bluetooth and try again")
        case .resetting:
            eventSink?("enablebluetooth|Please turn on your Bluetooth and try again")
        case .unsupported:
            eventSink?("enablebluetooth|Please turn on your Bluetooth and try again")
        case .unauthorized:
            eventSink?("permissiondenied|no permission granted")
        case .poweredOff:
            eventSink?("enablebluetooth|Please turn on your Bluetooth and try again")
        case .poweredOn:
            eventSink?("scanstarted|connection started")
            searchForTransteckBLEDevices()
        default:
            eventSink?("enablebluetooth|Please turn on your Bluetooth and try again")
        }
    }
    //bloodGlucoseMeter "TeleBGM GenlBLE"
    //weightScale    "GBS-2012-B"
    func searchForTransteckBLEDevices(){
        deviceSearched = false
        let selectedDevices = [Constants.TransteckBGLDeviceType,Constants.TransteckWeightDeviceType]
        LSBluetoothManager.default()?.searchDevice(selectedDevices) {[weak self]currentDeviceData in
            if let deviceName = currentDeviceData?.deviceName,
               let deviceType = currentDeviceData?.deviceType.rawValue,
               let macId = currentDeviceData?.macAddress,
               let deviceSearch = self?.deviceSearched,
               !deviceSearch{
                guard let self = self else { return  }
                print(deviceName)
                print(macId)
                print(deviceType)
                if(deviceType == 1){
                    self.eventSink?("macid|"+macId)
                    self.eventSink?("manufacturer|Transteck")
                    self.eventSink?("bleDeviceType|WEIGHT")
                    if currentDeviceData?.isRegistered ?? false{
                        LSBluetoothManager.default().addDevice(currentDeviceData!)
                        LSBluetoothManager.default().startDeviceSync(self)
                    }else{
                        LSBluetoothManager.default().pairDevice(currentDeviceData!, delegate: self)
                    }
                    //                    self.deviceSearched = true
                }else if(deviceType == 6){
                    self.eventSink?("macid|"+macId)
                    self.eventSink?("manufacturer|Transteck")
                    self.eventSink?("bleDeviceType|BGL")
                    if self.selectedDevicesList.first == SelectedDevices(selectedDevicesFilter: .All){
                        //during pair, you no need to read data
                    }else{
                        LSBluetoothManager.default().addDevice(currentDeviceData!)
                        LSBluetoothManager.default().startDeviceSync(self)
                    }
                    
                    //                    self.deviceSearched = true
                }
            }
            
        }
    }
    
    func bleDevice(_ device: LSDeviceInfo!, didPairStateChanged state: LSPairState) {
        print(state.rawValue)
        if(state == LSPairState.success){
            LSBluetoothManager.default()?.addDevice(device);
            LSBluetoothManager.default()?.startDeviceSync(self);
        }
    }
    
    func bleDevice(_ device: LSDeviceInfo!, didConnectStateChanged state: LSConnectState) {
        //        LSConnectStateUnknown=0,
        //        LSConnectStateConnected=1,
        //        LSConnectStateFailure=2,
        //        LSConnectStateDisconnect=3,
        //        LSConnectStateConnecting=4,
        //        LSConnectStateTimeout=5,
        //        LSConnectStateSuccess=6,
        if(state.rawValue == 6){
            eventSink?("connected|Device connected successfully")
        }
    }
    
    func bleDevice(_ device: LSDeviceInfo!, didDataUpdateForNotification obj: LSDeviceData!) {
        let className:String=type(of: obj).description();
        print(className)
        
        for (key, value) in obj.toString() {
            let dataStr:String=String.init(format: "%@=%@", key as CVarArg,value as! CVarArg);
            print(dataStr);
            if(className == "BGStatusInfo"){
                let components = dataStr.components(separatedBy: "=")
                if components.count > 1, components.first == "glucose"{
                    if let bgl = value as? BloodGlucose{
                        let data : [String:Any] = [
                            "Status" : "Measurement",
                            "deviceType" : "BGL",
                            "Data" : [
                                "BGL" : String(describing: bgl.value),
                            ]
                        ]
                        if let serlized = data.jsonStringRepresentation{
                            eventSink?("measurement|"+serlized)
                            eventSink = nil
                        }
                    }
                } else if components.count > 1, components.first == "status"{
                    let value = components[1]
//                    if(value == "17"){
//                        eventSink?("bgl|Your device is ready")
//                    }else if (value == "34"){
//                        eventSink?("bgl|Insert the blood sample on the strip.")
//                    }else
                    if (value == "221"){
                        eventSink?("disconnected|Disconnected")
                    }else if (value == "51"){
                        eventSink?("bgl|Blood sample collected successfully.")
                    }
                }
                
            }
        }
    }
    
    func bleDevice(_ device: LSDeviceInfo!, didDataUpdateForScale weight: LSScaleWeight!) {
        
        //        var dataLabel = "";
        //        let str:String = String.init(format: "\nsrcData=%@\n",weight.srcData!.hexadecimal);
        //        dataLabel = dataLabel + str + "\n"
        //        print("----------------------------------1----------------------------------")
        //        print(dataLabel)
        //        dataLabel = "";
        //        //log class name
        //        let className:String=type(of: weight).description();
        //        //log class properties
        //        dataLabel = dataLabel + className + "\n"
        //        for (key, value) in weight.toString() {
        //            let dataStr:String=String.init(format: "%@=%@", key as CVarArg,value as! CVarArg);
        //            dataLabel = dataLabel + dataStr
        //        }1690262063 --1690262052
        
        //        let utcStr:String = String.init(format: "utc=%d", weight.utc);
        //        dataLabel = dataLabel + utcStr
        //        print("----------------------------------2----------------------------------")
        //        print(dataLabel) -- 10.35 --10:39 -- 1690261762 --1690260757
        // eventSink?("remainCount|" + String(describing: weight.remainCount) + "-" + String(format: "%.2f", weight.weight))
        let current = Date().adding(minutes: -2)
        let currentTime =  (current.timeIntervalSince1970).toInt() ?? 0
//        print(current)
//        print(currentTime)
//        print(weight.utc)
        if(weight.remainCount == 0){
            if(weight.utc > currentTime){
                let data : [String:Any] = [
                    "Status" : "Measurement",
                    "deviceType" : "weight",
                    "Data" : [
                        "Weight" : String(format: "%.2f", weight.weight),
                    ]
                ]
                if let serlized = data.jsonStringRepresentation{
                    eventSink?("measurement|"+serlized)
                    eventSink = nil
                }
            }
        }
    }
    
    func bleDevice(_ device: LSDeviceInfo!, didDataUpdateForBloodPressureMonitor data: LSBloodPressure!)
    {
        //        var dataLabel = "";
        //        let str:String = String.init(format: "\nsrcData=%@\n",data.srcData!.hexadecimal);
        //        dataLabel = dataLabel + str + "\n"
        //        eventSink?("connected|"+dataLabel)
        //        dataLabel = "";
        //        //log class name
        //        let className:String=type(of: data).description();
        //        dataLabel = dataLabel + className + "\n"
        //        //log class properties
        //        for (key, value) in data.toString() {
        //            let dataStr:String=String.init(format: "%@=%@", key as CVarArg,value as! CVarArg);
        //            dataLabel = dataLabel + dataStr
        //        }
        //        let utcStr:String = String.init(format: "utc=%d", data.utc);
        //        dataLabel = dataLabel + utcStr
        //        eventSink?("connected|"+dataLabel)
        
    }
    
    func bleDevice(_ device: LSDeviceInfo!, didDataUpdateForBloodGlucose data: BGDataSummary!) {
        
        //        let newData = BloodGlucoseSummaryData(data: data).toJson()
        //        if let serlized = newData.jsonStringRepresentation{
        //            self.eventSink?("bloodglucosesummarydata|"+serlized)
        //        }else{
        //            self.eventSink?("failed|"+"Failed to parse the bloodglucosesummarydata")
        //        }
    }
    
    
}

