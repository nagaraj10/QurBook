//
//  GoldenBleDeviceManager.h
//  TP_DeviceManager
//
//  Created by gsh_mac_2018 on 2020/4/24.
//  Copyright © 2020 GSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoldenBloodpressureManagerCallback.h"
//#import "BLEDeviceManagerV2.h"
#import <BleManager/BleManager.h>
#import "BPGSH862BDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface GoldenBloodpressureManager : NSObject
@property (nonatomic,assign) id <GoldenBloodpressureManagerCallback>  delegate;
- (instancetype)initWithDelegate:(id)_delegate;
- (NSString*) getSDKVersion;
- (void) setDebugMode:(BOOL)isOpen;
- (void) scanLeDevice:(BOOL)isOpen DeviceUUID:(NSString*)deviceUUID;
- (void) scanLeDevice:(BOOL)isOpen filterMacAddress:(NSString*)filterMacAddress;//ex: filterMacAddress = 3C:16:03:07:16:20 or 3C1603071620,  not 20160703163c
- (void) scanLeDevice:(BOOL)isOpen;
- (void) disconnect;
- (void) destroy;
@end

NS_ASSUME_NONNULL_END
