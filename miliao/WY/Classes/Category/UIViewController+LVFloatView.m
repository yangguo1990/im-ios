//
//  UIViewController+LVFloatView.m
//  LiveVideo
//
//  Created by 史贵岭 on 2017/8/29.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import "UIViewController+LVFloatView.h"
#import <objc/runtime.h>
#import "ML_AppUserInfoManager.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"


#define LVDisturbFloatViewHeight 44
#define LVDisturbViewTag         2233446688
NSString * LVDisturbFloatViewShowNotification = @"LVDisturbFloatViewShowNotification";
NSString * LVDisturbFloatViewHideNotification = @"LVDisturbFloatViewHideNotification";

@protocol LVDisturbViewDelegate <NSObject>

@optional
-(void) lvDistrubViewClick;

@end
@interface LVDisturbView : UIView
@property(nonatomic,weak) id<LVDisturbViewDelegate> delegate;
@end

@implementation LVDisturbView
-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithHexString:@"#FF4B5A"];
        
        NSString * path  = [[NSBundle mainBundle] pathForResource:@"lv_notifi@2x.png" ofType:nil];
        UIImage * img = [UIImage imageWithContentsOfFile:path];
        
        UIImageView * notifImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (LVDisturbFloatViewHeight -13)/2, 13, 13)];
        notifImgView.image = img;
        [self addSubview:notifImgView];
        
        UIFont * font = [UIFont systemFontOfSize:12];
        if(UIScreenWidth <= 320){
            font = [UIFont systemFontOfSize:11.0];
        }
        
        UILabel * upLabel = [UILabel new];
        upLabel.textColor = [UIColor colorWithHexString:@"FFE151"];
        upLabel.font = font;
        upLabel.text = @"接受视频呼叫功能被关闭";
        [upLabel sizeToFit];
        [self addSubview:upLabel];
        
        UILabel * downLabel = [UILabel new];
        downLabel.textColor = [UIColor whiteColor];
        downLabel.font = font;
        NSString * gender = [ML_AppUserInfoManager sharedManager].currentLoginUserData.gender;
        if(gender.intValue == 2){
            downLabel.text = @"打开才能收到视频呼叫、获取积分和提现";
        }else{
            downLabel.text = @"打开才能收到视频呼叫";
        }
 
        [downLabel sizeToFit];
        [self addSubview:downLabel];
        
        UILabel * rightLabel = [UILabel new];
        rightLabel.font = font;
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.text = @"立即开启 >";
        [rightLabel sizeToFit];
        [self addSubview:rightLabel];
        
        
        CGFloat totoalHeight = CGRectGetHeight(upLabel.frame)+CGRectGetHeight(downLabel.frame)+2;
        
        CGRect temp = upLabel.frame;
        temp.origin.x = CGRectGetMaxX(notifImgView.frame) +10;
        temp.origin.y = (LVDisturbFloatViewHeight - totoalHeight)/2;
        temp.size.width += 1;
        upLabel.frame = temp;
        
        temp = downLabel.frame;
        temp.origin.x = CGRectGetMinX(upLabel.frame);
        temp.origin.y = CGRectGetMaxY(upLabel.frame)+2;
        downLabel.frame = temp;
        
        temp = rightLabel.frame;
        temp.origin.x = UIScreenWidth - CGRectGetWidth(temp)-10;
        temp.origin.y = (LVDisturbFloatViewHeight - CGRectGetHeight(temp))/2;
        rightLabel.frame = temp;
        
        UITapGestureRecognizer * tapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lvDisturbClick:)];
        [self addGestureRecognizer:tapGestrue];
    }
    return self;
}


-(void)lvDisturbClick:(UITapGestureRecognizer *) gesture
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(lvDistrubViewClick)]){
        [self.delegate lvDistrubViewClick];
    }
}

@end


@interface UIViewController (disturbDelegate)<LVDisturbViewDelegate>

@end
@implementation UIViewController (LVFloatView)
-(void) showDisturbFloatView
{
    self.lvDisturbViewHeight = LVDisturbFloatViewHeight;
    
    LVDisturbView * disturbView = [self.view viewWithTag:LVDisturbViewTag];
    if(!disturbView){
        int topInterval = CGRectGetHeight(self.navigationController.navigationBar.frame)+[UIApplication sharedApplication].statusBarFrame.size.height;
        disturbView = [[LVDisturbView alloc] initWithFrame:CGRectMake(0, topInterval, UIScreenWidth, self.lvDisturbViewHeight)];
        disturbView.tag = LVDisturbViewTag;
        disturbView.delegate = self;
        [self.view addSubview:disturbView];
    }
}

-(void) hideDistrubFloatView
{
    self.lvDisturbViewHeight = 0;
    LVDisturbView * disturbView = [self.view viewWithTag:LVDisturbViewTag];
    if(disturbView){
        [disturbView removeFromSuperview];
        disturbView = nil;
    }
}

-(void) lvDirectOpenAcceptCall{
    [self lvDistrubViewClick];
}
#pragma mark - LVDisturbViewDelegate
 -(void) lvDistrubViewClick
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:ML_ViewDismissTime];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"正在设置"];
    __weak typeof(self) ws = self;
//    LVAcceptCallMsgRequest * setReq = [LVAcceptCallMsgRequest new];
//    setReq.callAccept = @"1";
//    [setReq LV_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nullable request, NSDictionary * _Nullable dic) {
//        NSNumber * codeNumber = dic[@"code"];
//        if(codeNumber && codeNumber.intValue == 0){
//            [SVProgressHUD showSuccessWithStatus:dic[@"info"]];
//        }else{
//            [SVProgressHUD dismiss];
//            [ws.view makeToast:dic[@"info"] duration:1.5 position:CSToastPositionCenter];
//        }
//        //更新本地缓存
//        [ws updateAcceptCallLocalCacheData];
//        extern NSString * LVDisturbFloatViewHideNotification;
//        [[NSNotificationCenter defaultCenter] postNotificationName:LVDisturbFloatViewHideNotification object:nil];
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//        [SVProgressHUD showErrorWithStatus:@"打开设置失败"];
//    }];

}

//-(void) updateAcceptCallLocalCacheData
//{
//    extern NSString * LVPushCacheKey;
//    NSString * userId = [ML_AppUserInfoManager sharedManager].currentLoginUserData.account;
//    NSDictionary * dic = [[ML_SDCacheManager sharedInstanceWithUserId:userId] objectForKey:LVPushCacheKey];
//    if([dic isKindOfClass:[NSDictionary class]] && [dic count]){
//        NSMutableDictionary * mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//        NSString * accept = @"1";
//     
//        if([mutableDic[@"data"] isKindOfClass:[NSDictionary class]] && [mutableDic[@"data"] count] ){
//            NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithDictionary:mutableDic[@"data"]];
//            dataDic[@"callaccept"] = accept;
//            mutableDic[@"data"] = dataDic;
//        }
//        NSString * userId = [ML_AppUserInfoManager sharedManager].currentLoginUserData.account;
//        [[ML_SDCacheManager sharedInstanceWithUserId:userId] setObject:mutableDic forKey:LVPushCacheKey];
//    }
//}

#pragma mark - getter & setter
-(void) setLvDisturbViewHeight:(NSInteger)lvDisturbViewHeight
{
    objc_setAssociatedObject(self, "mimilive.LVDisturbViewHeight", @(lvDisturbViewHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSInteger) lvDisturbViewHeight
{
    return [objc_getAssociatedObject(self, "mimilive.LVDisturbViewHeight") integerValue];
}
@end
