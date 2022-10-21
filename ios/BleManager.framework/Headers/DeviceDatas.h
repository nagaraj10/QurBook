#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface DeviceDatas : NSObject

@end

@interface BPDeviceData : DeviceDatas
/**脈搏*/
@property (assign) int intPulse;
/**收縮壓*/
@property (assign) int intSys;
/**舒張壓*/
@property (assign) int intDia;
@property (assign) int intAVI;
@property (assign) int intAPI;
@property (nonatomic,retain) NSString *strVersion;
@property (nonatomic,retain) NSString *strError;
@property (nonatomic,retain) NSString *strDeviceDate;
@property (nonatomic,retain) NSString *strOSDate;
@end

@interface BSDeviceData : DeviceDatas
/**葡萄糖*/
@property (assign) int intGlucoseData;
/**膽固醇*/
@property (assign) int intCholesterol;
@end

@interface BTDeviceData : DeviceDatas
/**量測的單位*/
@property (assign) int intMeasureUnit;
/**體溫數值*/
@property (assign) float fltTempDataResult;
@property (assign) BOOL isCelsius;
@property (assign) float oTemp;
/**耳溫或額溫或無法判斷*/
@property (assign) int intLocation;
/**設備mac*/
@property (nonatomic, retain) NSString* strMacAddress;
@property (assign) int intCount;
@end
@interface BTTaidocData : BTDeviceData
@property (assign) NSTimeInterval dobCount;
@end

@interface BWDeviceData : DeviceDatas
/**電阻值*/
@property (assign) float fltResistance;
/**體重*/
@property (assign) float fltWeight;
@end

@interface BWBC41DeviceData : BWDeviceData
@property(nonatomic, assign) int Year;                   /* Device's time Year */
@property(nonatomic, assign) int Month;                  /* Device's time Month */
@property(nonatomic, assign) int Date;                   /* Device's time Date */
@property(nonatomic, assign) int Hour;                   /* Device's time Hour */
@property(nonatomic, assign) int Minute;                 /* Device's time Minute */
@property(nonatomic, assign) int Body_type;              /* User body type 0 = standard / 2 = athlete */
@property(nonatomic, assign) int Gender;                 /* User gender 1 = male / 2 = female */
@property(nonatomic, assign) int Height;                 /* User height xxxxx(cm) */

@property(nonatomic, assign) float Body_fat_percentage;  /* User body fat percentage xx.x(%) */
@property(nonatomic, assign) float Fat_mass;             /* User fat mass xxx.x(kg) */
@property(nonatomic, assign) float Fat_free_mass;        /* User fat free mass xxx.x(kg) */
@property(nonatomic, assign) float Body_water_mass;      /* User body water mass xxx.x(kg) */
@property(nonatomic, assign) int Age;                    /* User Age 0~99 */
@property(nonatomic, assign) float BMI;                  /* User BMI xxx.x */
@property(nonatomic, assign) int BMR;                    /* User BMR xxxxx(kJ) */

@end

/**ECG回傳的數值需要透過這個型別來取得*/
@interface ECGDeviceData : DeviceDatas
/**檔案長度*/
@property (assign) int intLength;
/**ecg傳過來的rawData*/
@property (nonatomic, retain) NSData *recData;
/**uuid*/
@property (nonatomic, retain) CBUUID *recUUID;
@end


@interface GLM76DeviceData : DeviceDatas

@property(nonatomic, assign) int Year;                   /* Device's time Year */
@property(nonatomic, assign) int Month;                  /* Device's time Month */
@property(nonatomic, assign) int Date;                   /* Device's time Date */
@property(nonatomic, assign) int Hour;                   /* Device's time Hour */
@property(nonatomic, assign) int Minute;                 /* Device's time Minute */
@property(nonatomic, assign) int Second;                 /* Device's time Second */
@property(nonatomic, assign) float DATA;               /* User Blood Glucose data */
@property(nonatomic, retain) NSString *MealStatus;       /* User beforeMeal or afterMeal or testLiquid */

@end

@interface SPO2DeviceData : DeviceDatas

//range[0 100]    127 is invalid value
//value refresh frequency: 1HZ
@property(nonatomic,assign) NSUInteger SpO2Value;

//range[0 250]    255 is invalid value
//value refresh frequency: 1HZ
@property(nonatomic,assign) NSUInteger pulseRateValue;

//range[0 100]
//value refresh frequency: 100HZ
@property(nonatomic,assign) NSUInteger waveAmplitude;

@end





