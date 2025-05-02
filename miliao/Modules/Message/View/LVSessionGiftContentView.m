//
//  LVSessionGiftContentView.m
//  LiveVideo
//
//  Created by 史贵岭 on 2017/5/21.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import "LVSessionGiftContentView.h"
#import "ML_GiftAttachment.h"
#import "UIView+NTES.h"
#import "NIMSessionTextContentView.h"
#import "M80AttributedLabel+NIMKit.h"
#import "NIMMessageModel.h"
#import "NIMGlobalMacro.h"
#import "LVGiftDescView.h"
#import "LVRollingScreenView.h"

@interface LVSessionGiftContentView()<M80AttributedLabelDelegate>
{
    UIImageView * _lvGiftImgView;
    LVGiftDescView * _giftDescView;
}
@property (strong, nonatomic)NIMCustomObject *customObject;
@end

@implementation LVSessionGiftContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        _textLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _textLabel.delegate = self;
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        
        _lvGiftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
        _lvGiftImgView.userInteractionEnabled = YES;
        _lvGiftImgView.contentMode = UIViewContentModeScaleAspectFill;
        [_lvGiftImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lvGiftImgViewTap:)]];
        
        _giftDescView = [[LVGiftDescView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];//[LVGiftDescView new];
    }
    return self;
}

- (void)lvGiftImgViewTap:(UIGestureRecognizer *)gr
{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDing_gift"] boolValue]) {
        kplaceToast(@"操作频发，请稍等！");
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDing_gift"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isDingGift" object:nil];
        
        ML_GiftAttachment* giftAttach = self.customObject.attachment;
        
        LDSGiftModel *giftModel = [[LDSGiftModel alloc] init];
        giftModel.giftGifImage = giftAttach.animationSrc;
        
        [[LVRollingScreenView sharedRollingScreenView] startShowGiftViewWithBigGiftModel:giftModel];
    }
}

- (void)refresh:(NIMMessageModel *)data{
    [super refresh:data];
    NSString *text = @"未知礼物";
    NIMCustomObject *customObject = (NIMCustomObject*)data.message.messageObject;
    self.customObject = customObject;
    ML_GiftAttachment* giftAttach = (ML_GiftAttachment*)customObject.attachment;
    
    if([giftAttach isKindOfClass:[ML_GiftAttachment class]]){
        //为头像和描述赋值
        UIImage * defaultImg = [UIImage imageNamed:@"lv_gift_default"];
        NSString * url = giftAttach.giftSrc;
        [_lvGiftImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:defaultImg options:SDWebImageRetryFailed];
        
        [_giftDescView setGiftTitle:giftAttach.giftName count:giftAttach.number outGoing:data.message.isOutgoingMsg];
        [_giftDescView descViewFitSize];
        
        _textLabel.attributedText = [[NSMutableAttributedString alloc] init];
        if(data.message.isOutgoingMsg ){
            [_textLabel appendView:_lvGiftImgView margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
            [_textLabel appendView:_giftDescView margin:UIEdgeInsetsMake(0, 3, 0, 0) alignment:M80ImageAlignmentCenter];
  
        }else{
            [_textLabel appendView:_giftDescView margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
            [_textLabel appendView:_lvGiftImgView margin:UIEdgeInsetsMake(0, 3, 0, 0) alignment:M80ImageAlignmentCenter];
        }
    }else{
        NIMMessage * textMessage = [NIMMessage new];//采用text文本模拟显示样式
        NIMKitSetting *setting = [[NIMKit sharedKit].config setting:textMessage];
        if(data.message.isOutgoingMsg){
            self.textLabel.textColor = [UIColor colorWithHexString:@"#A86F73"];
        }else{
            self.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        }
        
        self.textLabel.font = setting.font;
        [self.textLabel nim_setText:text];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGFloat tableViewWidth = self.superview.width;
    CGSize contentSize = [self.model contentSize:tableViewWidth];
    CGRect labelFrame = CGRectMake(contentInsets.left, contentInsets.top, contentSize.width, contentSize.height);
    self.textLabel.frame = labelFrame;
}


#pragma mark - M80AttributedLabelDelegate
- (void)m80AttributedLabel:(M80AttributedLabel *)label
             clickedOnLink:(id)linkData{
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventNameTapLabelLink;
    event.messageModel = self.model;
    event.data = linkData;
    [self.delegate onCatchEvent:event];
}

@end
