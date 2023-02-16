//
//  GoldenBleDeviceManagerCallback.h
//  TP_DeviceManager
//
//  Created by gsh_mac_2018 on 2020/4/24.
//  Copyright © 2020 GSH. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoldenSPO2ManagerCallback <NSObject>
@required
/*
* return callback device
* You can get the deviceName
*
* */
-(void) onDiscoverDevice:(id)device;
/*
* Bluetooth status change connecting\connected\disconnected\error
*
*
* */
-(void) onConnectStatusChange:(id)device status:(int)status;

@optional
-(void) onReceiveMeasurementData:(id)device SpO2Value:(NSUInteger)SpO2Value pulseRateValue:(NSUInteger)pulseRateValue waveAmplitude:(NSUInteger)waveAmplitude;
/*
 * If you call mBlemanager.debugMode(true)
 *
 * return all mBlemanager log to this.
 * */
-(void) showLogMessage:(NSString*)log;
@end
