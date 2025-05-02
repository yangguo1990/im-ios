

#import "ML_JubaoVC.h"
#import "UITextView+ML.h"
#import "TZImagePickerController.h"
#import "UIImage+ML.h"
#import "ML_CommonApi.h"
#import "ML_getUploadToken.h"
//#import <AssetsLibrary/AssetsLibrary.h>

@interface ML_JubaoVC ()<UITextViewDelegate, TZImagePickerControllerDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *dongId;
@property (nonatomic, strong) UILabel *ziCountV;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIImageView *pingzhengV;
@property (nonatomic, strong) NSMutableArray *imgUrlArr;
@end

@implementation ML_JubaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *topBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 88*mHeightScale)];
    [self.view addSubview:topBG];
    topBG.image = kGetImage(@"bg_top");

    self.imgUrlArr = [NSMutableArray array];
    
    self.count = 200;
    
//    [self ML_setUpCustomNavklb_la];
    self.ML_titleLabel.text = Localized(@"举报", nil);

    UILabel *titleV = [[UILabel alloc] initWithFrame:CGRectMake(16, ML_NavViewHeight + 20, 200, 15)];
    titleV.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];;
    titleV.text = Localized(@"内容描述：", nil);
    titleV.textColor = kGetColor(@"#333333");
    titleV.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleV];
    
    [self test1];
    
    UILabel *titleV2 = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.textView.frame) + 30, 200, 15)];
    titleV2.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleV2.text = Localized(@"上传凭证：", nil);
    titleV2.textColor = kGetColor(@"#333333");
    titleV2.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleV2];
    
    UIImageView *pingzhengV = [[UIImageView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(titleV2.frame) + 30, 86, 86)];
    [pingzhengV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPicTap)]];
    pingzhengV.image = kGetImage(@"editInfo_add_picture");
    pingzhengV.userInteractionEnabled = YES;
    pingzhengV.layer.cornerRadius = 5;
    pingzhengV.layer.masksToBounds = YES;
    [self.view addSubview:pingzhengV];
    self.pingzhengV = pingzhengV;
            
//    UILabel *qwV = [[UILabel alloc] initWithFrame:CGRectMake(titleV2.x, CGRectGetMaxY(pingzhengV.frame) + 20, 200, 15)];
//    qwV.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
//    qwV.text = Localized(@"友情提示：请勿恶意举报", nil);
//    qwV.textColor = kGetColor(@"#999999");
//    qwV.textAlignment = NSTextAlignmentLeft;
//    [self.view addSubview:qwV];
    UIImageView *yqImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 164*mWidthScale, 24*mHeightScale)];
    NSLog(@"%f",mWidthScale);
    yqImageView.image=kGetImage(@"yqts");
    [self.view addSubview:yqImageView];
    [yqImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(674*mHeightScale);
    }];
    
    self.ziCountV = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenWidth - 16 - 10 - 100, titleV.y, 100, titleV.height)];
    self.ziCountV.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];;
    self.ziCountV.text = [NSString stringWithFormat:@"0/200%@", Localized(@"字", nil)];
    self.ziCountV.textColor = kGetColor(@"#999999");
    self.ziCountV.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.ziCountV];
    
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake((UIScreenWidth - 300) / 2, UIScreenHeight - 100, 300, 48)];
    
//    doneBtn.backgroundColor = [UIColor colorWithHexString:@"ffe962"];
    [doneBtn setTitle:Localized(@"提交", nil) forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:kGetImage(@"buttonBG") forState:UIControlStateNormal];
//    doneBtn.layer.masksToBounds = YES;
//    doneBtn.layer.cornerRadius = 24;
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
}

- (void)addPicTap
{
   TZImagePickerController *tzCtrl = [[TZImagePickerController alloc] initWithMaxImagesCount:1  delegate:self];
   tzCtrl.barItemTextColor = [UIColor blackColor];
   tzCtrl.allowTakePicture = YES;
   tzCtrl.allowPickingOriginalPhoto = NO;
   tzCtrl.allowPickingVideo = NO;
   tzCtrl.allowTakeVideo = NO;
   tzCtrl.allowPickingGif = NO;
   tzCtrl.preferredLanguage = @"zh-Hans";
//   tzCtrl.modalPresentationStyle = UIModalPresentationFullScreen;
   [self presentViewController:tzCtrl animated:YES completion:nil];
    
}


#pragma mark -- 相册回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    UIImage *img = [UIImage compressedImageToLimitSizeOfKB:1000 image:[photos lastObject]];

    self.pingzhengV.image = img;
    
    [SVProgressHUD showWithStatus:Localized(@"上传中...", nil)];
    
    kSelf;
    ML_getUploadToken *tokenapi = [[ML_getUploadToken alloc] initWithfileName:[NSString stringWithFormat:@"%@_file", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]?:@"" dev:@"" token:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] extra:[self jsonStringForDictionary]];
    [tokenapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response);
        
        
        
        [ML_CommonApi  uploadImages:@[img] dic:response.data[@"sts"] block:^(NSString * _Nonnull url) {
            
            NSLog(@"urlurl====%@", url);
            [weakself.imgUrlArr addObject:url];
            
            [SVProgressHUD dismiss];
        }];
        
        
    } error:^(MLNetworkResponse *response) {
        
        [SVProgressHUD dismiss];
        

        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
    }];
    
    
}

- (void)doneBtnClick
{
    if (!self.textView.text.length) {
        kplaceToast(Localized(@"请输入您的反馈内容", nil));
        return;
    }
    
    NSString *jsonString = nil;
    if (self.imgUrlArr.count) {
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.imgUrlArr
                                                               options:kNilOptions
                                                                 error:&error];
        jsonString = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    }
        
    
    
    
    [SVProgressHUD show];
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"toUserId" : self.userId, @"content" : self.textView.text?:@"", @"dynamicId" : self.dongId?:@"", @"images" : jsonString?:@""} urlStr:@"/im/complaint"];

    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
        [weakself.navigationController popViewControllerAnimated:YES];
        PNSToast(KEY_WINDOW.window.rootViewController.view, Localized(@"举报成功，等待后台审核", nil), 1.0);

    } error:^(MLNetworkResponse *response) {

        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    
}

- (instancetype)initWithWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        
        self.userId = dic[@"userId"];
        self.dongId = dic[@"dongId"];
    }
    return self;
}

- (void)test0 {
    self.textView.frame = CGRectMake(16, ML_NavViewHeight + 20, self.view.bounds.size.width - 16 * 2, 160);
    // 设置placeholder
    self.textView.delegate = self;
    self.textView.wzb_placeholder = Localized(@"请输入您的个性签名", nil);
    // 设置placeholder的颜色
    self.textView.wzb_placeholderColor = kGetColor(@"#D3D2D8");
}

- (void)test1 {
    self.textView.frame = CGRectMake(16, ML_NavViewHeight + 50, self.view.bounds.size.width - 16 * 2, 130);
    // 设置placeholder
    self.textView.font = kGetFont(15);
    self.textView.delegate = self;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 12*mHeightScale;
    self.textView.backgroundColor = kGetColor(@"f8f8f8");
//    self.textView.layer.borderWidth = 1;
//    self.textView.layer.borderColor = [kGetColor(@"#D2D2D2") CGColor]; // 边框
    self.textView.wzb_placeholder = Localized(@"请输入您的反馈内容", nil);
    // 设置placeholder的颜色
    self.textView.wzb_placeholderColor = kGetColor(@"#D3D2D8");
    self.textView.backgroundColor = kGetColor(@"#ffffff");
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        [self.view addSubview:_textView];
    }
    return _textView;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length > self.count) {
        
        NSRange r = NSMakeRange(0, 200);
        textView.text = [textView.text substringWithRange:r];
        
        return;
    }
    else
    {
        self.ziCountV.text = [NSString stringWithFormat:@"%ld/%ld%@", textView.text.length, self.count, Localized(@"字", nil)];
    }
}


@end
