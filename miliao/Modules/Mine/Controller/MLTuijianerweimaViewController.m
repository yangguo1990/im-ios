//
//  MLTuijianerweimaViewController.m
//  miliao
//
//  Created by apple on 2022/10/28.
//

#import "MLTuijianerweimaViewController.h"
#import "MLSaveRealAuditInfoApi.h"
#import "MLFaceRenResultViewController.h"
#import "ML_RequestManager.h"
#import "UIViewController+MLHud.h"
#import "MLRenzhengWebViewController.h"
#import "MLGetInviteUrlApi.h"
#import <SDWebImage/SDWebImage.h>
#import "UIViewController+MLHud.h"

@interface MLTuijianerweimaViewController ()

@property (nonatomic,copy)NSString *namestr;
@property (nonatomic,copy)NSString *idcardestr;
@property (nonatomic,strong)UIImageView *img;
@property  (nonatomic,copy)NSURL *imgurl;


@end

@implementation MLTuijianerweimaViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    
    [self givenetwrok];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}

-(void)givenetwrok{
    MLGetInviteUrlApi *api = [[MLGetInviteUrlApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response.data);
        [self.img sd_setImageWithURL:kGetUrlPath(response.data[@"qrCodePath"]) placeholderImage:nil];
        self.imgurl = kGetUrlPath(response.data[@"qrCodePath"]);
        NSLog(@"codeurl is %@",self.imgurl);
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.ML_navView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    //self.ML_rightBtn.hidden = YES;
    [self.ML_backBtn setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-2"] forState:UIControlStateNormal];
    //self.- (void)ML_addNavRightBtnWithTitle:(NSString *)title image:(UIImage *)image;
    [self ML_addNavRightBtnWithTitle:@"" image:[UIImage imageNamed:@"Group 2140"]];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    [self.ML_rightBtn addTarget:self action:@selector(rigthClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-2"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(55);
    }];

    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"share_background"];
    img.contentMode = UIViewContentModeScaleToFill;
    img.userInteractionEnabled = YES;
    [self.view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(backBtn.mas_bottom).mas_offset(24);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-102);
    }];
    
    UIImageView *bottomimg = [[UIImageView alloc]init];
    bottomimg.image = [UIImage imageNamed:@"fenxiangerweima"];
    bottomimg.contentMode = UIViewContentModeScaleToFill;
    bottomimg.userInteractionEnabled = YES;
    [img addSubview:bottomimg];
    [bottomimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(img.mas_left).mas_offset(19);
        make.right.mas_equalTo(img.mas_right).mas_offset(-14);
        make.height.mas_equalTo(109);
        make.bottom.mas_equalTo(img.mas_bottom).mas_offset(-41);
    }];
    
    
    UILabel *label = [[UILabel alloc] init];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:kisCH?@"扫描二维码加入云水谣情":Localized(@"扫描二维码加入Meeting", nil) attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightMedium],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [bottomimg addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomimg.mas_left).mas_offset(28);
        make.top.mas_equalTo(bottomimg.mas_top).mas_offset(12);
    }];
    
    UILabel *bottomlabel = [[UILabel alloc] init];
    NSMutableAttributedString *stringbottom = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"ID:%@", ML_AppUserInfoManager.sharedManager.currentLoginUserData.userId] attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 18],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    bottomlabel.attributedText = stringbottom;
    bottomlabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [bottomimg addSubview:bottomlabel];
    [bottomlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomimg.mas_left).mas_offset(28);
        make.bottom.mas_equalTo(bottomimg.mas_bottom).mas_offset(-22);
    }];
    
    UILabel *bottomlabel2 = [[UILabel alloc] init];
    NSMutableAttributedString *stringbottom2 = [[NSMutableAttributedString alloc] initWithString:Localized(@"记住ID来撩我", nil) attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    bottomlabel2.attributedText = stringbottom2;
    bottomlabel2.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [bottomimg addSubview:bottomlabel2];
    [bottomlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomimg.mas_left).mas_offset(28);
        make.bottom.mas_equalTo(bottomimg.mas_bottom).mas_offset(-52);
    }];

    UIImageView *qrcodeImage = [[UIImageView alloc]init];
    qrcodeImage.contentMode = UIViewContentModeScaleToFill;
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageViewTolocal)];
    //[qrcodeImage addGestureRecognizer:tap];
    //qrcodeImage.userInteractionEnabled = YES;
    [bottomimg addSubview:qrcodeImage];
    self.img = qrcodeImage;
    [qrcodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomimg.mas_right).mas_offset(-42);
        make.top.mas_equalTo(bottomimg.mas_top).mas_offset(14);
        make.width.height.mas_equalTo(74);
    }];
}

-(void)rigthClick{
    [self addImageViewTolocal];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
      return UIStatusBarStyleLightContent;
}

-(void)backclick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addImageViewTolocal{

       UIAlertController * alertController = [UIAlertController alertControllerWithTitle:Localized(@"是否添加图片至本地相册", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:Localized(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnullaction) {
               NSData *data = [NSData dataWithContentsOfURL:self.imgurl];
               UIImage *myImage = [UIImage imageWithData:data];
               [self saveImageToPhotos:myImage];
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
}


- (void)saveImageToPhotos:(UIImage*)savedImage

{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = Localized(@"保存图片失败", nil);
    }else{
        msg = Localized(@"保存图片成功", nil) ;
    }
    [self showMessage:msg];
}




@end
