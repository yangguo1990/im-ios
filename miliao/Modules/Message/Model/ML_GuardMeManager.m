//
//  ML_GuardMeManager.m
//  SiMiZhiBo
//
//  Created by 林必义 on 2017/12/18.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import "ML_GuardMeManager.h"

@interface ML_GuardMeManager()
@property(atomic,strong) NSMutableSet * guardMeSet;
@property(atomic,strong) NSMutableSet * meGuardSet;
@end
@implementation ML_GuardMeManager

+(instancetype) sharedManager
{
    static ML_GuardMeManager * _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(instancetype) init
{
    self = [super init];
    if(self){
        self.guardMeSet = [NSMutableSet set];
        self.meGuardSet = [NSMutableSet set];
    }
    return self;
}

-(void) addGuarMeWithUserId:(NSString *) userId
{
    if(![userId isKindOfClass:[NSString class]] || !userId.length){
        return;
    }
    NSSet * set = [NSSet setWithObject:userId];
    @synchronized(self){
        [self.guardMeSet unionSet:set];
    }

}
-(void) removeGuardMeWithUserId:(NSString *) userId
{
    if(![userId isKindOfClass:[NSString class]] || !userId.length){
        return;
    }
    NSSet * set = [NSSet setWithObject:userId];
    @synchronized(self){
        [self.guardMeSet minusSet:set];
    }
}
-(BOOL) isGuardMeWithUserId:(NSString *) userId
{
    @synchronized(self){
        return [self.guardMeSet containsObject:userId];
    }
}

-(void) addMeGuardWithUserId:(NSString *) userId//我守护
{
    if(![userId isKindOfClass:[NSString class]] || !userId.length){
        return;
    }
    NSSet * set = [NSSet setWithObject:userId];
    @synchronized(self){
        [self.meGuardSet unionSet:set];
    }
}
-(void) removeMeGuardWithUserId:(NSString *) userId//移除我守护
{
    if(![userId isKindOfClass:[NSString class]] || !userId.length){
        return;
    }
    NSSet * set = [NSSet setWithObject:userId];
    @synchronized(self){
        [self.meGuardSet minusSet:set];
    }
}

-(BOOL) isMeGuardWithUserId:(NSString *) userId//我是否守护
{
    @synchronized(self){
        return [self.meGuardSet containsObject:userId];
    }
}

-(BOOL) hasGuaredRelation:(NSString *) userId//用户排序，不管是谁守护了，统一认为具有守护关系
{
    return([self isMeGuardWithUserId:userId] || [self isGuardMeWithUserId:userId]);
}
@end
