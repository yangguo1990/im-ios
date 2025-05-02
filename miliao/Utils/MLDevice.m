//
//  MLDevice.m
//  miliao
//
//  Created by apple on 2022/8/24.
//

#import "MLDevice.h"
#import <AdSupport/AdSupport.h>
#import <sys/utsname.h>

@implementation MLDevice

//- (NSString *)app_version {
//    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString * version = infoDictionary[@"CFBundleShortVersionString"];
//    return version;
//}
//- (void)setApp_version:(NSString *)app_version {
//    self.app_version = app_version;
//}
// 
//- (NSString *)device_name {
//    return UIDevice.currentDevice.name;
//}
// 
//- (NSString *)device_model {
//    return [[UIDevice currentDevice] model];
//}
// 
//- (NSString *)device_system_name {
//    return  [[UIDevice currentDevice] systemName];
//}
// 
//- (NSString *)device_system_version {
//    return  [[UIDevice currentDevice] systemVersion];
//}
// 
//- (NSString *)identifier {
//    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//}
// 
//- (NSString *)device_model_name {
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString * deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
//
//}

@end
