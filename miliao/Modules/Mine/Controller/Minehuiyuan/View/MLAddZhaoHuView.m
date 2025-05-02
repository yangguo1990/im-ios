//
//  MLAddZhaoHuView.m
//  miliao
//
//  Created by apple on 2022/10/13.
//

#import "MLAddZhaoHuView.h"
#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#import <Masonry/Masonry.h>

@interface MLAddZhaoHuView()<UITextViewDelegate>

@property(nonatomic,retain)UIView *alterView;

@property(nonatomic,retain)UILabel *titleLb;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,strong)UIView *databgview;
@property(nonatomic,strong)UILabel *contentlabel;
@property(nonatomic,strong)UILabel *namelabel;

@property(nonatomic,strong)UILabel *indextitlelabel;
@property(nonatomic,strong)UILabel *phonelabel;
@property(nonatomic,strong)UILabel *addresslabel;
@property(nonatomic,strong)UILabel *timerlabel;
@property(nonatomic,strong)UIButton *lookbtn;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,copy)NSString *textssss;

@end

@implementation MLAddZhaoHuView

-(instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        
        UILabel *namelabel = [[UILabel alloc]init];
        namelabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
        namelabel.textColor = [UIColor colorWithHexString:@"#333333"];
        namelabel.text = @"添加招呼语";
        [self addSubview:namelabel];
        
        UILabel *contentlabel = [[UILabel alloc]init];
        contentlabel.text = @"30";
        contentlabel.font = [UIFont systemFontOfSize:11.0 weight:UIFontWeightRegular];
        contentlabel.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:contentlabel];
        self.contentlabel = contentlabel;

        UILabel *indextitlelabel = [[UILabel alloc]init];
        indextitlelabel.text = @"0/";
        indextitlelabel.font = [UIFont systemFontOfSize:11.0 weight:UIFontWeightRegular];
        indextitlelabel.textColor = [UIColor blackColor];
        [self addSubview:indextitlelabel];
        self.indextitlelabel = indextitlelabel;
        
        UIView *lineview = [[UIView alloc]init];
        lineview.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        [self addSubview:lineview];
        
        UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelbtn setTitle:Localized(@"取消", nil) forState:UIControlStateNormal];
        cancelbtn.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [cancelbtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        cancelbtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [cancelbtn addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelbtn];
        
        UIButton *lookbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lookbtn setTitle:Localized(@"确定", nil) forState:UIControlStateNormal];
        lookbtn.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [lookbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        lookbtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [lookbtn addTarget:self action:@selector(lookclick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:lookbtn];
        self.lookbtn = lookbtn;
        
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(25);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];

        [contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(namelabel.mas_bottom).mas_offset(3);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];

        [indextitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentlabel.mas_centerY);
            make.right.mas_equalTo(contentlabel.mas_left);
        }];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentlabel.mas_bottom).mas_offset(6);
            make.right.mas_equalTo(self.mas_right).mas_offset(-16);
            make.left.mas_equalTo(self.mas_left).mas_offset(16);
            make.height.mas_equalTo(1);
        }];
        
        [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
            make.right.mas_equalTo(self.mas_centerX).mas_offset(-0.5);
            make.left.mas_equalTo(self.mas_left).mas_offset(0);
            make.height.mas_equalTo(60);
        }];
        
        [lookbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
            make.right.mas_equalTo(self.mas_right).mas_offset(0);
            make.left.mas_equalTo(self.mas_centerX).mas_offset(0.5);
            make.height.mas_equalTo(60);
        }];

        UITextView *textView =[[UITextView alloc]init];
        textView.text = @"请输入你的常用招呼语";
        textView.textColor =  [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
        textView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        textView.delegate = self;
        [self addSubview:textView];
        self.textView = textView;
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_offset(27);
            make.top.mas_equalTo(lineview.mas_bottom).mas_offset(2);
            make.right.mas_equalTo(self.mas_right).mas_offset(-27);
            make.bottom.mas_equalTo(cancelbtn.mas_top).mas_offset(-2);
        }];
     }
    return self;
}


+(instancetype)alterVietextviewStrblock:(textviewStrBlock)textviewStrblock
                      sureBtClcik:(sureBlock)sureBlock
                      cancelClick:(cancelBlock)cancelBlock{
            MLAddZhaoHuView *alterView=[[MLAddZhaoHuView alloc]initWithFrame:CGRectMake(0, 0, WIDTH-80, 200)];
            alterView.backgroundColor = [UIColor whiteColor];
            alterView.center = CGPointMake(WIDTH/2, HEIGHT/2);
            alterView.layer.cornerRadius = 16;
            alterView.layer.masksToBounds=YES;
            alterView.textviewStrblock = textviewStrblock;
            alterView.sure_block=sureBlock;
            alterView.cancel_block = cancelBlock;
            return alterView;
}



#pragma mark--给属性重新赋值

-(void)setContent:(NSString *)content{
    _contentlabel.text = content;
}

-(void)setTitleLb:(UILabel *)titleLb{
    self.namelabel.text = self.titleLb.text;
}

-(void)setNamelabel:(UILabel *)namelabel{
    _namelabel.text = namelabel.text;
}



#pragma mark----确定按钮点击事件
-(void)cancelclick{
    [self removeFromSuperview];
     self.cancel_block();
}

-(void)lookclick{
    NSLog(@"hehheheh");
    [self removeFromSuperview];
    self.textviewStrblock(self.textssss);
    self.sure_block();
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"请输入你的常用招呼语"]){
        textView.text=@"";
        textView.textColor =  [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    }
    NSLog(@"DidBeginE--------%@",textView.text);
}

- (void)textViewDidChange:(UITextView *)textView{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
   //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    if (textView.text.length > 30) {
        textView.text = [textView.text substringToIndex:30];
    }else {
    }
    self.indextitlelabel.text = [NSString stringWithFormat:@"%zd/",(unsigned long)textView.text.length];
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    if(textView.text.length < 1){
        textView.text = @"请输入你的常用招呼语";
        textView.textColor =  [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    }
    NSLog(@"dEndEditi--------%@",textView.text);
    self.textssss = textView.text;
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
