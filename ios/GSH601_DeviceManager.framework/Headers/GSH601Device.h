//
//  GSH601Device.h
//  DeviceManager
//
//  Created by gsh_mac_2018 on 2020/7/2.
//  Copyright © 2020 GSH. All rights reserved.
//


#if defined (SDK)
#import <BleManager/BleManager.h>
#else
#import "BaseBLEDevice.h"
#import "DeviceDatas.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface GSH601Device : BaseBLEDevice 

@end

NS_ASSUME_NONNULL_END
