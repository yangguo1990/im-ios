//
//  ML_CustomTipsAttachment.m
//  SiMiZhiBo
//
//  Created by 林必义 on 2017/12/17.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import "ML_CustomTipsAttachment.h"

#import "LVSessionCustomTipsContentView.h"
#import "ML_TagParse.h"
#import "M80AttributedLabel+NIMKit.h"

@interface ML_CustomTipsAttachment ()
@property(nonatomic, nonnull,strong) M80AttributedLabel * label;
@end
@implementation ML_CustomTipsAttachment

- (NSString *)encodeAttachment
{
    NSDictionary * dic = @{
                           CMType:@(CustomMessageTypeCMD),
                           LVInfo: @{
                                   LVCMD:LVTipsCMD,
                                   LVMsg:_msg?:@"",
                                   }
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
    if(![dic count])
    {
        return nil;
    }
    
    NSDictionary * info = dic[LVInfo];
    if(!info.count  ||![info[LVCMD] isEqualToString:LVTipsCMD] ){
        return nil;
    }
    
    ML_CustomTipsAttachment * attachment = [ML_CustomTipsAttachment new];
    attachment.info = info;
    attachment.cmd = LVTipsCMD;
    attachment.msg = info[LVMsg];
    attachment.iconDic =info[@"icon"];
    
    return attachment;
}

- (NSString *)cellContent:(NIMMessage *)message
{
    return NSStringFromClass([LVSessionCustomTipsContentView class]);
}


- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    NSString *text = @"未知消息";
    
    NIMCustomObject *customObject = (NIMCustomObject*)message.messageObject;
    ML_CustomTipsAttachment* textAttach = (ML_CustomTipsAttachment*)customObject.attachment;
    if([textAttach isKindOfClass:[ML_CustomTipsAttachment class]]){
        text = [self generateCustomTextByAttach:textAttach];
    }
    NIMMessage * textMessage = [NIMMessage new];
    NIMKitSetting *setting = [[NIMKit sharedKit].config setting:textMessage];
    self.label.font = setting.font;
    [self.label nim_setText:text];
    
    int imgWidth = 0;
    int imgHeight = 0;
    int imgAndTextInterval = 0;
    if([textAttach.iconDic isKindOfClass:[NSDictionary class]]){
        imgWidth = [textAttach.iconDic[@"w"] intValue];
        imgHeight = [textAttach.iconDic[@"h"] intValue];
        imgAndTextInterval = 5;
    }
    
    CGFloat bubbleLeftToContent  = 14;
    CGFloat contentRightToBubble = 14;
    CGFloat msgBubbleMaxWidth    = (width -imgWidth-imgAndTextInterval);
    CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
    CGSize size =  [self.label sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
    if(size.height < imgHeight){
        size.height = imgHeight;
    }
    
    return CGSizeMake(width-bubbleLeftToContent-contentRightToBubble, size.height);
}


-(NSString *) generateCustomTextByAttach:(ML_CustomTipsAttachment *) textAttach
{
    if([textAttach isKindOfClass:[ML_CustomTipsAttachment class]]){
        NSString * textMsg = textAttach.msg;
        
        NSArray * result = [ML_TagParse parseNTESTagText:textMsg];
        extern NSString * LVTagMatchString;
        extern NSString * LVTagLinkText;
        if ([result count]) {
            
            for (int i =0 ; i<[result count]; i++) {
                NSDictionary *linkInfo = [result objectAtIndex:i];
                
                //根据匹配的tag标签重新搜索出第一个位置匹配的字符串的range，或者采用从后向前遍历不会造成range和要放的位置不匹配的问题
                NSRange characterRange = [textMsg rangeOfString:[linkInfo objectForKey:LVTagMatchString]];
                
                textMsg = [textMsg stringByReplacingCharactersInRange:characterRange withString:[linkInfo objectForKey:LVTagLinkText]];
            }
        }
        return textMsg;
    }
    
    return @"未知消息";
    
}


- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    return UIEdgeInsetsZero;
}

- (BOOL)shouldShowAvatar:(NIMMessageModel *)model
{
    return NO;
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
@end
