//
//  MLAESUtil.h
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import <Foundation/Foundation.h>

@interface MLAESUtil : NSObject

NSString * aesEncryptString(NSString *content, NSString *key);

NSString * aesDecryptString(NSString *content, NSString *key);

@end
