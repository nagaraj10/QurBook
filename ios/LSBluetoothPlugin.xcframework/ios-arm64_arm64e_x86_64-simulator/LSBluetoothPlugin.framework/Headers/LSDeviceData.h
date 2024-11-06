//
//  LSDeviceData.h
//  LSBluetoothPlugin
//
//  Created by caichixiang on 2020/12/28.
//  Copyright © 2020 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBluetoothManagerProfiles.h"
#import "LSDeviceFeature.h"


/**
 * 标准协议，时间格式
 */
@interface LSCurrentTime : NSObject

@property (nonatomic,assign)int year;
@property (nonatomic,assign)int month;
@property (nonatomic,assign)int day;
@property (nonatomic,assign)int hours;
@property (nonatomic,assign)int minutes;
@property (nonatomic,assign)int seconds;
@property (nonatomic,assign)long utc;
@property (nonatomic,strong)NSString * _Nullable time;
@property (nonatomic,strong)NSData * _Nullable srcData;

-(instancetype _Nonnull )initWithData:(NSData *_Nullable)data;

/**
 * 获取当前时间
 */
+(NSData *_Nonnull)getCurrentTime;
@end


/**
 * 秤重脂肪相关成分数据
 */
@interface LSScaleFat : NSObject

@property(nonatomic, assign) NSUInteger userNumber;      //用户编号
@property(nonatomic, assign) double basalMetabolism;     //基础代谢值
@property(nonatomic, assign) double bodyFatRatio;        //脂肪率
@property(nonatomic, assign) double bodywaterRatio;      //水分含量
@property(nonatomic, assign) double visceralFat;         //内脏脂肪水平
@property(nonatomic, assign) double muscleMass ;          //肌肉含量
@property(nonatomic, assign) double boneDensity;         //骨质密度
@property(nonatomic, assign) double voltageData;         //电压值
@property(nonatomic, assign) double imp;                 //电阻值转换后的阻抗
@property(nonatomic, assign) double protein;             //蛋白质含量
@property(nonatomic, assign) double bmi;                 //bmi指数
@property(nonatomic, assign) double fatFreeMass;
@property(nonatomic, assign) double softLeanMass;
@end

/**
 * 设备数据基类
 */
@interface LSDeviceData : NSObject

@property(nonatomic,assign)NSUInteger utc;                      //测量时间，UTC
@property(nullable,nonatomic,strong)NSString *broadcastId;      //广播ID
@property(nullable,nonatomic,strong)NSString *deviceId;         //设备ID
@property(nullable,nonatomic,strong)NSString *deviceSN;         //设备SN
@property(nullable,nonatomic,strong)NSString *measureTime;      //测量时间，格式 yyyy-MM-dd HH:mm:ss
@property(nonatomic,strong,readonly)NSData * _Nullable srcData; //原始数据包

-(instancetype _Nonnull)initWithData:(NSData *_Nullable)data;

/**
 * 数据包解码，由子类重写
 */
-(void)decoding;

/**
 * 对象信息
 */
-(NSDictionary *_Nonnull)toString;
@end

/**
 * 血压测量数据
 */
@interface LSBloodPressure : LSDeviceData

@property(nonatomic,assign)int systolic;                         //收缩压
@property(nonatomic,assign)int diastolic;                        //舒张压
@property(nonatomic,assign)int pluseRate;                        //心率
@property(nonatomic,assign)int meanPressure;                     //平均脉压
@property(nonatomic,assign)NSUInteger userNumber;                //用户编号
@property(nonatomic,assign)NSUInteger remainCount;               //剩余记录条数

@property(nullable,nonatomic,strong)NSString *unit;              //测量单位，mmHg 或 kPa
@property(nullable,nonatomic,strong)BPMeasurementStatus *status; //测量状态
@end


/**
 * 秤重测量数据
 */
@interface LSScaleWeight : LSDeviceData

@property(nonatomic,assign)NSUInteger userNumber;         //用户编号
@property(nonatomic,assign)double weight;                 //体重数据，单位kg
@property(nonatomic,assign)double resistance_1;           //测量阻抗1，电阻值，用于计算相应的脂肪数据
@property(nonatomic,assign)double resistance_2;           //测量阻抗2，电阻值，用于计算相应的脂肪数据
@property(nonatomic,assign)double lbWeightValue;          //体重数据，计算单位LB
@property(nonatomic,assign)double stWeightValue;          //体重数据，计算单位St,后面数据
@property(nonatomic,assign)NSUInteger stSectionValue;     //体重数据，计算单位St,前面数据
@property(nonatomic,assign)NSUInteger remainCount;        //剩余记录条数
@property(nonatomic,assign)NSUInteger timeZone;           //时区
@property(nonatomic,assign)NSUInteger heartRate;          //心率
@property(nonatomic,assign)double babyWeight;             //婴儿体重

@property(nonatomic,assign)double voltageValue;           //电压值
@property(nonatomic,assign)int hasAppendMeasurement;      //是否有附加的脂肪测量数据包
@property(nonatomic,assign)BOOL isRealtimeData;           //实时数据标志，true表示实时数据，false表示锁定数据
@property(nonatomic,assign)LSMeasurementUnit unit;        //测量单位
@property(nonatomic,strong)LSScaleFat * _Nullable fat;    //脂肪成分数据
@end


/**
 * 血压计在测量过程中上报的错误信息
 */
@interface BPMErrorInfo : LSDeviceData

/**
 * <p>错误码</p>
 * <p>0x01：袖带没绑紧或充气异常</p>
 * <p>0x02：测量中说话或走动</p>
 * <p>0x03：未检测到脉搏</p>
 * <p>0x04：计算不到血压</p>
 * <p>0x05: 结果超出范围</p>
*/
@property(nonatomic,assign) int errorCode;
@end

/**
 * 血压计测量状态
 */
@interface BPMStatusSummary : LSDeviceData

/**
 * 测量状态
 * 0：测量停止
 * 1：测量开始
 */
@property(nonatomic,assign) int state;
@end


/**
 * 血糖仪测量数据
 */
@interface BloodGlucose : LSDeviceData


/**
 * 血糖值
 */
@property(nonatomic,assign) float value;

/**
 * 单位
 */
@property(nonatomic,strong) NSString * _Nullable unit;

/**
 * 血糖数据状态
 * 0x00=no status
 * 0x11=FPG
 * 0x22=PPG
 */
@property(nonatomic,assign) int status;

/**
 * 血糖数据类型
 * 0x11=indicates blood
 * 0x22=indicates qc solution
 */
@property(nonatomic,assign) int dataType;

/**
 * 历史数据标签
 */
@property(nonatomic,assign) BOOL historicalData;


-(instancetype)initWithData:(NSData *)data unit:(NSString *)unit realtimeData:(BOOL)tag;
@end


/**
 * 血糖仪测量状态信息
 */
@interface BGStatusInfo : LSDeviceData

/**
 * 测量状态
 */
@property(nonatomic,assign) BGStatus status;

/**
 * 错误码
 */
@property(nonatomic,assign) BGErrorCode errorCode;

/**
 * 当前测量结果
 */
@property(nonatomic,strong) BloodGlucose * _Nullable glucose;

-(instancetype)initWithData:(NSData *)data unit:(NSString *)unit;
@end



/**
 * 血糖仪测量数据概要信息
 */
@interface BGDataSummary : LSDeviceData

/**
 * 数据项大小
 */
@property(nonatomic,assign) int size;

/**
 * 数据项信息
 */
@property(nonatomic,strong) NSArray <BloodGlucose*> *items;
@end


#pragma mark - LSScaleState

/**
 * 体重秤设备状态信息
 */
@interface LSScaleState : LSDeviceData

/**
 * 设备重置或处于出厂状态标志位
 */
@property(nonatomic,assign)BOOL reset;
@end
