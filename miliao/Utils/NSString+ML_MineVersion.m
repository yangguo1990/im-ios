//
//  NSString+ML_MineVersion.m
//  miliao
//
//  Created by apple on 2022/9/8.
//

#import "NSString+ML_MineVersion.h"

@implementation NSString (ML_MineVersion)

+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    if ([v1 containsString:@"."] && [v2 containsString:@"."]) {
        // 获取版本号字段
        NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
        NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
        // 取字段最少的，进行循环比较
        NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
        
        for (int i = 0; i < smallCount; i++) {
            NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
            NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
            if (value1 > value2) {
                // v1版本字段大于v2版本字段，返回1
                return 1;
            } else if (value1 < value2) {
                // v2版本字段大于v1版本字段，返回-1
                return -1;
            }
            
            // 版本相等，继续循环。
        }
        
        // 版本可比较字段相等，则字段多的版本高于字段少的版本。
        if (v1Array.count > v2Array.count) {
            return 1;
        } else if (v1Array.count < v2Array.count) {
            return -1;
        } else {
            return 0;
        }
        
    } else {
        return [v1 intValue] - [v2 intValue];
    }
   
    return 0;
}
@end
