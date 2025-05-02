//
//  MLDevice.h
//  miliao
//
//  Created by apple on 2022/8/24.
//

#import <Foundation/Foundation.h>


@interface MLDevice : NSObject


///token
@property (nonatomic, copy) NSString * token;
///App 版本号
@property (nonatomic, copy) NSString * app_version;
///设备名称
@property (nonatomic, copy, readwrite) NSString * device_name;
///设备类型 iPhone、ipad
@property (nonatomic, copy, readwrite) NSString * device_model;
///设备系统名称
@property (nonatomic, copy, readwrite) NSString * device_system_name;
///设备系统版本号
@property (nonatomic, copy, readwrite) NSString * device_system_version;
///设备的唯一标识：卸载重装之后不会改变
@property (nonatomic, copy, readwrite) NSString * identifier;
///设备类型
@property (nonatomic, copy, readwrite) NSString * device_model_name;


@end
