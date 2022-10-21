#import "BaseBLEDevice.h"
#import "BLEDeviceManagerProtocol.h"
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

enum {
    G_BLE_STATUS_IDLE = 0,//閒置中
    G_BLE_STATUS_SCANNING = 1,//掃瞄中
    G_BLE_STATUS_CONNECTING = 2,//連線中
    G_BLE_STATUS_CONNECTED = 3,//已連線
    G_BLE_STATUS_DISCONNECTED = 4,//已斷線
    G_BLE_ERROR = 5,
    G_BLE_STATUS_DISCONNECTED_BYUSER = 6//主動斷線
};
/**
 這是一個藍牙設備的管理器，可以由使用者自己定義繼承至BaseBLEDevice的設備進行使用
 主要只會針對非配對設備且，看哪一台設備先掃描到就連哪一台
 */
@interface BLEDeviceManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate,BaseDeviceDelegate>
{
    CBPeripheral        *m_peripheral;
    CBCentralManager    *m_manager;
}

/**回傳藍牙相關結果，給實作BLEDeviceManagerDelegate的物件*/
@property (nonatomic,assign) id <BLEDeviceManagerDelegate>  delegate;
/**所有要掃描的設備*/
@property (retain,nonatomic) NSMutableArray                 *devices;
/**過濾設備名稱用*/
@property (retain,nonatomic) NSString *strBleNames;
@property (retain,nonatomic) NSMutableArray *arrBleNames;
@property (retain,nonatomic) BaseBLEDevice       *device;
/**初始化 傳入
 @param _delegate //實作BLEDeviceManagerDelegate 的設備
 @param _devices  //實作繼承BaseBLEDevice 的設備陣列
 */
- (instancetype)initWithDelegate:(id)_delegate devices:(NSMutableArray*)_devices;

/**
 開始掃描藍牙設備
 */
- (void)startScan;
/**
 停止掃描 並中斷藍牙設備連線
 */
- (void)disconnectBT;
/**
 開始掃描藍牙設備清單
 */
-(void)startScanList;
/**
 根據清單中設備的uuid進行連線
 */
- (BOOL)connectDeviceByUUID:(NSString *)uuid;
/**找到設備並連線前 要做的事情  可以覆寫*/
-(BOOL)connectDevice:(CBCentralManager *)central didDiscoverPeripheral:(NSDictionary *)advertisementData RSSI:(NSNumber*)RSSI;

@end
