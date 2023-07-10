//
//  LSUserInfo.h
//  LSBluetoothPlugin
//
//  Created by caichixiang on 2020/12/28.
//  Copyright © 2020 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBluetoothManagerProfiles.h"

/**
 * 设备用户信息
 */
@interface LSUserInfo : NSObject

@property (nonatomic ,assign) NSUInteger userNumber;    //用户编号
@property (nonatomic ,assign) LSUserGender gender;      //用户性别
@property (nonatomic ,assign) NSUInteger age;           //年龄
@property (nonatomic ,assign) NSUInteger height;        //身高,单位cm(0.01m)
@property (nonatomic ,assign) double weight;            //体重,单位kg
@property (nonatomic ,assign) BOOL isAthlete;           //是否是运动员
@property (nonatomic ,assign) NSUInteger athleteLevel;  //运动等级
@end
