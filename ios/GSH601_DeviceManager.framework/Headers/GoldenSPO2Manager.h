//
//  GoldenBleDeviceManager.h
//  TP_DeviceManager
//
//  Created by gsh_mac_2018 on 2020/4/24.
//  Copyright © 2020 GSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoldenSPO2ManagerCallback.h"
#import <BleManager/BleManager.h>
#import "GSH601Device.h"
NS_ASSUME_NONNULL_BEGIN

@interface GoldenSPO2Manager : NSObject
@property (nonatomic,assign) id <GoldenSPO2ManagerCallback>  delegate;
- (instancetype)initWithDelegate:(id)_delegate;
- (NSString*) getSDKVersion;
- (void) setDebugMode:(BOOL)isOpen;
- (void)scanLeDevice:(BOOL)isOpen DeviceUUID:(NSString*)deviceUUID;
- (void) scanLeDevice:(BOOL)isOpen;
- (void) disconnect;
- (void) destroy;
@end

NS_ASSUME_NONNULL_END
