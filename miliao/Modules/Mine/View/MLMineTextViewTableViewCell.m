//
//  MLMineTextViewTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/19.
//

#import "MLMineTextViewTableViewCell.h"
#import <Masonry.h>

@interface MLMineTextViewTableViewCell()<UITextViewDelegate>
@property (nonatomic,strong)UITextView *textView;

@end

@implementation MLMineTextViewTableViewCell

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
    titlelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
   // titlelabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    //titlelabel.textColor = setcolor(3, 8, 26, 1);
    titlelabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titlelabel];
    //self.titlelabel = titlelabel;
    
    
      UILabel *indextitlelabel = [[UILabel alloc]init];
      indextitlelabel.text = @"0/30";
    indextitlelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
      // titlelabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
       //titlelabel.textColor = setcolor(3, 8, 26, 1);
       indextitlelabel.textAlignment = NSTextAlignmentLeft;
       [self.contentView addSubview:indextitlelabel];
       self.indextitlelabel = indextitlelabel;
    
    UITextView *textView =[[UITextView alloc]init];
    textView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    textView.layer.cornerRadius = 5;
    textView.text = Localized(@"请输入内容", nil);
    textView.textColor =  [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];;
    textView.delegate = self;
    [self.contentView addSubview:textView];
    self.textView = textView;
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10);
     }];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(0);
        make.top.mas_equalTo(titlelabel.mas_bottom).mas_offset(4);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [indextitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titlelabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(titlelabel.mas_centerY);
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

- (void)textViewDidChange:(UITextView *)textView{
    
     self.indextitlelabel.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)textView.text.length];
     self.textviewStrBlock(textView.text);
    
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if(textView.text.length < 1){
        textView.text = Localized(@"请输入内容", nil);
        textView.textColor =  [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    }
    NSLog(@"dEndEditi--------%@",textView.text);
    //self.textStr = textView.text;
}

- (void)setuplayout {
    self.contentView.layer.cornerRadius = 10.0f;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    //[self.img setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 0)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = CGRectInset(self.bounds, 15, 0);
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


