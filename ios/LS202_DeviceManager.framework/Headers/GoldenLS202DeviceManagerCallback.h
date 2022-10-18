//
//  GoldenBleDeviceManagerCallback.h
//  TP_DeviceManager
//
//  Created by gsh_mac_2018 on 2020/4/24.
//  Copyright © 2020 GSH. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum _SEX_TYPE{
    SEX_ISFEMALE = 0,
    SEX_ISMALE = 1
} SEX_TYPE;

typedef enum _MEASUREMENT_ERROR
{
    NOERROR = 0,
    IMP_IS_ZERO = 1,
    IMP_IS_LESS_THAN_300 = 2,
    IMP_IS_GREATER_THAN_800 = 3,
    HEIGHT_OUT_OF_RANGE = 4,
    SEX_OUT_OF_RANGE = 5,
    AGE_OUT_OF_RANGE = 6,
    ABNORMAL_MEASUREMENT = 7
} MEASUREMENT_ERROR;
@protocol GoldenLS202DeviceManagerCallback <NSObject>
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
/*
* Has dealt with the problem of repeated count.
*
* return data
*
* */
-(void) onReceiveMeasurementData:(id)device weight:(double)weight BMI:(double)BMI BodyFatRate:(double)bodyFatRate WaterRate:(double)waterRate Muscle:(double)muscle Bone:(double)bone BMR:(double)bmr VisceralFatLevel:(double)visceralFatLevel ProteinRate:(double)proteinRate ErrorCode:(MEASUREMENT_ERROR)errorcode;
/*
 * If you call mBlemanager.debugMode(true)
 *
 * return all mBlemanager log to this.
 * */
-(void) showLogMessage:(NSString*)log;

-(void) onReceiveMeasurementData:(id)device weight:(double)weight BMI:(double)BMI BodyFatRate:(double)bodyFatRate WaterRate:(double)waterRate Muscle:(double)muscle SkeletalMuscle:(double)skeletalMuscle Bone:(double)bone BMR:(double)bmr VisceralFatLevel:(double)visceralFatLevel ProteinRate:(double)proteinRate ErrorCode:(MEASUREMENT_ERROR)errorcode;
@end
