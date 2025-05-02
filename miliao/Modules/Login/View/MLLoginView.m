//
//  MLLoginView.m
//  miliao
//
//  Created by apple on 2022/11/11.
//

#import "MLLoginView.h"
#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#import <Masonry/Masonry.h>

@interface MLLoginView()<UITextViewDelegate>

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
@property (nonatomic,copy)NSString *phonestr;
@property (nonatomic,copy)NSString *phonenamestr;


@end

@implementation MLLoginView

-(instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *namelabel = [[UILabel alloc]init];
        namelabel.numberOfLines = 0;
        namelabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold];
        namelabel.textColor = [UIColor colorWithHexString:@"#333333"];
        namelabel.text = @"云水谣情用户协议和隐私政策提示";
        [self addSubview:namelabel];
        
        UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelbtn setTitle:Localized(@"不同意", nil) forState:UIControlStateNormal];
        cancelbtn.backgroundColor = [UIColor clearColor];
        [cancelbtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        cancelbtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [cancelbtn addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelbtn];
        
        UIButton *lookbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lookbtn setTitle:Localized(@"同意并继续", nil) forState:UIControlStateNormal];
        lookbtn.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        [lookbtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        lookbtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [lookbtn addTarget:self action:@selector(lookclick) forControlEvents:UIControlEventTouchUpInside];
        lookbtn.layer.masksToBounds = YES;
        lookbtn.layer.cornerRadius = 6;
        [self addSubview:lookbtn];
        self.lookbtn = lookbtn;
        
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(24);
            make.width.mas_equalTo(self.width-90);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];       
        [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
            make.right.mas_equalTo(self.mas_right).mas_offset(-18);
            make.left.mas_equalTo(self.mas_left).mas_offset(18);
            make.height.mas_equalTo(49);
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
        textView.textColor =  [UIColor colorWithHexString:@"#666666"];
        textView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        textView.delegate = self;
        [self addSubview:textView];
        self.textView = textView;
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_offset(18);
            make.top.mas_equalTo(namelabel.mas_bottom).mas_offset(16);
            make.right.mas_equalTo(self.mas_right).mas_offset(-18);
            make.bottom.mas_equalTo(lookbtn.mas_top).mas_offset(-16);
        }];
        
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

+(instancetype)alterVietextview:(NSString *)textview StrblocksureBtClcik:(sureBlock)sureBlock
                      cancelClick:(cancelBlock)cancelBlock
                        userClick:(userBlock)userBlock
                        agreetClick:(agreetBlock)agreetBlock
                        phoneClick:(phoneBlock)phoneBlock{
            MLLoginView *alterView=[[MLLoginView alloc]initWithFrame:CGRectMake(0, 0, WIDTH-50, 346)];
            alterView.backgroundColor = [UIColor whiteColor];
            alterView.center = CGPointMake(WIDTH/2, HEIGHT/2);
            alterView.layer.cornerRadius = 16;
            alterView.layer.masksToBounds=YES;
            alterView.sure_block=sureBlock;
            alterView.cancel_block = cancelBlock;
            alterView.user_block = userBlock;
            alterView.agreet_block = agreetBlock;
            alterView.phone_block = phoneBlock;
            alterView.phonestr = textview;
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
    if ([_phonestr isEqualToString:@"0"]) { //电信
        self.phonenamestr = Localized(@"《中国电信认证服务条款》", nil);
    }else if([_phonestr isEqualToString:@"103000"]){//移动 103000
        self.phonenamestr = @"中国移动认证服务条款";
    }else{//联通
        self.phonenamestr = @"中国联通认证服务条款";
    }
    NSString *strA = Localized(@"Meeting重视并致力于保障您的个人隐私，我们根据监管要求更新了", nil);
    if (kisCH) {
        strA = @"云水谣情重视并致力于保障您的个人隐私，我们根据监管要求更新了";
    }
    NSString *strB = Localized(@"《用户协议》", nil);
    NSString *strC = Localized(@"和", nil);
    NSString *strD = Localized(@"《隐私协议》", nil);
    NSString *strE = Localized(@"特别说明如下:\n1.为更好的帮您找到心仪的朋友，会根据您设置的择偶条件向您做推荐;\n2.为了查看附近的用户，我们需要使用您的位置信息，您可以随时开启或关闭此项授权;\n3.您可以随时访问、更正、删除您的个人信息，我们也提供了注销和反馈的渠道;\n4.未经您同意，我们不会从第三方获取、共享或向其提供您的信息;\n5.点击同意即表示您已阅读并同意全部条款。\n我们非常重视您的个人信息保护。关于个人信息收集和使用的详细信息，你可以点击", nil);
    
    NSString *strF = [NSString stringWithFormat:@"《%@》",  self.phonenamestr];
    if ([phonestr intValue] == -1) {
        strF = @"";
    }
    NSString *strG = Localized(@"《用户协议》", nil);
    NSString *strH = Localized(@"和", nil);
    NSString *strI = Localized(@"《隐私协议》", nil);
    NSString *strJ = Localized(@"进行了解。", nil);
    self.textView.text =[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",strA,strB,strC,strD,strE,strF,strG,strH,strI,strJ];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing= 5;
    NSDictionary*attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.textView.text attributes:attributes];
    [attributedString addAttribute:NSLinkAttributeName value:@"one://" range:NSMakeRange(strA.length,strB.length)];
    [attributedString addAttribute:NSLinkAttributeName value:@"two://" range:NSMakeRange(strA.length+strB.length+strC.length ,strD.length)];
    [attributedString addAttribute:NSLinkAttributeName value:@"three://" range:NSMakeRange(strA.length+strB.length+strC.length+strD.length+strE.length,strF.length)];
  [attributedString addAttribute:NSLinkAttributeName value:@"four://" range:NSMakeRange(strA.length+strB.length+strC.length+strD.length+strE.length+strF.length,strG.length)];
    [attributedString addAttribute:NSLinkAttributeName value:@"five://" range:NSMakeRange(strA.length+strB.length+strC.length+strD.length+strE.length+strF.length+strG.length+strH.length,strI.length)];
    self.textView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]};
    self.textView.attributedText= attributedString;
}

//-(void)setSure:(NSString *)sure{
////    [_sureBt setTitle:sure forState:UIControlStateNormal];
//}

#pragma mark----确定按钮点击事件
-(void)cancelclick {
    self.cancel_block();
//    [self removeFromSuperview];
    [self.superview removeFromSuperview];
}

-(void)lookclick{
    NSLog(@"hehheheh");
    self.sure_block();
    
    [self cancelclick];
}

#pragma mark 富文本点击事件
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"one"]) {
        NSLog(@"第一个");
        self.user_block();
    }
    else if ([[URL scheme] isEqualToString:@"two"]) {
        NSLog(@"第二个");
        self.agreet_block();
    }else if ([[URL scheme] isEqualToString:@"three"]) {
        NSLog(@"第三个");
        self.phone_block();
    }else if ([[URL scheme] isEqualToString:@"four"]) {
        NSLog(@"第四个");
        self.user_block();
    }else if ([[URL scheme] isEqualToString:@"five"]) {
        NSLog(@"第五个");
        self.agreet_block();
    }
    [self cancelclick];
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

