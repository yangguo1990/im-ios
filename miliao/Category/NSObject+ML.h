//
//  UIViewController+LVURLRedirect.h
//  LiveVideo
//
//  Created by 史贵岭 on 2017/6/21.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSObject (ML)
- (void)opentNotificationAlertWithTitle:(NSString *)title;
// 去充值
- (void)gotoChongVC;
// 去文字聊天
- (void)gotoChatVC:(NSString *)userId;
// 去主页
- (void)gotoInfoVC:(NSString *)userId;
- (void)gotoCallVCWithUserId:(NSString *)userId isCalled:(BOOL)isCalled;
// 举报拉黑
- (void)ML_PopAction:(NSInteger)index pDic:(NSDictionary *)pDic;
- (void)ML_InfoPopAction:(NSInteger)index pDic:(NSDictionary *)pDic;
// 容错null
+ (id)changeType:(id)myObj;
// 获取唯一标识
- (NSString *)ML_GetUniqueDeviceIdentifierAsString;
// 网络封装需要
- (NSString *)jsonStringForDictionary;
- (NSString *)giveformatter;
-(NSString *)numstr;
- (NSString *) sha1:(NSString *)input;
-(NSString *)shaData;
- (void)ML_GuanzhuWithUserId:(NSString *)userId btnView:(UIButton *)btn;
- (void)imageViewAddClickWithImageView:(UIImageView *)imageView;
- (void)gotoCallVCWithUserId:(NSString *)userId isCalled:(BOOL)isCalled isPipei:(BOOL)isPipei;
- (NSString*)getPreferredLanguage;
- (BOOL)isValidateEmail:(NSString *)email;
- (NSString *)getCurrentDeviceModel;
@end
