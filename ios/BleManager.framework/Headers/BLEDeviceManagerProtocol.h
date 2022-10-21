#ifndef BLEDeviceManagerProtocol_h
#define BLEDeviceManagerProtocol_h
/**manager 的delegate實作這個delegate 可以透過這個界面取得藍牙相關狀態及device處理完數值的結果 */
@protocol BLEDeviceManagerDelegate <NSObject>
@required
/**藍牙狀態改變，透過這裡取得*/
-(void) bleManager:(id)manager updateStatus:(int)status;
/**藍牙設備資料處理好後會透過這裡取得處理好的資料只需要將resultData 轉成可以取得資料的型別即可*/
-(void) bleManager:(id)manager device:(id)resultDevice resultData:(NSObject*)data;
@optional
-(void) bleManagerWithDiscover:(id)device;
-(void) bleManager:(id)manager device:(id)resultDevice;
-(void) bleManager:(id)manager deviceList:(NSMutableDictionary *)list;
-(void) showManagerLog:(NSString*)log;
@end

#endif /* BLEDeviceManagerProtocol_h */
