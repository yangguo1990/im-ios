//
//  ML_GuardMeManager.h
//  SiMiZhiBo
//
//  Created by 林必义 on 2017/12/18.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ML_GuardMeManager : NSObject

@property(nonatomic,strong) NSMutableDictionary * sessionId2GuardRelationDic;

+(instancetype) sharedManager;

-(void) addGuarMeWithUserId:(NSString *) userId;
-(void) removeGuardMeWithUserId:(NSString *) userId;
-(BOOL) isGuardMeWithUserId:(NSString *) userId;

-(void) addMeGuardWithUserId:(NSString *) userId;//我守护
-(void) removeMeGuardWithUserId:(NSString *) userId;//移除我守护
-(BOOL) isMeGuardWithUserId:(NSString *) userId;//我是否守护

-(BOOL) hasGuaredRelation:(NSString *) userId;//用户排序，不管是谁守护了，统一认为具有守护关系
@end
