//
//  MLMineNmaechangeViewController.m
//  miliao
//
//  Created by apple on 2022/9/16.
//

#import "MLMineNmaechangeViewController.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>

@interface MLMineNmaechangeViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)NSString *str;
@property (nonatomic,strong)UITextField *textfield;
@property (nonatomic,strong)UILabel *indexLabel;
@property (nonatomic,strong)UILabel *allLabel;


@end

@implementation MLMineNmaechangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_titleLabel.text = Localized(@"昵称", nil);
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
}


-(void)setupUI{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:kGetImage(@"buttonBG") forState:UIControlStateNormal];
    [btn setTitle:Localized(@"完成", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-15);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(27);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-27);
        make.height.mas_equalTo(53);
    }];
    
    self.bgview = [[UIView alloc] init];
    self.bgview.layer.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    self.bgview.layer.cornerRadius = 30;
    [self.view addSubview:self.bgview];
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(25 + 64);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
        make.height.mas_equalTo(53);
    }];

    self.indexLabel = [[UILabel alloc]init];
    self.indexLabel.text = [NSString stringWithFormat:@"%lu/10",(unsigned long)[ML_AppUserInfoManager sharedManager].currentLoginUserData.name.length];
    self.indexLabel.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.indexLabel.text attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16],NSForegroundColorAttributeName: kZhuColor}];
    [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]} range:NSMakeRange(2, 2)];

    self.indexLabel.attributedText = string;
    [self.bgview addSubview:self.indexLabel];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgview.mas_right).mas_offset(-22);
        make.centerY.mas_equalTo(self.bgview.mas_centerY);
        make.width.mas_equalTo(50);
    }];

    UITextField *textfield = [[UITextField alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:nil];
    textfield.font = [UIFont systemFontOfSize:15];
    textfield.placeholder = Localized(@"输入昵称", nil);
    textfield.text = [ML_AppUserInfoManager sharedManager].currentLoginUserData.name;
    textfield.delegate = self;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    [self.bgview addSubview:textfield];
    self.textfield = textfield;
    [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgview.mas_left).mas_offset(24);
        make.right.mas_equalTo(self.indexLabel.mas_left).mas_offset(-20);
        make.centerY.mas_equalTo(self.bgview.mas_centerY);
        make.height.mas_equalTo(30);
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textfield) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 10) {
            return NO;
        }
    }
    return YES;
}

- (void)textChange {
    NSLog(@"%@",self.textfield.text);
    self.str = self.textfield.text;
    self.indexLabel.text = [NSString stringWithFormat:@"%lu/10",(unsigned long)self.textfield.text.length];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.indexLabel.text attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16],NSForegroundColorAttributeName: kZhuColor}];
    if (self.textfield.text.length == 10) {
        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]} range:NSMakeRange(3, 2)];
    }else{
        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]} range:NSMakeRange(2, 2)];
    }
    self.indexLabel.attributedText = string;
}

-(void)btnClick{
    NSLog(@"wancheng");
    self.returnBlock(self.str);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

@end
