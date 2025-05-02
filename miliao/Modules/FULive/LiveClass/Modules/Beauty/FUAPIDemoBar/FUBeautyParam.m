//
//  FUBeautyParam.m
//  FULiveDemo
//
//  Created by 孙慕 on 2020/1/7.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import "FUBeautyParam.h"

@implementation FUBeautyParam

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"调用了encodeWithCoder:方法");

    [aCoder encodeObject:self.mTitle forKey:@"mTitle"];
    [aCoder encodeObject:self.mParam forKey:@"mParam"];
    [aCoder encodeFloat:self.mValue forKey:@"mValue"];
    [aCoder encodeObject:self.mImageStr forKey:@"mImageStr"];
    [aCoder encodeBool:self.iSStyle101 forKey:@"iSStyle101"];
    [aCoder encodeFloat:self.defaultValue forKey:@"defaultValue"];
    [aCoder encodeInteger:self.type forKey:@"type"];
}

// 当从文件中读取一个对象的时候就会调用该方法
// 在该方法中说明如何读取保存在文件中的对象
// 也就是说在该方法中说清楚怎么读取文件中的对象
- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"调用了initWithCoder:方法");
    //注意：在构造方法中需要先初始化父类的方法
    if (self=[super init]) {
        self.mTitle = [aDecoder decodeObjectForKey:@"mTitle"];
        self.mParam = [aDecoder decodeObjectForKey:@"mParam"];
        self.mValue = [aDecoder decodeFloatForKey:@"mValue"];
        self.mImageStr = [aDecoder decodeObjectForKey:@"mImageStr"];
        self.iSStyle101 = [aDecoder decodeBoolForKey:@"iSStyle101"];
        self.defaultValue = [aDecoder decodeFloatForKey:@"defaultValue"];
        self.type = [aDecoder decodeIntegerForKey:@"type"];
    }
    return self;
}
@end
