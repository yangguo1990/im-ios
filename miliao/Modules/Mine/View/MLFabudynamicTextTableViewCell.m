//
//  MLFabudynamicTextTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLFabudynamicTextTableViewCell.h"
#import <Masonry.h>
#import <Colours/Colours.h>
#import "UITextView+ML.h"
@interface MLFabudynamicTextTableViewCell()<UITextViewDelegate>

@end

@implementation MLFabudynamicTextTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        
    }
    return self;
}

-(void)setupUI{
    
    UIView *lineview = [[UIView alloc]init];
    lineview.backgroundColor = [UIColor colorFromHexString:@"#F7F7F7"];
    [self.contentView addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *indextitlelabel = [[UILabel alloc]init];
    indextitlelabel.text = @"0/200";
    indextitlelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    // titlelabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
     //titlelabel.textColor = setcolor(3, 8, 26, 1);
     indextitlelabel.textAlignment = NSTextAlignmentLeft;
     [self.contentView addSubview:indextitlelabel];
     self.indextitlelabel = indextitlelabel;
    [indextitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
    }];
    
    UITextView *textView =[[UITextView alloc]init];
    textView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    textView.wzb_placeholder = Localized(@"给大家介绍一下吧~", nil);
    textView.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    textView.textColor = [UIColor colorWithHexString:@"#333333"];
    textView.delegate = self;
    [self.contentView addSubview:textView];
    self.textView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        make.top.mas_equalTo(lineview.mas_bottom).mas_offset(16);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(indextitlelabel.mas_top).mas_offset(-5);
    }];
    
        
    
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
   //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }else {
    }
    self.indextitlelabel.text = [NSString stringWithFormat:@"%zd/200",(unsigned long)textView.text.length];
}


- (void)textViewDidEndEditing:(UITextView *)textView{

    self.textviewStrBlock(textView.text);
}



- (void)layoutSubviews {
    [super layoutSubviews];
    //self.contentView.frame = CGRectInset(self.bounds, 16, 0);
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //如果是删除减少字数，都返回允许修改
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (range.location>= 200)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


@end


