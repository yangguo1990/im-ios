//
//  LVCMDAttachment.m
//  LiveVideo
//
//  Created by 林必义 on 2017/5/20.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import "ML_GiftAttachment.h"
#import "M80AttributedLabel.h"
#import "M80AttributedLabel+NIMKit.h"
#import "LVSessionGiftContentView.h"
#import "LVGiftDescView.h"
#import "M80AttributedLabelAttachment.h"
#import "LDSGiftCellModel.h"

NSString * LVDefaultAnimateType = @"common";
NSString * LVMutiAnimateType = @"multi";
@interface ML_GiftAttachment ()
@property(nonatomic, nonnull,strong) M80AttributedLabel * label;
@property(nonatomic, nonnull,strong) UIImageView * giftImageview;
@property(nonatomic, nonnull,strong) LVGiftDescView * giftDescView;
@end
@implementation ML_GiftAttachment

- (NSString *)animationSrc
{
    if (!_animationSrc) {
        NSArray *giftArr = [ML_AppConfig sharedManager].giftArr;
        if (giftArr.count) {
            
            for (LDSGiftCellModel *model in giftArr) {
                if ([model.ID isEqualToString:_giftId]) {
                    _animationSrc = model.icon_gif;
                    break;
                }
            }
            
            return _animationSrc?:@"";
        } else {
            kplaceToast(@"礼物数据准备中。。。");
                ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"im/getGifts"];
                kSelf;
                [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                    
                    
                    NSMutableArray *muArr = [NSMutableArray array];

                    for (NSDictionary *dic in response.data[@"gifts"]) {
                        LDSGiftCellModel *gift = [LDSGiftCellModel mj_objectWithKeyValues:dic];
                        [muArr addObject:gift];
                    }
                    [ML_AppConfig sharedManager].giftArr = muArr;
                    
                    
                } error:^(MLNetworkResponse *response) {

                } failure:^(NSError *error) {
                    
                }];
            
            return @"";
        }
        
    } else {
        return _animationSrc;
    }
}

- (NSString *)encodeAttachment
{
    NSDictionary * dic = @{
                           CMType:@(CustomMessageTypeCMD),
                           LVInfo: @{
                               LVCMD:LVGiftCMD,
                               LVGiftFrom:_fromUserId?:@"",
                               LVGiftTo:_toUsersArray?:@[],
//                               LVForward:_forwardId?:@"",
                               LVNumber:_number?:@"1",
                               LVGiftProperties:
                                    @{
                                        LVAnimationSrc:_animationSrc?:@"",
                                       LVGiftId:_giftId?:@"",
                                       LVGiftName:_giftName?:@"",
                                       LVGiftSrc:_giftSrc?:@"",
                                       LVGiftMoney:_giftMoney?:@"",
                                       LVGiftAnimateType:_giftAnimateType?:@"",
                                    },
                               LVFromUserInfo:
                                   @{
                                       LVUserID :_fromUserId?:@"",
                                       LVNickName:_senderNickName?:@"",
                                       LVGender:_senderGender?:@"",
                                       LVWealth:_senderWealth?:@"",
                                       LVAvatar:_avatar?:@"",
                                    }
                             },
                              LVGiftMutiAccount:_mutliAmount?:@"1",
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic
                                                   options:0
                                                     error:nil];
    NSString *content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;

}

+(instancetype) initWithDic:(NSDictionary *) dic
{
    if(![dic count] ||[dic[CMType] integerValue] != CustomMessageTypeCMD)
    {
        return nil;
    }
    
    NSDictionary * info = dic[LVInfo];
    if(!info.count  ||![info[LVCMD] isEqualToString:LVGiftCMD] || ![info[LVGiftProperties] count]){
        return nil;
    }
    
    ML_GiftAttachment * attachment = [ML_GiftAttachment new];
    attachment.info = info;
    attachment.cmd = LVGiftCMD;
    attachment.fromUserId = info[LVGiftFrom];
    attachment.toUsersArray = info[LVGiftTo];
//    attachment.forwardId = info[LVForward];
    attachment.number = info[LVNumber];
    attachment.animationSrc = info[LVAnimationSrc];
    
    NSDictionary * giftDic = info[LVGiftProperties];
    attachment.giftId = giftDic[LVGiftId];
    attachment.giftName = giftDic[LVGiftName];
    attachment.giftSrc = giftDic[LVGiftSrc];
    attachment.giftMoney = giftDic[LVGiftMoney];
    NSDictionary * userInfoDic = info[LVFromUserInfo];
    attachment.senderGender = userInfoDic[LVGender];
    attachment.senderNickName = userInfoDic[LVNickName];
    attachment.senderWealth = userInfoDic[LVWealth];
    attachment.avatar = userInfoDic[LVAvatar];
    attachment.giftAnimateType = giftDic[LVGiftAnimateType];
    attachment.mutliAmount = info[LVGiftMutiAccount];
  
    
    return attachment;
}

- (NSString *)cellContent:(NIMMessage *)message
{
    return NSStringFromClass([LVSessionGiftContentView class]);
}


- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    NSString *text = @"未知礼物";
    
    NIMCustomObject *customObject = (NIMCustomObject*)message.messageObject;
    ML_GiftAttachment* giftAttach = (ML_GiftAttachment*)customObject.attachment;
    if([giftAttach isKindOfClass:[ML_GiftAttachment class]]){
        [self.giftDescView setGiftTitle:giftAttach.giftName count:giftAttach.number outGoing:message.isOutgoingMsg];
        [self.giftDescView descViewFitSize];
        
        self.label.attributedText =  [[NSMutableAttributedString alloc] init];
        if(message.isOutgoingMsg){
            
         [self.label appendView:self.giftImageview margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
         [self.label appendView:self.giftDescView margin:UIEdgeInsetsMake(0, 10, 0, 0) alignment:M80ImageAlignmentCenter];
            
            
        }else{
            [self.label appendView:self.giftDescView margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
            [self.label appendView:self.giftImageview margin:UIEdgeInsetsMake(0, 10, 0, 0) alignment:M80ImageAlignmentCenter];
        }

    }else{
        NIMMessage * textMessage = [NIMMessage new];//采用text文本模拟显示样式
        NIMKitSetting *setting = [[NIMKit sharedKit].config setting:textMessage];
        self.label.font = setting.font;
        [self.label nim_setText:text];
    }
    
    [self.label sizeToFit];
    
    CGFloat msgBubbleMaxWidth    = (width - 130);
    CGFloat bubbleLeftToContent  = 14;
    CGFloat contentRightToBubble = 14;
    CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
    CGSize size =  [self.label sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
    
    return size;

}


- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    NIMMessage * textMessage = [NIMMessage new];
    NIMKitSetting *setting = [[NIMKit sharedKit].config setting:textMessage];
    return setting.contentInsets;
}


- (M80AttributedLabel *)label
{
    if (_label) {
        return _label;
    }
    _label = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
    _label.lineSpacing = NSLineBreakByWordWrapping;
    _label.numberOfLines = 0;
    return _label;
}

-(UIImageView *) giftImageview
{
    if(_giftImageview){
        return _giftImageview;
    }
    _giftImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    return _giftImageview;
}

-(LVGiftDescView *) giftDescView
{
    if(_giftDescView){
        return _giftDescView;
    }
    
    _giftDescView = [LVGiftDescView new];
    return _giftDescView;
}
@end
