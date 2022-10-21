#import "BaseDevice.h"
#import <CoreBluetooth/CoreBluetooth.h>
/**
 所有藍牙設備的基礎類型，繼承至BaseDevice
 */
@interface BaseBLEDevice : BaseDevice
/**
 設備需要尋找到服務都定義在這個陣列裡
 */
@property (retain,nonatomic) NSArray *uuids;
@property (retain,nonatomic) NSString *softwareVersion;
@property (retain,nonatomic) NSString *hardwareVersion;
@property (retain,nonatomic) NSString *firmwareVersion;
@property (retain,nonatomic) NSString *manufacturerName;
@property (retain,nonatomic) NSString *batteryLevel;

@property (retain,nonatomic) NSString *connectIOSUUID;
@property (retain,nonatomic) NSString *connectIOSName;
@property (retain,nonatomic) NSString *strFilterMacAddress;
@property (assign) BOOL isMacAddressFilterMode;

@property (assign) int readSystemInfoStatus;
@property (assign) int readSystemInfoComplete;
- (NSString*)intSTRFromHexString:(NSString *) hexStr;
-(NSString *) StringConvert:(NSString *)str;
-(NSString *) NSDataToHexString:(NSData *)data;
/**
 將文字轉換成byte格式
 */
-(NSData*)stringToByte:(NSString*)string;
/**掃到設備，準備與設備連線前可以做的事情*/
-(void)didDiscoverPeripheralHandler:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
/**藍牙管理器跟設備已連線，準備尋找設備提供服務前，可以做的事情*/
-(void)didConnectPeripheralHandler:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral;
/**藍牙管理器跟設備已斷線，可以做的事情*/
-(BOOL)didDisconnectPeripheral:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error;
/**藍牙管理器回覆設備上可以使用的服務的命令，並讓個別設備決定如何處理*/
-(void)didDiscoverCharacteristicsForService:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
/**藍牙管理器收到藍牙設備的資料回復，並讓個別設備決定如何處理*/
-(void)didUpdateValueForCharacteristic:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
/**對藍牙設備寫入一個命令成功後會回傳到這裡，並讓個別設備決定要如何處理*/
-(void)didWriteValueForCharacteristic:(CBPeripheral *)aPeripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
-(void)didUpdateNotificationStateForCharacteristic:(CBPeripheral *)aPeripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
@end
