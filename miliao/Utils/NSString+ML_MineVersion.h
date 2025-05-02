//
//  NSString+ML_MineVersion.h
//  miliao
//
//  Created by apple on 2022/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ML_MineVersion)

+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 ;


@end

NS_ASSUME_NONNULL_END
