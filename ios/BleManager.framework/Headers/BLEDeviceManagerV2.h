#import "BLEDeviceManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLEDeviceManagerV2 : BLEDeviceManager
-(void) startScanWithDeviceUUID:(NSString*)deviceUUID;

@end

NS_ASSUME_NONNULL_END
