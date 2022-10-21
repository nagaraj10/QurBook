//
//  BWBleDevice.h
//  SoHappy
//
//  Created by Yu Chi on 2017/9/2.
//
//
#if defined (SDK)
#import <BleManager/BleManager.h>
#else
#import "BaseBLEDevice.h"
#import "DeviceDatas.h"
#endif
//透過SERIAL_NUMBER 取得mac
@interface BWBleDevice : BaseBLEDevice
@end

