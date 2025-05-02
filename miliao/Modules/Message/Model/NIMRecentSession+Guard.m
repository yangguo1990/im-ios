//
//  NIMRecentSession+Guard.m
//  SiMiZhiBo
//
//  Created by 林必义 on 2017/12/18.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import "NIMRecentSession+Guard.h"
#import "ML_GuardMeManager.h"

@implementation NIMRecentSession (Guard)

-(int) beingGuared
{
    int guardInfo = [[ML_GuardMeManager sharedManager].sessionId2GuardRelationDic[self.session.sessionId] intValue];
    return guardInfo ;
}
@end
