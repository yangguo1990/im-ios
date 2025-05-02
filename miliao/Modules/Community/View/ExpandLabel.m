//
//  ExpandLabel.m
//  IosTemplate
//
//  Created by GuoliWang on 2019/12/10.
//  Copyright © 2019 GuoliWang. All rights reserved.
//


#import "ExpandLabel.h"
#import "YYText.h"


#define PackUpStr  @" 收起 "
#define ExpandStr  @"... 展开"
//字体
#define FONT(s)               [UIFont systemFontOfSize:(s)]
#define FONT_BOLD(s)          [UIFont boldSystemFontOfSize:(s)]

//按比例计算尺寸 设计稿是以750为基准  //  (size)*ScreenW/750
#define RATIO(size)      (size)/2.0


@interface ExpandLabel ()
/**  宽度  */
@property (nonatomic, assign) CGFloat yyLabelW;
/**  富文本数据  */
@property (nonatomic, readonly) NSAttributedString * textAtt;

/**  n行高度  */
@property (nonatomic, assign,readonly) CGFloat maxHeight;
/**  真实高度  */
@property (nonatomic, assign,readonly) CGFloat trueHeight;

/**  临时高度，增加收起字段  */
@property (nonatomic, copy) NSMutableAttributedString * tmpTextAtt;
@end
@implementation ExpandLabel


//设置数据
- (void)setExpandAtt:(NSString *)text YYLabelW:(CGFloat)YYLabelW MaxLineNum:(NSInteger)maxLineNum font:(UIFont*)font color:(UIColor *)color LineSpace:(CGFloat)lineSpace{
    
    self.numberOfLines = 0;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    
    if (lineSpace) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];

        [paragraphStyle setLineSpacing:lineSpace];

        [att addAttribute:NSParagraphStyleAttributeName

                              value:paragraphStyle

                              range:NSMakeRange(0, [text length])];
    }
    
    if (font) {
        att.yy_font = font;
    }
    
    if (color) {
        att.yy_color = color;
    }
    
    
    _textAtt =  att;
    
    _yyLabelW = YYLabelW;
    
    _tmpTextAtt = [_textAtt mutableCopy];
    
    [_tmpTextAtt appendAttributedString:[self appendAttriStringWithFont:font]];
    
    
    _maxHeight = [self getMaxNumHeight:maxLineNum];
    
    
    _trueHeight = [self getMaxNumHeight:0];
    
    self.attributedText = _textAtt;
    
    [self updateExpand];
}

- (void)updateExpand{
    if (_isExpand) {
        //展开后，尾部添加收起
        [self expandString];
        if (self.block) {
            self.block(_trueHeight);
        }
    }else{
        //收起后，尾部去除收起
        [self packUpString];
        
        //尾部添加展开
        self.truncationToken = [self getShowMoreAtt];
        
        if (self.block) {
            self.block(_maxHeight);
        }
    }
    
}

//获取高度
- (CGFloat)getMaxNumHeight:(NSInteger)maxNum{
       
   // Create attributed string.
   

   // Create text container
   YYTextContainer *container = [YYTextContainer new];
   container.size = CGSizeMake(_yyLabelW, CGFLOAT_MAX);
   container.maximumNumberOfRows = maxNum;
   
    
   // Generate a text layout.
    
    YYTextLayout * textLayout = [YYTextLayout layoutWithContainer:container text:maxNum== 0?self.tmpTextAtt:self.textAtt];
   
   
    //加5个像素，避免出现问题，容错处理
    return textLayout.textBoundingSize.height + RATIO(10);
}

//添加收起
- (NSAttributedString *)appendAttriStringWithFont:(UIFont *)font {
    if (!font) {
        font = [UIFont systemFontOfSize:RATIO(24)];
    }
    
    NSString *appendText = Localized(PackUpStr, nil);
    NSMutableAttributedString *append = [[NSMutableAttributedString alloc] initWithString:appendText attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : kZhuColor}];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [append yy_setTextHighlight:hi range:[append.string rangeOfString:appendText]];

    __weak typeof(self) weakSelf = self;
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
       
        //点击收起
        [weakSelf reloadNewFrame:NO];
        
         if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(ExpandLabelClickWei)]) {

             [weakSelf.delegate ExpandLabelClickWei];
         }
         
    };
    
    return append;
}

#pragma mark -- 尾部收起的添加和去除 --
//点击展开样式，尾部加收起
- (void)expandString {
    NSMutableAttributedString *attri = [_textAtt mutableCopy];
    [attri appendAttributedString:[self appendAttriStringWithFont:attri.yy_font]];
    self.attributedText = attri;
}

//点击收起样式，尾部去除收起
- (void)packUpString {
    NSString *appendText = Localized(PackUpStr, nil);
    NSMutableAttributedString *attri = [self.attributedText mutableCopy];
    NSRange range = [attri.string rangeOfString:appendText options:NSBackwardsSearch];

    if (range.location != NSNotFound) {
        [attri deleteCharactersInRange:range];
    }

    self.attributedText = attri;
}

#pragma mark --
- (NSAttributedString *)getShowMoreAtt{
    UIFont *font16 = _textAtt.yy_font;

    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:Localized(ExpandStr, nil)];
    
    NSRange expandRange = [text.string rangeOfString:Localized(ExpandStr, nil)];
    
    [text addAttribute:NSForegroundColorAttributeName value:kZhuColor range:expandRange];
    
//    NSRange dianRange = [text.string rangeOfString:@"..."];
//
//    [text addAttribute:NSForegroundColorAttributeName value:JHGrayColor1 range:dianRange];
//
    //添加点击事件
    YYTextHighlight *hi = [YYTextHighlight new];
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:Localized(ExpandStr, nil)]];
    
    __weak typeof(self) weakSelf = self;
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
       
        //点击展开
        [weakSelf reloadNewFrame:YES];
        
         if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(ExpandLabelClickWei)]) {

             [weakSelf.delegate ExpandLabelClickWei];
         }
         
    };
    
    text.yy_font = font16;
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentTop];
    
    return truncationToken;
}

#pragma mark -- 方法点击 --
- (void)reloadNewFrame:(BOOL)isExpand{
    _isExpand = isExpand;
    
    [self updateExpand];
}
@end
