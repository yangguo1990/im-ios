

#import "ML_CustomTextAttachment.h"
#import "LVSessionCustomTextContentView.h"
#import "ML_TagParse.h"
#import "M80AttributedLabel+NIMKit.h"

@interface ML_CustomTextAttachment ()
@property(nonatomic, nonnull,strong) M80AttributedLabel * label;
@end

@implementation ML_CustomTextAttachment

- (NSString *)encodeAttachment
{
    NSDictionary * dic = @{
                           CMType:@(CustomMessageTypeCMD),
                           LVInfo: @{
                                   LVCMD:LVTextCMD,
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
    if(!info.count  ||![info[LVCMD] isEqualToString:LVTextCMD] ){
        return nil;
    }
    
    ML_CustomTextAttachment * attachment = [ML_CustomTextAttachment new];
    attachment.info = info;
    attachment.cmd = LVTextCMD;
    attachment.msg = info[LVMsg];
    
    return attachment;
}

- (NSString *)cellContent:(NIMMessage *)message
{
    return NSStringFromClass([LVSessionCustomTextContentView class]);
}


- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    NSString *text = @"未知消息";
    
    NIMCustomObject *customObject = (NIMCustomObject*)message.messageObject;
    ML_CustomTextAttachment* textAttach = (ML_CustomTextAttachment*)customObject.attachment;
    if([textAttach isKindOfClass:[ML_CustomTextAttachment class]]){
        text = [self generateCustomTextByAttach:textAttach];
    }
    NIMMessage * textMessage = [NIMMessage new];
    NIMKitSetting *setting = [[NIMKit sharedKit].config setting:textMessage];
    self.label.font = setting.font;
    [self.label nim_setText:text];
    
    
    
    CGFloat msgBubbleMaxWidth    = (width - 130);
    CGFloat bubbleLeftToContent  = 14;
    CGFloat contentRightToBubble = 14;
    CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
    return [self.label sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
}


-(NSString *) generateCustomTextByAttach:(ML_CustomTextAttachment *) textAttach
{
    if([textAttach isKindOfClass:[ML_CustomTextAttachment class]]){
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

@end
