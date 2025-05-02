//
//  MLIPAddress.h
//  miliao
//
//  Created by apple on 2022/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLIPAddress : NSObject
+ (NSString *)getIPAddress;

- (NSString *)getIPAddress:(BOOL)preferIPv4;

@end

NS_ASSUME_NONNULL_END
