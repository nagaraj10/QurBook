//
//  GoldenBleDeviceManager.h
//  LS202_DeviceManager
//
//  Created by gsh_mac_2018 on 2020/5/28.
//  Copyright © 2020 GSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoldenLS202DeviceManagerCallback.h"
#import <BleManager/BleManager.h>
#import "BWBleDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoldenLS202DeviceManager : NSObject
@property (nonatomic,assign) id <GoldenLS202DeviceManagerCallback>  delegate;
- (instancetype)initWithDelegate:(id)_delegate;
- (NSString*) getSDKVersion;
- (void) setDebugMode:(BOOL)isOpen;
- (void)scanLeDevice:(BOOL)isOpen DeviceUUID:(NSString*)deviceUUID;
- (void) scanLeDevice:(BOOL)isOpen;
- (void) disconnect;
- (void) destroy;
- (void) disableAlertView:(BOOL)isDisable;
/**
tall range : 110 ~ 220 (If it is out of range, only the weight and BMI are output)
sex range :  SEX_TYPE.SEX_ISFALE | SEX_TYPE.SEX_ISFEMALE (If it is out of range, only the weight and BMI are output)
Age range : 18~80 (If it is out of range, only the weight and BMI are output)
**/
- (void) setUserInfoWithHeight:(double)height Sex:(SEX_TYPE)sex Age:(int)age;
@end

NS_ASSUME_NONNULL_END
