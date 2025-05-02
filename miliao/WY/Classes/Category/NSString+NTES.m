//
//  NSString+NTES.m
//  NIMDemo
//
//  Created by chris on 15/2/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NSString+NTES.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (NTES)

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (CGSize)stringSizeWithFont:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (NSString *)MD5String {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


- (NSUInteger)getBytesLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self lengthOfBytesUsingEncoding:enc];
}


- (NSString *)stringByDeletingPictureResolution{
    NSString *doubleResolution  = @"@2x";
    NSString *tribleResolution = @"@3x";
    NSString *fileName = self.stringByDeletingPathExtension;
    NSString *res = [self copy];
    if ([fileName hasSuffix:doubleResolution] || [fileName hasSuffix:tribleResolution]) {
        res = [fileName substringToIndex:fileName.length - 3];
        if (self.pathExtension.length) {
           res = [res stringByAppendingPathExtension:self.pathExtension];
        }
    }
    return res;
}

- (NSString *)tokenByPassword
{
    //demo直接使用username作为account，md5(password)作为token
    //接入应用开发需要根据自己的实际情况来获取 account和token
    return @"";
}

- (NSString *)ntes_localized {
    return Localized(self, nil);
}

+ (NSString *)randomStringWithLength:(NSUInteger)length {
    if (length == 0) {
        return @"";
    }
    NSString *ret = @"";
    while (ret.length < length) {
        NSString *append = @(arc4random()).stringValue;
        ret = [ret stringByAppendingString:append];
    }
    ret = [ret substringToIndex:length];
    
    return ret;
}


/**

* 计算文字高度，可以处理计算带行间距的

*/- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing{

    NSMutableAttributedString*attributeString = [[NSMutableAttributedString alloc] initWithString:self];

    NSMutableParagraphStyle*paragraphStyle = [[NSMutableParagraphStyle alloc] init];    paragraphStyle.lineSpacing = lineSpacing;

      [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,self.length)];

     [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,self.length)];

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];//    NSLog(@"size:%@", NSStringFromCGSize(rect.size));

    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行

    if((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {

    if([self containChinese:self]) {//如果包含中文

    rect =CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);        }    }

    return rect.size;
}


//判断如果包含中文
- (BOOL)containChinese:(NSString*)str

{

  for(int i=0; i< [str length];i++){
    int a = [str characterAtIndex:i];
     if( a >0x4e00&& a <0x9fff)
    {
      return  YES;

     }

 }

      return  NO;

}

/**

*  计算最大行数文字高度,可以处理计算带行间距的

*/
- (CGFloat)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines{
      if(maxLines <=0) {return  0;    }
      CGFloat maxHeight = font.lineHeight * maxLines + lineSpacing *       (maxLines -1);
      CGSize orginalSize = [self boundingRectWithSize:size font:font   lineSpacing:lineSpacing];
      if( orginalSize.height >= maxHeight ) {
      return maxHeight;
  }else{
      return orginalSize.height;
  }
}

/**

*  计算是否超过一行  用于给Label 赋值attribute text的时候 超过一行设置lineSpace

*/
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont*)font lineSpaceing:(CGFloat)lineSpacing{

  if( [self boundingRectWithSize:size font:font lineSpacing:lineSpacing].height     > font.lineHeight  ){
      return YES;
     }else{
         return NO;
      }
}

- (CGSize)sizeWithLabelWidth:(CGFloat)width font:(UIFont *)font{
    NSDictionary *dict=@{NSFontAttributeName : font};
    CGRect rect=[self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dict context:nil];
    CGFloat sizeWidth=ceilf(CGRectGetWidth(rect));
    CGFloat sizeHieght=ceilf(CGRectGetHeight(rect));
    return CGSizeMake(sizeWidth, sizeHieght);
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
