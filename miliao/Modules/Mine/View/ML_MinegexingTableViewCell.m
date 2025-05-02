//
//  ML_MinegexingTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/15.
//

#import "ML_MinegexingTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>

@interface ML_MinegexingTableViewCell()<UITextViewDelegate>

@end

@implementation ML_MinegexingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self setuplayout];
    }
    return self;
}

-(void)setupUI{

    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = Localized(@"个性签名", nil);
    titlelabel.font = [UIFont boldSystemFontOfSize:16];
    titlelabel.textColor = kGetColor(@"000000");
    titlelabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titlelabel];
    
    
      UILabel *indextitlelabel = [[UILabel alloc]init];
      indextitlelabel.text = @"0/30";
      indextitlelabel.textColor = [UIColor colorWithHexString:@"#000000"];
    indextitlelabel.font = [UIFont boldSystemFontOfSize:16];
       indextitlelabel.textAlignment = NSTextAlignmentLeft;
       [self.contentView addSubview:indextitlelabel];
       self.indextitlelabel = indextitlelabel;
    
    UITextView *textView =[[UITextView alloc]init];
    textView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    textView.layer.cornerRadius = 12*mWidthScale;
    textView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    textView.textColor = [UIColor colorFromHexString:@"#666666"];
    textView.text = Localized(@"请输入内容", nil);
    textView.textColor =  [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];;
    textView.delegate = self;
    [self.contentView addSubview:textView];
    self.textView = textView;
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(13);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(32);
     }];
    
    [indextitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titlelabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(titlelabel.mas_centerY);
    }];

    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titlelabel.mas_left).mas_offset(0);
        make.top.mas_equalTo(titlelabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-13);
        make.height.mas_equalTo(48);
    }];
    

}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:Localized(@"请输入内容", nil)]){
        textView.text=@"";
        textView.textColor =  [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    }
    NSLog(@"DidBeginE--------%@",textView.text);
}



- (void)textViewDidEndEditing:(UITextView *)textView{
    if(textView.text.length < 1){
        textView.text = Localized(@"请输入内容", nil);
        textView.textColor =  [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    }
    NSLog(@"dEndEditi--------%@",textView.text);
    //self.textStr = textView.text;
}


- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length > 30) {
        
        NSRange r = NSMakeRange(0, 30);
        textView.text = [textView.text substringWithRange:r];
        
        return;
    }
    else
    {
        self.indextitlelabel.text = [NSString stringWithFormat:@"%ld/30", textView.text.length];
    }
    self.textviewStrBlock(textView.text);
}

- (void)setuplayout {
//    self.contentView.layer.cornerRadius = 10.0f;
//    self.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor clearColor];
    //[self.img setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 0)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.liveV.frame = CGRectMake(20, 99, ML_ScreenWidth - 40, 1);
    
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //如果是删除减少字数，都返回允许修改
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (range.location>= 30)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


@end


