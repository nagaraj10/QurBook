
#import <Foundation/Foundation.h>
#ifndef BaseDeviceProtocol_h
#define BaseDeviceProtocol_h
/**device 的delegate實作這個delegate 可以透過這個界面取得device處理完的數值 */
@protocol BaseDeviceDelegate
@required
/**設備本身資料處理完後會透過這個回傳 處理結果*/
-(void) baseDevice:(id)device resultData:(NSObject*)data;
@optional
-(void) baseDevice:(id)device;
@end
#endif /* BaseDeviceProtocol_h */
