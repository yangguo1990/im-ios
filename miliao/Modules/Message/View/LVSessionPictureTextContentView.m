//
//  LVSessionPictureTextContentView.m
//  LiveVideo
//
//  Created by 史贵岭 on 2017/11/11.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import "LVSessionPictureTextContentView.h"
#import "ML_TagParse.h"
#import "M80AttributedLabel+NIMKit.h"
#import "LVPictureTextMsgView.h"
#import "ML_PictureTextAttachment.h"
#import "UIImage+NTESColor.h"
#import "UIView+NTES.h"

@interface  LVSessionPictureTextContentView()<M80AttributedLabelDelegate>
{
    LVPictureTextMsgView * _textMsgView;
    UIImageView * _pictureImgView;
}
@end

@implementation LVSessionPictureTextContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        _textLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _textLabel.delegate = self;
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        
        extern int LVPictureForIphone6;
         int width = (int) (LVPictureForIphone6 * UIScreenWidth /375.0);
        _pictureImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        _pictureImgView .contentMode = UIViewContentModeScaleAspectFit;
        _pictureImgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * imgTagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lvImgClick:)];
        [_pictureImgView addGestureRecognizer:imgTagGesture];
        
        _textMsgView = [LVPictureTextMsgView new];
        _textMsgView.label.delegate = self;
        
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data{
    [super refresh:data];
    NSString *text = @"未知消息";
    NIMCustomObject *customObject = (NIMCustomObject*)data.message.messageObject;
    ML_PictureTextAttachment* pictureTextAttach = (ML_PictureTextAttachment*)customObject.attachment;
    if([pictureTextAttach isKindOfClass:[ML_PictureTextAttachment class]]){
        //为头像和描述赋值
        UIImage * defaultImg = [UIImage imageWithColor:[UIColor colorWithHexString:@"#CCCCCC"]];
        NSString * url = pictureTextAttach.imgUrl;
        
        
        [_pictureImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:defaultImg options:SDWebImageRetryFailed];
        
        
        NSString * textMsg = pictureTextAttach.textMsg;
        NSMutableArray * rangResult = nil;
        NSMutableArray * urlResult = nil;
        
        rangResult = data.message.localExt[@"rangResult"];
        urlResult = data.message.localExt[@"urlResult"];
        if(!rangResult || urlResult)
        {
            
            NSArray * result = [ML_TagParse parseNTESTagText:textMsg];
            extern NSString * LVTagMatchString;
            extern NSString * LVTagLinkUrl;
            extern NSString * LVTagLinkText;
            if ([result count]) {
                rangResult = [NSMutableArray array];
                urlResult =  [NSMutableArray array];
                for (int i =0 ; i<[result count]; i++) {
                    NSDictionary *linkInfo = [result objectAtIndex:i];
                    
                    //根据匹配的tag标签重新搜索出第一个位置匹配的字符串的range，或者采用从后向前遍历不会造成range和要放的位置不匹配的问题
                    NSRange characterRange = [textMsg rangeOfString:[linkInfo objectForKey:LVTagMatchString]];
                    
                    textMsg = [textMsg stringByReplacingCharactersInRange:characterRange withString:[linkInfo objectForKey:LVTagLinkText]];
                    
                    NSRange range ;
                    range.location = characterRange.location;
                    range.length = [[linkInfo objectForKey:LVTagLinkText] length];
                    
                    [rangResult addObject:NSStringFromRange(range)];
                    [urlResult addObject:[linkInfo objectForKey:LVTagLinkUrl]];
                }
            }
            
            NSMutableDictionary * localExt = [NSMutableDictionary dictionary];
            if(data.message.localExt){
                [localExt addEntriesFromDictionary:data.message.localExt];
                localExt[@"rangResult"] = rangResult;
                localExt[@"urlResult"] = urlResult;
                data.message.localExt = localExt;
            }
        }
        
        NIMMessage * textMessage = [NIMMessage new];
         NIMKitSetting *setting = [[NIMKit sharedKit].config setting:textMessage];
        _textMsgView.label.font = setting.font;
        [_textMsgView.label nim_setText:textMsg];
        //增加链接
        for(int i = 0; i< rangResult.count;i++){
            [_textMsgView.label addCustomLink:urlResult[i] forRange:NSRangeFromString(rangResult[i])];
        }
        
        CGFloat tableViewWidth = self.superview.width;
        CGSize contentSize = [self.model contentSize:tableViewWidth];
        [_textMsgView pictureViewWithMaxWidth:contentSize.width-1];

        
        _textLabel.attributedText = [[NSMutableAttributedString alloc] init];
        
        [self.textLabel appendView:_textMsgView margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
        [self.textLabel appendView:_pictureImgView margin:UIEdgeInsetsMake(10, 0, 0, 0) alignment:M80ImageAlignmentCenter];
        
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


-(void) lvImgClick:(UITapGestureRecognizer *) gesture
{
    NIMCustomObject *customObject = (NIMCustomObject*)self.model.message.messageObject;
    ML_PictureTextAttachment* pictureTextAttach = (ML_PictureTextAttachment*)customObject.attachment;
    if([pictureTextAttach isKindOfClass:[ML_PictureTextAttachment class]]){
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = NIMKitEventNameTapLabelLink;
        event.messageModel = self.model;
        event.data = pictureTextAttach.imgHref;
        [self.delegate onCatchEvent:event];
    }
}
@end
