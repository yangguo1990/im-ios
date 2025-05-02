//
//  LVPersonGift.h
//  LiveVideo
//
//  Created by 林必义 on 2017/8/3.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVPersonGift : NSObject
@property(nonatomic,strong) NSString * giftId;
@property(nonatomic,strong) NSString * giftName;
@property(nonatomic,strong) NSString * giftPrice;
@property(nonatomic,strong) NSString * giftNumber;
@property(nonatomic,strong) NSString * giftUrl;

+(instancetype) instanceWithDic:(NSDictionary *) dic;
@end
