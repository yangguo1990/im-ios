//
//  UserInfoManager.h
//  LiveVideo
//
//  Created by 林必义 on 2017/4/23.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UserInfoData : NSObject
@property (nonatomic,assign)  BOOL isHello;
@property (nonatomic,copy)  NSDictionary *officialInfo;
@property (nonatomic,copy)  NSString *wxpay_U;
@property (nonatomic,copy)  NSString *guildCode;
@property (nonatomic,copy)  NSString * alipay_U;
@property (nonatomic,copy)  NSString * wxPay;
@property (nonatomic,copy)  NSString *coin;
@property (nonatomic,copy)  NSString *credit;
@property (nonatomic,copy)  NSString * activeCoin;
@property (nonatomic,copy)  NSString * age;
@property (nonatomic,copy)  NSString * birthday;
@property (atomic,copy)  NSString * charge;
@property (nonatomic,copy)  NSString * city;
@property (nonatomic,copy)  NSString * dnd;
@property (nonatomic,copy)  NSString * earn;
@property (nonatomic,strong) NSString * em;
@property (nonatomic,strong) NSString * fansNum;
@property (nonatomic,strong) NSString * focusNum;
@property (nonatomic,strong) NSString * languageCode;
@property (nonatomic,strong) NSString * height;
//@property (nonatomic,strong) NSString * host;
@property (nonatomic,strong) NSString * hostAudit;
@property (nonatomic,strong) NSString * hostAuditRemind;
//@property (nonatomic,strong) NSString * icon;
@property (nonatomic,strong) NSString * identity;
@property (nonatomic,strong) NSString * inviteCode;
@property (nonatomic,strong) NSArray * lables;
@property (nonatomic,strong) NSString * level;
@property (nonatomic,strong) NSString * local;
@property (nonatomic,strong) NSString * verified;
@property (nonatomic,strong) NSString * noGneder;
@property (nonatomic,strong) NSString * persionSign;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic,strong) NSArray * photos;
@property (nonatomic,strong) NSString * privacy;
@property (nonatomic,strong) NSArray * pro;
@property (nonatomic,strong) NSString * wxShow;
@property (nonatomic,strong) NSString * uss;
@property (nonatomic,strong) NSString * weight;

// 登录与个人信息共同拥有的字段
@property (nonatomic,strong) NSString * userId;
@property (nonatomic,strong) NSString * host;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * icon;
@property (nonatomic,strong) NSString * gender;

// 登录
@property (nonatomic,strong) NSString *  domain;
@property (nonatomic,strong) NSString *  thirdId;
@property (nonatomic,strong) NSString * imToken;
@property (nonatomic,strong) NSString * token;
@property (nonatomic,strong) NSString * must;

- (NSDictionary *)getAllPropertyAndValues;
/*
 "imToken": "5d06191fd78580771195b9c1745afb5d",
 "token": "d3e64ab18005436fb05c4088a6dc1955",
 "id": 1,
 "host": 1,
 "must": 1,
 "name": "张三"
 "icon": "2020/06/03/012/20200604_IMG_0395.PNG",
 "gender": 1
 */
@end

@interface ML_AppUserInfoManager : NSObject

+ (instancetype)sharedManager;
+ (void)shuaWithCoin:(NSString *)coin;
@property (nonatomic,strong)    UserInfoData   *currentLoginUserData;
@property (nonatomic,strong) NSString * host;
@property (nonatomic,strong) NSString * hostip;

@end
