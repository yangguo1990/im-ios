//
//  LVSessionCustomTipsContentView.m
//  SiMiZhiBo
//
//  Created by 史贵岭 on 2017/12/17.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import "LVSessionCustomTipsContentView.h"

#import "ML_CustomTipsAttachment.h"
#import "UIView+NTES.h"
#import "M80AttributedLabel+NIMKit.h"
#import "NIMMessageModel.h"
#import "NIMGlobalMacro.h"
#import "ML_TagParse.h"
#import "UIImageView+WebCache.h"


@interface LVSessionCustomTipsContentView()<M80AttributedLabelDelegate>
{
    UIView * _bgView;
    UIView * _contentView;
    UIImageView * _leftImageView;
}
@end

@implementation LVSessionCustomTipsContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        
        _bgView = [UIView new];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 8;
        _bgView.alpha = 0.2;
        _bgView.backgroundColor = [UIColor blackColor];
        [self addSubview:_bgView];
    

        _textLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _textLabel.delegate = self;
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        
        _leftImageView = [UIImageView new];
        _leftImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_leftImageView];
     
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data{
    [super refresh:data];
    NSString *text = @"未知消息";
    NIMCustomObject *customObject = (NIMCustomObject*)data.message.messageObject;
    ML_CustomTipsAttachment* textAttach = (ML_CustomTipsAttachment*)customObject.attachment;
    if([textAttach isKindOfClass:[ML_CustomTipsAttachment class]]){
        NSString * textMsg = textAttach.msg;
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
        self.textLabel.font = setting.font;
        [self.textLabel nim_setText:textMsg];
        //增加链接
        for(int i = 0; i< rangResult.count;i++){
            [self.textLabel addCustomLink:urlResult[i] forRange:NSRangeFromString(rangResult[i])];
        }
        
        if([textAttach isKindOfClass:[ML_CustomTipsAttachment class]]){
            if([textAttach.iconDic isKindOfClass:[NSDictionary class]]){
                [_leftImageView sd_setImageWithURL:[NSURL URLWithString:textAttach.iconDic[@"url"]?:@""]];
            }
        }
    }else{
        NIMMessage * textMessage = [NIMMessage new];
        NIMKitSetting *setting = [[NIMKit sharedKit].config setting:textMessage];
        self.textLabel.font = setting.font;
        [self.textLabel nim_setText:text];
    }
    
   
}

- (void)layoutSubviews{
    [super layoutSubviews];
   // UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGFloat tableViewWidth = self.superview.width;
    CGSize contentSize = [self.model contentSize:tableViewWidth];
    
    CGFloat bubbleLeftToContent  = 14;
    CGFloat contentRightToBubble = 14;
    CGFloat imgLeftInterval = 4;
    
    int imgWidth = 0;
    int imgHeight = 0;
    int imgAndTextInterval = 0;
    NIMCustomObject *customObject = (NIMCustomObject*)self.model.message.messageObject;
    ML_CustomTipsAttachment* textAttach = (ML_CustomTipsAttachment*)customObject.attachment;
    if([textAttach isKindOfClass:[ML_CustomTipsAttachment class]]){
        if([textAttach.iconDic isKindOfClass:[NSDictionary class]]){
            imgWidth = [textAttach.iconDic[@"w"] intValue];
            imgHeight = [textAttach.iconDic[@"h"] intValue];
            [_leftImageView sd_setImageWithURL:[NSURL URLWithString:textAttach.iconDic[@"url"]?:@""]];
            imgAndTextInterval = 5;
            CGRect tempFrame = _leftImageView.frame;
            tempFrame.origin.y = (contentSize.height -imgHeight)/2;
            tempFrame.size.width = imgWidth;
            tempFrame.size.height = imgHeight;
            _leftImageView.frame = tempFrame;
        }
    }

    CGFloat msgBubbleMaxWidth    = (tableViewWidth -imgWidth-imgAndTextInterval- imgLeftInterval*2);
    CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
    CGSize size =  [self.textLabel sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
    CGRect labelFrame = self.textLabel.frame;
    labelFrame.size.width = size.width;
    labelFrame.size.height = size.height;
    labelFrame.origin.y = (contentSize.height - CGRectGetHeight(labelFrame))/2+2;
    self.textLabel.frame = labelFrame;
    
    CGRect bgFrame = CGRectMake(0, 0, imgLeftInterval*2+imgAndTextInterval+imgWidth+size.width, contentSize.height);
    bgFrame.origin.x = (tableViewWidth - bgFrame.size.width)/2;
    _bgView.frame = bgFrame;
    
    CGRect tempFrame = _leftImageView.frame;
    tempFrame.origin.x = imgLeftInterval+CGRectGetMinX(_bgView.frame);
    _leftImageView.frame = tempFrame;
    
    tempFrame = _textLabel.frame;
    tempFrame.origin.x = CGRectGetMaxX(_leftImageView.frame)+4;
    _textLabel.frame = tempFrame;
    
}

-(UIImage *) chatBubbleImageForState:(UIControlState)state outgoing:(BOOL)outgoing
{
    return nil;
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

