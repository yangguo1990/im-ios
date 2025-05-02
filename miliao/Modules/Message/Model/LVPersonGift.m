//
//  LVPersonGift.m
//  LiveVideo
//
//  Created by 林必义 on 2017/8/3.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import "LVPersonGift.h"

@implementation LVPersonGift

+(instancetype) instanceWithDic:(NSDictionary *) dic
{
    if(!dic || ![dic isKindOfClass:[NSDictionary class]]){
        return nil;
    }
    
    LVPersonGift * gift = [LVPersonGift new];
    gift.giftId = dic[@"giftid"];
    gift.giftUrl = dic[@"image"];
    gift.giftName = dic[@"name"];
    gift.giftPrice = dic[@"price"];
    gift.giftNumber = dic[@"num"];
    
    return gift;
}
@end
