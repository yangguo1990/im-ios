//
//  ML_PictureTextAttachment.m
//  LiveVideo
//
//  Created by 林必义 on 2017/11/11.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import "ML_PictureTextAttachment.h"
#import "ML_TagParse.h"
#import "M80AttributedLabel+NIMKit.h"
#import "LVPictureTextMsgView.h"
#import "LVSessionPictureTextContentView.h"

const int LVPictureForIphone6  = 205;
@interface ML_PictureTextAttachment()
@property(nonatomic, nonnull,strong) M80AttributedLabel * label;
@property(nonatomic, nonnull,strong) UIImageView * pictureImageview;
@property(nonatomic, nonnull,strong) LVPictureTextMsgView * pictureText;
@end
@implementation ML_PictureTextAttachment

/*{
 "type":100,
 "info":{
 "cmd": "RICH_TEXT",
 +>  "msg": "文本消息支持tag标签",
 +>	"image": "图片url地址",
 +>	"href": "mimilive://videoplayer?url=http://xxxx/xx.mp4", // 点击图片的目标地址
 "userinfo"=> array(
 "userid"=> $userinfo['userid'],
 "nickname"=> $userinfo['nickname'],
 "gender"=> $userinfo['gender'],
 "wealth"=> $userinfo['tuhao']['level'],
 "vip" => "0", // 1=白钻，2=绿钻，3=黄钻
 ),
 }
 }*/

- (NSString *)encodeAttachment
{
    //由于本地不发送消息，所以userinfo辅助消息没有必要构造
    NSDictionary * dic = @{
                           CMType:@(CustomMessageTypeCMD),
                           LVInfo: @{
                                   LVCMD:LVPictureTextCMD,
                                   LVPictureTextMsg:_textMsg?:@"",
                                   LVPictureTextImg:_imgUrl?:@"",
                                   LVPictureTextHref:_imgHref?:@""
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
    if(![dic count] ||[dic[CMType] integerValue] != CustomMessageTypeCMD)
    {
        return nil;
    }
    
    NSDictionary * info = dic[LVInfo];
    if(!info.count  ||![info[LVCMD] isEqualToString:LVPictureTextCMD] ){
        return nil;
    }
    
    ML_PictureTextAttachment * attachment = [ML_PictureTextAttachment new];
    attachment.info = info;
    attachment.cmd = LVPictureTextCMD;
    attachment.textMsg = info[LVPictureTextMsg];
    attachment.imgHref = info[LVPictureTextHref];
    attachment.imgUrl = info[LVPictureTextImg];
    
    return attachment;
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    NSString *text = @"未知消息";
    
    CGFloat msgBubbleMaxWidth    = (width - 130);
    CGFloat bubbleLeftToContent  = 14;
    CGFloat contentRightToBubble = 14;
    CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
    
    NIMCustomObject *customObject = (NIMCustomObject*)message.messageObject;
    ML_PictureTextAttachment* pictureAttach = (ML_PictureTextAttachment*)customObject.attachment;
    if([pictureAttach isKindOfClass:[ML_PictureTextAttachment class]]){
        [self.pictureText setTextMsgContent:[self generateCustomTextByAttach:pictureAttach]];
        [self.pictureText pictureViewWithMaxWidth:msgContentMaxWidth];
        
        self.label.attributedText =  [[NSMutableAttributedString alloc] init];
        [self.label appendView:self.pictureText margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
        [self.label appendView:self.pictureImageview margin:UIEdgeInsetsMake(10, 0, 0, 0) alignment:M80ImageAlignmentCenter];
        
        //定位两个视图最大
        msgContentMaxWidth = MAX(CGRectGetWidth(self.pictureText.frame), CGRectGetWidth(self.pictureImageview.frame));
    }else{
        NIMMessage * textMessage = [NIMMessage new];//采用text文本模拟显示样式
        NIMKitSetting *setting = [[NIMKit sharedKit].config setting:textMessage];
        self.label.font = setting.font;
        [self.label nim_setText:text];
    }
   
    CGSize size =  [self.label sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
    
    return size;
    
}

- (NSString *)cellContent:(NIMMessage *)message
{
    return NSStringFromClass([LVSessionPictureTextContentView class]);
}


-(NSString *) lvVideoDownLoadUrl
{
    if([_imgHref isKindOfClass:[NSString class]] && _imgHref.length){
        NSString * playVideoPrefix = @"";
        NSArray * parseArray = [_imgHref componentsSeparatedByString:playVideoPrefix];
        if(parseArray.count == 2 && [parseArray.lastObject length]){
            return parseArray.lastObject;
        }
    }
    return nil;
}
- (BOOL)attachmentNeedsDownload
{
    
    if([self lvVideoDownLoadUrl].length){
        return YES;
    }
   
    return NO;
    
}

- (NSString *)attachmentURLStringForDownloading
{
    return [self lvVideoDownLoadUrl];
}

- (NSString *)attachmentPathForDownloading
{
    return [ML_AppUtil lvVideoLocalPathWithServerUrl:[self lvVideoDownLoadUrl]];
}

-(NSString *) generateCustomTextByAttach:(ML_PictureTextAttachment *) textAttach
{
    if([textAttach isKindOfClass:[ML_PictureTextAttachment class]]){
        NSString * textMsg = textAttach.textMsg;
        
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


-(UIImageView *) pictureImageview
{
    if(_pictureImageview){
        return _pictureImageview;
    }
    
    int width = (int) (LVPictureForIphone6 * UIScreenWidth /375.0);
    _pictureImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    return _pictureImageview;
}

-(LVPictureTextMsgView *) pictureText
{
    if(_pictureText){
        return _pictureText;
    }
    
    _pictureText = [LVPictureTextMsgView new];
    return _pictureText;
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
