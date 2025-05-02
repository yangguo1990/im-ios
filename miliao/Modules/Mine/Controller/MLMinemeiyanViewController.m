//
//  MLMinemeiyanViewController.m
//  miliao
//
//  Created by apple on 2022/11/7.
//

#import "MLMinemeiyanViewController.h"
//#import "FUDemoManager.h"
#import <Colours/Colours.h>
#import "UIViewController+MLHud.h"

@interface MLMinemeiyanViewController ()
//@property(nonatomic, strong) FUDemoManager *demoManager;

@end

@implementation MLMinemeiyanViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-2"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-2"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(25);
        make.width.height.mas_equalTo(46);
    }];

    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:Localized(@"保存", nil) forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    saveButton.backgroundColor = kZhuColor;
    saveButton.layer.cornerRadius = 4;
    saveButton.layer.masksToBounds = YES;
    [saveButton addTarget:self action:@selector(saveback) forControlEvents:UIControlEventTouchUpInside];
    [saveButton sizeToFit];
    [self.view addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
        make.centerY.mas_equalTo(backButton.mas_centerY);
        make.width.mas_equalTo(61);
        make.height.mas_equalTo(32);
    }];

   self.view.backgroundColor = UIColor.whiteColor;
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 保存---------
-(void)saveback{
    NSLog(@"保存....");
    [self showMessage:@"美颜设置保存成功"];
    //[self.baseManager updateBeautyCache:YES];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
