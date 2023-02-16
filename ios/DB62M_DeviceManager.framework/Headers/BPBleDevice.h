//
//  GSHBPBleDevice.h
//  SoHappy
//
//  Created by elaine on 2017/8/30.
//
//
#if defined (SDK)
#import <BleManager/BleManager.h>
#else
#import "BaseBLEDevice.h"
#import "DeviceDatas.h"
#endif
/**血壓藍牙設備的基礎類別 繼承至BaseBLEDevice*/
@interface BPBleDevice : BaseBLEDevice

@end
