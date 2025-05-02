//
//  MLNewestVersionShowView.m
//  miliao
//
//  Created by apple on 2022/11/14.
//

#import "MLNewestVersionShowView.h"
#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#import <Masonry/Masonry.h>

@interface MLNewestVersionShowView()<UITextViewDelegate>

@property(nonatomic,retain)UIView *alterView;

@property(nonatomic,retain)UILabel *titleLb;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,strong)UIView *databgview;
@property(nonatomic,strong)UILabel *contentlabel;
@property(nonatomic,strong)UILabel *namelabel;
@property(nonatomic,strong)UIButton *cancelbtn;
@property(nonatomic,strong)UILabel *indextitlelabel;
@property(nonatomic,strong)UILabel *phonelabel;
@property(nonatomic,strong)UILabel *addresslabel;
@property(nonatomic,strong)UILabel *timerlabel;
@property(nonatomic,strong)UIButton *lookbtn;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,copy)NSString *textssss;
@property (nonatomic,copy)NSString *phonestr;
@property (nonatomic,copy)NSString *phonenamestr;


@end

@implementation MLNewestVersionShowView

-(instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        
        UIView *bgview = [[UIView alloc]init];
        bgview.backgroundColor = UIColor.whiteColor;
        bgview.layer.cornerRadius = 20;
        bgview.layer.masksToBounds=YES;
        [self addSubview:bgview];
        [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(25);
            make.left.right.bottom.mas_equalTo(0);
        }];

        UIImageView *img = [[UIImageView alloc]init];
        img.image = [UIImage imageNamed:@"genban_bg"];
//        img.center = CGPointMake(WIDTH/2, HEIGHT/2 - 120);
        [self addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgview).mas_offset(-28);
            make.left.right.mas_equalTo(bgview);
            make.width.mas_equalTo(311);
            make.height.mas_equalTo(215);
        }];
        
        UILabel *namelabel = [[UILabel alloc]init];
        namelabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold];
        namelabel.textColor = [UIColor colorWithHexString:@"#333333"];
        //namelabel.text = @"v1.0.1版本更新通知";
        [bgview addSubview:namelabel];
        self.namelabel = namelabel;
        
        UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelbtn setTitle:@"残忍拒绝" forState:UIControlStateNormal];
        cancelbtn.backgroundColor = [UIColor clearColor];
        [cancelbtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        cancelbtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [cancelbtn addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:cancelbtn];
        self.cancelbtn = cancelbtn;
        
        UIButton *lookbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lookbtn setTitle:@"立即更新" forState:UIControlStateNormal];
        lookbtn.backgroundColor = [UIColor colorWithHexString:@"#ffe962"];
        [lookbtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        lookbtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [lookbtn addTarget:self action:@selector(lookclick) forControlEvents:UIControlEventTouchUpInside];
        lookbtn.layer.masksToBounds = YES;
        lookbtn.layer.cornerRadius = 24;
        [bgview addSubview:lookbtn];
        self.lookbtn = lookbtn;
        
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(img.mas_bottom).mas_offset(-20);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
            make.right.mas_equalTo(self.mas_right).mas_offset(-55);
            make.left.mas_equalTo(self.mas_left).mas_offset(55);
            make.height.mas_equalTo(48);
        }];
        
        [lookbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(cancelbtn.mas_top).mas_offset(0);
            make.right.mas_equalTo(cancelbtn.mas_right);
            make.left.mas_equalTo(cancelbtn.mas_left);
            make.height.mas_equalTo(48);
        }];

        
        UITextView *textView =[[UITextView alloc]init];
        textView.backgroundColor = [UIColor whiteColor];
        //NSString *info_str =[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",strA,strB,strC,strD,strE,strF,strG,strH,strI,strJ];
        textView.editable = NO;
        //textView.text = info_str;
        textView.text = @"1、优化页面操作流畅性\n2、修复了H5交互问题 \n3、新增了特质功能";
        textView.delegate = self;
        [self addSubview:textView];
        self.textView = textView;
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_offset(18);
            make.top.mas_equalTo(namelabel.mas_bottom).mas_offset(16);
            make.right.mas_equalTo(self.mas_right).mas_offset(-18);
            make.bottom.mas_equalTo(lookbtn.mas_top).mas_offset(-16);
        }];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3;// 字体的行间距
        NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium],NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#666666"],
        NSParagraphStyleAttributeName:paragraphStyle
        };
        textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
        self.textView = textView;

        
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing= 5;
//        NSDictionary*attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle};
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textView.text attributes:attributes];
//        [attributedString addAttribute:NSLinkAttributeName value:@"one://" range:NSMakeRange(strA.length,strB.length)];
//        [attributedString addAttribute:NSLinkAttributeName value:@"two://" range:NSMakeRange(strA.length+strB.length+strC.length ,strD.length)];
//        [attributedString addAttribute:NSLinkAttributeName value:@"three://" range:NSMakeRange(strA.length+strB.length+strC.length+strD.length+strE.length,strF.length)];
//      [attributedString addAttribute:NSLinkAttributeName value:@"four://" range:NSMakeRange(strA.length+strB.length+strC.length+strD.length+strE.length+strF.length,strG.length)];
//        [attributedString addAttribute:NSLinkAttributeName value:@"five://" range:NSMakeRange(strA.length+strB.length+strC.length+strD.length+strE.length+strF.length+strG.length+strH.length,strI.length)];
//        self.textView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]};
//        self.textView.attributedText= attributedString;
        
     }
    return self;
}

+(instancetype)alterVietextview:(NSString *)textview must:(BOOL)must
                       namestr:(NSString *)namestr
            StrblocksureBtClcik:(sureBlock)sureBlock
                      cancelClick:(cancelBlock)cancelBlock{
    MLNewestVersionShowView *alterView=[[MLNewestVersionShowView alloc]initWithFrame:CGRectMake(0, 0, WIDTH-60, must?390:435)];
            alterView.backgroundColor = [UIColor clearColor];
            alterView.center = CGPointMake(WIDTH/2, HEIGHT/2);
//            alterView.layer.cornerRadius = 20;
//            alterView.layer.masksToBounds=YES;
            alterView.sure_block=sureBlock;
            alterView.cancel_block = cancelBlock;
            alterView.textView.text = textview;
            alterView.namelabel.text = namestr;
    alterView.cancelbtn.hidden = must;
            return alterView;
}

#pragma mark--给属性重新赋值

-(void)setContent:(NSString *)content{
    _contentlabel.text = content;
}

-(void)setTitleLb:(UILabel *)titleLb{
    self.namelabel.text = self.titleLb.text;
}

-(void)setphonelabel:(UILabel *)phonelabel{
    _phonelabel.text = phonelabel.text;
}

-(void)setPhonestr:(NSString *)phonestr{
    _phonestr = phonestr;
}

-(void)setNamelabel:(UILabel *)namelabel{
    _namelabel = namelabel;
}

-(void)setTextView:(UITextView *)textView{
    _textView = textView;
}

//-(void)setSure:(NSString *)sure{
////    [_sureBt setTitle:sure forState:UIControlStateNormal];
//}

#pragma mark----确定按钮点击事件
-(void)cancelclick{
     self.cancel_block();
    [self removeFromSuperview];
}

-(void)lookclick{
    NSLog(@"hehheheh");
//    [self removeFromSuperview];
    self.sure_block();
}

#pragma mark 富文本点击事件
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"one"]) {
        NSLog(@"第一个");
        [self removeFromSuperview];
        self.user_block();
    }
    else if ([[URL scheme] isEqualToString:@"two"]) {
        [self removeFromSuperview];
        NSLog(@"第二个");
        self.agreet_block();
    }else if ([[URL scheme] isEqualToString:@"three"]) {
        [self removeFromSuperview];
        NSLog(@"第三个");
        self.phone_block();
    }else if ([[URL scheme] isEqualToString:@"four"]) {
        [self removeFromSuperview];
        NSLog(@"第四个");
        self.user_block();
    }else if ([[URL scheme] isEqualToString:@"five"]) {
        [self removeFromSuperview];
        NSLog(@"第五个");
        self.agreet_block();
    }
    return YES;
}




//#pragma mark - UITextViewDelegate
//- (void)textViewDidBeginEditing:(UITextView *)textView{
//    if([textView.text isEqualToString:@"请输入你的常用招呼语"]){
//        textView.text=@"";
//        textView.textColor =  [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
//    }
//    NSLog(@"DidBeginE--------%@",textView.text);
//}
//
//- (void)textViewDidChange:(UITextView *)textView{
//    UITextRange *selectedRange = [textView markedTextRange];
//    //获取高亮部分
//    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
//   //如果在变化中是高亮部分在变，就不要计算字符了
//    if (selectedRange && pos) {
//        return;
//    }
//    if (textView.text.length > 30) {
//        textView.text = [textView.text substringToIndex:30];
//    }else {
//    }
//    self.indextitlelabel.text = [NSString stringWithFormat:@"%zd/",(unsigned long)textView.text.length];
//}
//
//
//- (void)textViewDidEndEditing:(UITextView *)textView{
//    if(textView.text.length < 1){
//        textView.text = @"请输入你的常用招呼语";
//        textView.textColor =  [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
//    }
//    NSLog(@"dEndEditi--------%@",textView.text);
//    self.textssss = textView.text;
//}
//
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    //如果是删除减少字数，都返回允许修改
//    if ([text isEqualToString:@""]) {
//        return YES;
//    }
//    if (range.location>= 30)
//    {
//        return NO;
//    }
//    else
//    {
//        return YES;
//    }
//}


@end

