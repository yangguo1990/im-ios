//
//  MLUserMessageViewController.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLUserMessageViewController.h"
#import <Masonry/Masonry.h>
#import "MLFriendModelViewController.h"
#import "TZImagePickerController.h"
#import "BRPickerView.h"
#import "MLRandomNameApi.h"
#import "MLNameCheckApi.h"
#import<CommonCrypto/CommonDigest.h>
#import <SharetraceSDK/SharetraceSDK.h>
#import "RSKImageCropper.h"
#import "MLRegisterApi.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#import "UIViewController+MLHud.h"
#import "MLTabbarViewController.h"
#import "ML_getUploadToken.h"
#import "MLNavViewController.h"
#import "SiLiaoBack-Swift.h"
@interface MLUserMessageViewController ()<UITextFieldDelegate, TZImagePickerControllerDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource>
@property (nonatomic,strong)UIButton *imgBtn;
@property (nonatomic,strong)UILabel *agelabel;

@property (nonatomic,strong)UIButton *boyBtn;
@property (nonatomic,strong)UIButton *girlBtn;
@property  (nonatomic,assign)NSInteger sexIndex;
@property (nonatomic,strong)UITextField *tnamelabel;

@property (nonatomic,strong)OSSClient *client;
//@property (nonatomic,strong)NSDictionary *userDict;
@property  (nonatomic,strong)UITextField *yaotextfied;
@property  (nonatomic,copy)NSString *yaotextStr;
@property (nonatomic,strong)NSDictionary *dataDict;
@property (nonatomic,strong)NSString *toalpath;
@property (nonatomic,strong)UIImageView *videimg;
@property (nonatomic,assign)BOOL isClick;
@property (nonatomic,strong)UITextField *passtf;
@end

@implementation MLUserMessageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

//名称和校验名称----
-(void)giveMLRandomNameApi{
    MLRandomNameApi *api = [[MLRandomNameApi alloc]initWithdev:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response);
        self.tnamelabel.text = response.data[@"name"];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}

-(void)MLNameCheckApi{
    MLNameCheckApi *api = [[MLNameCheckApi alloc]initWithname:self.tnamelabel.text dev:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response);
        if ([response.status intValue] == 0) {
            [self registapi];
        }else{
            
        }
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isEnablePanGesture = NO;
    self.ML_navView.hidden = YES;
    self.ML_backBtn.hidden = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    self.tnamelabel.text = @"";
    self.toalpath = @"";
    self.yaotextStr = @"";
    
    self.isClick = YES;
    if (kisCH) {
        [self giveMLRandomNameApi];
    }
}

-(void)setupUI{
    UIImageView *backIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight)];
    backIV.image = kGetImage(@"usermessageBack");
    [self.view addSubview:backIV];
    
    UILabel *messagelabel = [[UILabel alloc]init];
    messagelabel.text = Localized(@"请填写你的资料", nil);
    messagelabel.textAlignment = NSTextAlignmentLeft;
    //messagelabel.font = [UIFont fontWithName:@"PingFang SC-Semibold" size:18.f];
    messagelabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
    messagelabel.textColor = kGetColor(@"000000");
    [self.view addSubview:messagelabel];
    [messagelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ML_NavViewHeight);
    }];
    
    UILabel *phonetext = [[UILabel alloc]init];
    phonetext.text = Localized(@"真实信息可以提高自身魅力和匹配度哦~", nil);
    phonetext.textAlignment = NSTextAlignmentLeft;
    phonetext.font = [UIFont systemFontOfSize:14];
    phonetext.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    phonetext.textColor = kGetColor(@"999999");
    [self.view addSubview:phonetext];
    [phonetext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(messagelabel.mas_bottom).mas_offset(12);
    }];
    
    UIButton *img = [UIButton buttonWithType:UIButtonTypeCustom];
    [img setBackgroundImage:[UIImage imageNamed:@"Ellipse 24"] forState:UIControlStateNormal];
    [img addTarget:self action:@selector(imgClick:) forControlEvents:UIControlEventTouchUpInside];
    img.layer.cornerRadius = 41;
    img.layer.masksToBounds = YES;
    [self.view addSubview:img];
    self.imgBtn = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(82);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(phonetext.mas_top).mas_offset(56);
    }];
    img.layer.cornerRadius = 41;
    img.layer.masksToBounds = YES;

    UIImageView *videimg = [[UIImageView alloc]init];
    videimg.image = [UIImage imageNamed:@"icon_paishe_22_nor"];
    [self.view addSubview:videimg];
    self.videimg = videimg;
    [videimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(22);
        make.bottom.mas_equalTo(img.mas_bottom);
        make.right.mas_equalTo(img.mas_right).mas_offset(-4);
    }];
    
    UILabel *mingzi = [[UILabel alloc]initWithFrame:CGRectZero];
    mingzi.text = @"起一个好听的名字";
    mingzi.textColor = kGetColor(@"999999");
    mingzi.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:mingzi];
    [mingzi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*mWidthScale);
        make.top.mas_equalTo(videimg.mas_bottom).offset(16*mHeightScale);
        make.height.mas_equalTo(14*mHeightScale);
    }];
    
    UIView *nameView = [[UIView alloc]init];
    nameView.backgroundColor = kGetColor(@"ffffff");
    nameView.layer.cornerRadius = 18*mWidthScale;
    [self.view addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mingzi.mas_bottom).mas_offset(20*mHeightScale);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(24*mWidthScale);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-24*mWidthScale);
        make.height.mas_equalTo(46*mHeightScale);
    }];
//    UILabel *namelabel = [[UILabel alloc]init];
//    namelabel.text = [NSString stringWithFormat:@"%@:", Localized(@"昵称", nil)];
//    namelabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
//    namelabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
//    namelabel.textAlignment = NSTextAlignmentLeft;
//    [nameView addSubview:namelabel];
//    [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(nameView.mas_left).mas_offset(23);
//        make.centerY.mas_equalTo(nameView.mas_centerY);
//        make.width.mas_equalTo(50);
//    }];

    UIImageView *nameimage = [[UIImageView alloc]init];
    nameimage.hidden = !kisCH;
    nameimage.image = [UIImage imageNamed:@"icon_suijishengcheng_24_nor"];
    UITapGestureRecognizer *gesturename = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changename)];
    [nameimage addGestureRecognizer:gesturename];
    nameimage.userInteractionEnabled = YES;
    [nameView addSubview:nameimage];
    [nameimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameView.mas_centerY);
        make.right.mas_equalTo(nameView.mas_right).mas_offset(-24);
        make.width.mas_equalTo(24*mWidthScale);
        make.height.mas_equalTo(24*mWidthScale);
    }];
    


    UITextField *tnamelabel = [[UITextField alloc]init];
    NSAttributedString * placeholder = [[NSAttributedString alloc]initWithString:@"请填写你的昵称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium],NSForegroundColorAttributeName:kGetColor(@"666666")}];
    tnamelabel.attributedPlaceholder = placeholder;
    tnamelabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    tnamelabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    tnamelabel.textAlignment = NSTextAlignmentCenter;
    tnamelabel.delegate = self;
    tnamelabel.tag = 1000;
    [nameView addSubview:tnamelabel];
    self.tnamelabel = tnamelabel;
    [tnamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(nameView.mas_centerY);
        make.height.mas_equalTo(nameView.mas_height);
        make.right.mas_equalTo(nameimage.mas_left).offset(-10);
    }];
    
    
    
    UILabel *shengri = [[UILabel alloc]initWithFrame:CGRectZero];
    shengri.text = @"选择你的生日";
    shengri.textColor = kGetColor(@"999999");
    shengri.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:shengri];
    [shengri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*mWidthScale);
        make.top.mas_equalTo(nameView.mas_bottom).offset(16*mHeightScale);
        make.height.mas_equalTo(14*mHeightScale);
    }];
    
    

    UIView *ageView = [[UIView alloc]init];
    ageView.backgroundColor = kGetColor(@"ffffff");
    ageView.layer.cornerRadius = 18*mWidthScale;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAge)];
    [ageView addGestureRecognizer:gesture];
    [self.view addSubview:ageView];
    [ageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(shengri.mas_bottom).mas_offset(20*mHeightScale);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(24*mWidthScale);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-24*mWidthScale);
        make.height.mas_equalTo(46*mHeightScale);
    }];
    
    UILabel *agelabel = [[UILabel alloc]init];
    agelabel.textColor = kGetColor(@"666666");
    agelabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    agelabel.textAlignment = NSTextAlignmentCenter;
    agelabel.text = Localized(@"请填写你的生日", nil);
    [ageView addSubview:agelabel];
    self.agelabel = agelabel;
    [agelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(ageView.mas_centerY);
        make.height.mas_equalTo(ageView.mas_height);
        make.right.mas_equalTo(-10);
    }];


    UIImageView *ageimage = [[UIImageView alloc]init];
    ageimage.image = [UIImage imageNamed:@"icon_back_24_FFF_nor-3"];
    [ageView addSubview:ageimage];
    [ageimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ageView.mas_centerY);
        make.right.mas_equalTo(ageView.mas_right).mas_offset(-24);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    
    UILabel *bottomtext = [[UILabel alloc]init];
    bottomtext.text = Localized(@"选择你的性别(注册后性别不能修改)", nil);
    bottomtext.textAlignment = NSTextAlignmentCenter;
    bottomtext.font = [UIFont systemFontOfSize:14];
    bottomtext.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    bottomtext.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.view addSubview:bottomtext];
    [bottomtext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20*mWidthScale);
        make.top.mas_equalTo(ageView.mas_bottom).mas_offset(16*mHeightScale);
        make.height.mas_equalTo(14*mHeightScale);
    }];
    

    UIButton *boybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [boybtn addTarget:self action:@selector(boyClick) forControlEvents:UIControlEventTouchUpInside];
//    boybtn.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    [boybtn setBackgroundImage:[UIImage imageNamed:@"icon_nansheng_24_nor"] forState:UIControlStateNormal];
    [boybtn setBackgroundImage:[UIImage imageNamed:@"icon_nansheng_24_sel"] forState:UIControlStateSelected];

    boybtn.selected = NO;

    [self.view addSubview:boybtn];
    self.boyBtn = boybtn;
    [boybtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomtext.mas_bottom).mas_offset(17);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(27);
        make.right.mas_equalTo(self.view.mas_centerX).mas_offset(-8.5);
        make.height.mas_equalTo(53);
    }];
    UIButton *girlbtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [girlbtn addTarget:self action:@selector(girlClick) forControlEvents:UIControlEventTouchUpInside];
    [girlbtn setBackgroundImage:[UIImage imageNamed:@"icon_nvsheng_24_sel-1"] forState:UIControlStateNormal];
    [girlbtn setBackgroundImage:[UIImage imageNamed:@"icon_nvsheng_24_sel"] forState:UIControlStateSelected];

    girlbtn.selected = NO;
    [self.view addSubview:girlbtn];
    self.girlBtn = girlbtn;
    [girlbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boybtn.mas_top);
        make.left.mas_equalTo(self.view.mas_centerX).mas_offset(8.5);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-27);
        make.height.mas_equalTo(53);
    }];
    
    UILabel *mima1 = [[UILabel alloc]initWithFrame:CGRectZero];
    mima1.text = @"设置密码（密码6-11位，只允许字母数字下划线!）";
    mima1.textColor = kGetColor(@"999999");
    mima1.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:mima1];
    [mima1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*mWidthScale);
        make.top.mas_equalTo(boybtn.mas_bottom).offset(16*mHeightScale);
        make.height.mas_equalTo(14*mHeightScale);
    }];
    
    UITextField *mimaTF1 = [[UITextField alloc]initWithFrame:CGRectZero];
    self.passtf = mimaTF1;
    mimaTF1.backgroundColor = kGetColor(@"ffffff");
    mimaTF1.layer.cornerRadius = 18*mWidthScale;
    mimaTF1.layer.masksToBounds = YES;
    mimaTF1.secureTextEntry = YES;
    mimaTF1.textAlignment = NSTextAlignmentCenter;
    NSAttributedString * TF1placeholder = [[NSAttributedString alloc]initWithString:@"请填写密码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium],NSForegroundColorAttributeName:kGetColor(@"666666")}];
    mimaTF1.attributedPlaceholder = TF1placeholder;
    [self.view addSubview:mimaTF1];
    [mimaTF1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mima1.mas_bottom).mas_offset(20*mHeightScale);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(24*mWidthScale);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-24*mWidthScale);
        make.height.mas_equalTo(46*mHeightScale);
    }];
    
    

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.backgroundColor = kGetColor(@"ff6fb3").CGColor;
    btn.layer.cornerRadius = 25;
    [btn setTitle:Localized(@"填好啦", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-49);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(27);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-27);
        make.height.mas_equalTo(53);
    }];
}


-(void)changeAge{
    
    [self.view endEditing:YES];
    
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    datePickerView.pickerMode = BRDatePickerModeYMD;
    NSString *dateStr = @"2004-01-01";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
   [formatter setDateFormat:@"yyyy-MM-dd"];
   NSDate *newDate = [formatter dateFromString:dateStr];
    datePickerView.selectDate = newDate;
//    datePickerView.selectValue = @"2004-01-01";
    
    NSString *dateStr2 = @"1945-01-01";
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init] ;
   [formatter2 setDateFormat:@"yyyy-MM-dd"];
   NSDate *newDate2 = [formatter dateFromString:dateStr2];
    datePickerView.minDate = newDate2;
    
    NSString *dateStr3 = @"2024-12-31";
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init] ;
   [formatter3 setDateFormat:@"yyyy-MM-dd"];
   NSDate *newDate3 = [formatter dateFromString:dateStr3];
    datePickerView.maxDate = newDate3;
    
    datePickerView.title = Localized(@"请选择出生日期", nil);
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        NSLog(@"出生日期---%@",selectValue);
        self.agelabel.text = selectValue;
        self.agelabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    };
    BRPickerStyle *customStyle = [BRPickerStyle pickerStyleWithThemeColor:[UIColor darkGrayColor]];
    datePickerView.pickerStyle = customStyle;
    [datePickerView show];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1000) {
        self.tnamelabel.text = textField.text;
    }else{
        self.yaotextStr = textField.text;
    }
    
   // NSLog(@"DidEndEditing-----%@",textField.text);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.tnamelabel) {
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

-(void)changename{
    [self giveMLRandomNameApi];
}

-(void)imgClick:(UIButton *)gr{
    
    [self.view endEditing:YES];
    
    TZImagePickerController *tzCtrl = [[TZImagePickerController alloc] initWithMaxImagesCount:1  delegate:self];
    tzCtrl.barItemTextColor = [UIColor blackColor];
    tzCtrl.showSelectBtn = NO;
   tzCtrl.allowCrop = YES;
   tzCtrl.allowTakePicture = YES;
   tzCtrl.allowPickingOriginalPhoto = NO;
   tzCtrl.allowPickingVideo = NO;
   tzCtrl.allowTakeVideo = NO;
   tzCtrl.allowPickingGif = NO;
   tzCtrl.preferredLanguage = @"zh-Hans";
   tzCtrl.needCircleCrop = NO;//是否是圆形裁剪 YES 则是圆形裁剪 NO 方形
    tzCtrl.cropRect = CGRectMake(0, (ML_ScreenHeight - ML_ScreenWidth) / 2, ML_ScreenWidth, ML_ScreenWidth);
   tzCtrl.autoSelectCurrentWhenDone = YES;
//   tzCtrl.modalPresentationStyle = UIModalPresentationFullScreen;
  
   [self presentViewController:tzCtrl animated:YES completion:nil];
        
}


#pragma mark RSKImageCropViewControllerDataSource---返回图片的位置
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{

    CGRect imgRect  = CGRectMake(0, (ML_ScreenHeight - ML_ScreenWidth) / 2, ML_ScreenWidth, ML_ScreenWidth);

    return imgRect;
}

#pragma mark RSKImageCropViewControllerDataSource---返回裁剪框的位置
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    CGRect imgRect = CGRectMake(0, (ML_ScreenHeight - ML_ScreenWidth) / 2, ML_ScreenWidth, ML_ScreenWidth);

    UIBezierPath *path=[UIBezierPath bezierPathWithRoundedRect:imgRect cornerRadius:0];
    
    return path;
}


#pragma mark RSKImageCropViewControllerDataSource 返回一个图片可以移动的矩形区域
 
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
    return controller.maskRect;
}

#pragma mark RSKImageCropViewControllerDelegate---图片裁剪完
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle
{


    [self chuanImageWithArr:croppedImage index:self.imgBtn.tag+1 count:1];
    [self.navigationController popViewControllerAnimated:NO];

}
#pragma mark RSKImageCropViewControllerDelegate---取消按钮
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -- 相册回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    if (photos.count == 1) {
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:[photos lastObject] cropMode:RSKImageCropModeCustom];

        imageCropVC.delegate = self;

        imageCropVC.dataSource=self;
        [self.navigationController pushViewController:imageCropVC animated:YES];

    }
}

- (void)chuanImageWithArr:(UIImage *)image index:(NSInteger)index count:(NSInteger)aCount
{
//    __block NSInteger count = aCount;
    [SVProgressHUD showWithStatus:Localized(@"上传中...", nil)];
    self.imgBtn.userInteractionEnabled = NO;
    
//    self.imgBtn.layer.cornerRadius = 41;
//    self.imgBtn.layer.masksToBounds = YES;
    [self.imgBtn setBackgroundImage:image forState:UIControlStateNormal];
    kSelf;
    ML_getUploadToken *tokenapi = [[ML_getUploadToken alloc] initWithfileName:[NSString stringWithFormat:@"%@_file", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]?:@"" dev:@"" token:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] extra:[self jsonStringForDictionary]];
    [tokenapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response);
        
        kSelf2;
        [ML_CommonApi  uploadImages:@[image] dic:response.data[@"sts"] block:^(NSString * _Nonnull url) {
            
//            count--;
            NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
            
            [muDic setObject:url forKey:@"icon"];

            weakself.toalpath = url;
            
                                    dispatch_async(dispatch_get_main_queue(), ^{ // 异步主线程
                                        weakself.imgBtn.userInteractionEnabled = YES;
                                        [SVProgressHUD dismiss];
                                    });
            
            NSLog(@"urlurl====%@", url);
            
        }];
        
        
    } error:^(MLNetworkResponse *response) {
        
        [SVProgressHUD dismiss];
        
        
        weakself.imgBtn.userInteractionEnabled = YES;
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
        weakself.imgBtn.userInteractionEnabled = YES;
    }];
    
    
}



-(void)boyClick{
    
    self.boyBtn.selected = YES;
    self.girlBtn.selected = NO;
//    self.girlBtn.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//    self.boyBtn.backgroundColor = [UIColor colorWithRed:175/255.0 green:189/255.0 blue:250/255.0 alpha:1.0];
    self.sexIndex = 1;
}


-(void)girlClick{
    self.boyBtn.selected = NO;
    self.girlBtn.selected = YES;
//    self.girlBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:176/255.0 blue:176/255.0 alpha:1.0];
//    self.boyBtn.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.sexIndex = 0;
}

-(void)btnClick{

    [self MLNameCheckApi];

    //MLFriendModelViewController *vc = [[MLFriendModelViewController alloc]init];
    //[self.navigationController pushViewController:vc animated:YES];
}

-(void)registapi{

    if ([self.agelabel.text isEqualToString:Localized(@"请选择出生日期", nil)]) {
        [self showMessage:Localized(@"请选择出生日期", nil)];
        return;
    }
    if (self.isClick == NO) {
        return;
    }
//    if ([self.toalpath isEqualToString:@""]) {
//        [self showMessage:Localized(@"请设置头像", nil)];
//        return;
//    }
    if (self.boyBtn.selected == NO && self.girlBtn.selected == NO) {
        [self showMessage:Localized(@"请选择性别", nil)];
        return;
    }

    
    self.isClick = NO;
    [SVProgressHUD show];
    
    [Sharetrace getInstallTrace:^(AppData * _Nullable appdata) {

            NSLog(@"ShareTrace success:  paramsData：%@  channel==%@", [appdata paramsData], appdata.channel);
            
            NSArray * splitResult = [[appdata paramsData]?:@"" componentsSeparatedByString:@"="];
            int mag = 0;
            if (splitResult.count >= 2) {
                if ([[splitResult firstObject] isEqualToString:@"inviteCode"]) {
                    mag = 1;
                } else if ([[splitResult firstObject] isEqualToString:@"channelCode"]) {
                    mag = 2;
                }
            }
            
            
        MLRegisterApi *registerapi = [[MLRegisterApi alloc] initWithicon:self.toalpath?:@"" name:self.tnamelabel.text thirdId:@{self.type : self.phonestr} gender:[NSString stringWithFormat:@"%ld",(long)self.sexIndex] birth:self.agelabel.text inviteCode:(mag == 1 ? [splitResult lastObject] : @"") channelCode:(mag == 2 ? [splitResult lastObject] : @"") dev:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] pass:self.passtf.text extra:[self jsonStringForDictionary]];
            [registerapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                NSLog(@"注册结果----%@",response.data);
                NSLog(@"年龄注册----%@",self.agelabel.text);
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:response.data
                                                                           options:NSJSONWritingPrettyPrinted
                                                                             error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [UserCenter loginByOC:jsonString completion:^(BOOL x) {
                    if(x){
                        if (![response.data[@"user"][@"token"] isEqual:@""] && [response.status integerValue] == 0) {
                     //       [userDefault setObject:@"1" forKey:@"login"];
                     //       [userDefault setObject:response.data[@"user"][@"token"]?:@"" forKey:@"imToken"];
                     //       [userDefault setObject:response.data[@"user"][@"id"]?:@"" forKey:@"id"];
                     //       [userDefault synchronize];
                            
                            NSDictionary *dic = (NSDictionary *)response.data;
                            
                            UserInfoData * currentData = [UserInfoData mj_objectWithKeyValues:dic[@"user"]];
                            currentData.domain = response.data[@"domain"]?:@"";
                            currentData.thirdId = response.data[@"thirdId"]?:@"";
                            [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
                            self.isClick = YES;
        //                    if (kisCH) {
        //                        MLFriendModelViewController *vc = [[MLFriendModelViewController alloc]init];
        ////                        [self.navigationController pushViewController:vc animated:YES];
        //                        MLNavViewController *navVC = [[MLNavViewController alloc] initWithRootViewController:vc];
        //                        [[AppDelegate shareAppDelegate] setupRootViewController:navVC];
        //                    } else {
                                MLTabbarViewController *mainTab = [[MLTabbarViewController alloc] init];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[AppDelegate shareAppDelegate] setupRootViewController:mainTab];
                            });
                               
        //                    }
                        }
                        [SVProgressHUD dismiss];
                    }else{
                        [SVProgressHUD showInfoWithStatus:@"IM注册失败"];
                    }
                }];
                
        } error:^(MLNetworkResponse *response) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"注册失败:%@",response.msg]];
            self.isClick = YES;
        } failure:^(NSError *error) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"注册失败:%@",error.localizedDescription]];
            self.isClick = YES;
        }];
        
        
    } :^(NSInteger code, NSString * _Nonnull message) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"shareTrace fail:%@",message]];
        MLRegisterApi *registerapi = [[MLRegisterApi alloc] initWithicon:self.toalpath?:@"" name:self.tnamelabel.text thirdId:@{self.type : self.phonestr} gender:[NSString stringWithFormat:@"%ld",(long)self.sexIndex] birth:self.agelabel.text inviteCode:@"" channelCode:@"" dev:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] pass:self.passtf.text extra:[self jsonStringForDictionary]];
        [registerapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:response.data
                                                                       options:NSJSONWritingPrettyPrinted
                                                                         error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [UserCenter loginByOC:jsonString completion:^(BOOL x) {
                if(x){
                    if (![response.data[@"user"][@"token"] isEqual:@""] && [response.status integerValue] == 0) {
                        NSDictionary *dic = (NSDictionary *)response.data;
                        
                        UserInfoData * currentData = [UserInfoData mj_objectWithKeyValues:dic[@"user"]];
                        currentData.domain = response.data[@"domain"]?:@"";
                        currentData.thirdId = response.data[@"thirdId"]?:@"";
                        [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
                        self.isClick = YES;
   
                            MLTabbarViewController *mainTab = [[MLTabbarViewController alloc] init];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[AppDelegate shareAppDelegate] setupRootViewController:mainTab];
                        });
                    }
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showInfoWithStatus:@"IM注册失败"];
                }
            }];
        } error:^(MLNetworkResponse *response) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"注册失败:%@",response.msg]];
            self.isClick = YES;
        } failure:^(NSError *error) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"注册失败:%@",error.localizedDescription]];
            self.isClick = YES;
        }];
    }];
    
    
}



@end
