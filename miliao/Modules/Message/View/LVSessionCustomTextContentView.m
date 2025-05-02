//
//  LVSessionCustomTextContentView.m
//  LiveVideo
//
//  Created by 林必义 on 2017/6/22.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import "LVSessionCustomTextContentView.h"

#import "ML_CustomTextAttachment.h"
#import "UIView+NTES.h"
#import "NIMSessionTextContentView.h"
#import "M80AttributedLabel+NIMKit.h"
#import "NIMMessageModel.h"
#import "NIMGlobalMacro.h"
#import "ML_TagParse.h"


@interface LVSessionCustomTextContentView()<M80AttributedLabelDelegate>

@end

@implementation LVSessionCustomTextContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        _textLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _textLabel.delegate = self;
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data{
    [super refresh:data];
    NSString *text = @"未知消息";
    NIMCustomObject *customObject = (NIMCustomObject*)data.message.messageObject;
    ML_CustomTextAttachment* textAttach = (ML_CustomTextAttachment*)customObject.attachment;
    if([textAttach isKindOfClass:[ML_CustomTextAttachment class]]){
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

        
    }else{
        NIMMessage * textMessage = [NIMMessage new];
        NIMKitSetting *setting = [[NIMKit sharedKit].config setting:textMessage];
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

