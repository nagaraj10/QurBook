#import <Foundation/Foundation.h>
#import "BaseDeviceProtocol.h"
/**
 所有device 最基本的類別
 */
@interface BaseDevice : NSObject

/**設備相關回傳數值需透過這個界面傳送*/
@property (nonatomic,assign) id <BaseDeviceDelegate> delegate;
/**
 每個設備都會定義一個名字依照這名字去尋找相關的設備
 */
@property (nonatomic, retain) NSString* deviceName;
/**
 每個設備都會有一組macAddress
 */
@property (nonatomic, retain) NSString* macAddress;
@property (nonatomic, retain) NSString* showName;
@property (nonatomic, retain) NSString* deviceUUID;

@end
