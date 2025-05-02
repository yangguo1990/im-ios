//
//  ML_AppUtil.h
//  LiveVideo
//
//  Created by 林必义 on 2017/4/23.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LVFetchUserBlock)(NSError * error);

@interface ML_AppUtil : NSObject

+ (BOOL)isCensor;
+ (void) fetchUserInfoNecessaryById:(NSString *) userId;
+ (NSString *) lvVideoLocalPathWithServerUrl:(NSString *) serverUrl;
+ (void) fetchUserInfoNecessaryById:(NSString *) userId withBlock:(LVFetchUserBlock) block;

@end
