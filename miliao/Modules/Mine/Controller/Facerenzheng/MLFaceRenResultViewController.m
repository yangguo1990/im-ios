//
//  MLFaceRenResultViewController.m
//  miliao
//
//  Created by apple on 2022/9/28.
//

#import "MLFaceRenResultViewController.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "UIViewController+MLHud.h"
#import "ML_RequestManager.h"
#import <AFNetworking/AFNetworking-umbrella.h>
#import "MLAESUtil.h"
#import "MLFaceRenzhengViewController.h"


@interface MLFaceRenResultViewController ()

@property (nonatomic,strong)UIImageView *bgimg;
@property (nonatomic,strong)UILabel *indextitlelabel;
@property (nonatomic,strong)UIButton *cancelbtn;

@end

@implementation MLFaceRenResultViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    if (![self.result isEqualToString:@"认证结果"]) {
        [self getRealResult];
    }
}


-(void)getRealResult{
    
    NSDictionary *dict = @{
        @"userId":[ML_AppUserInfoManager sharedManager].currentLoginUserData.userId,
        @"name":self.namestr,
        @"idCard":self.idcardestr
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *apiKey = kML_ApiKey;
    NSString *timeSp = [self giveformatter];
    NSString *numstr = [self numstr];
    NSString *newString = [NSString stringWithFormat:@"%@%@%@", apiKey,numstr,timeSp];
    NSString *ss = [self sha1:newString];

     [manager.requestSerializer setValue:numstr forHTTPHeaderField:@"nonce"];
     [manager.requestSerializer setValue:timeSp forHTTPHeaderField:@"currTime"];
     [manager.requestSerializer setValue:ss forHTTPHeaderField:@"checkSum"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/javascript",@"text/html",nil];

    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];//设置body 在这里将参数放入到body
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    [muDic setObject:[self jsonStringForDictionary] forKey:@"extra"];
    kSelf;

    NSDictionary *dictttt = @{
        @"nonce":numstr,
        @"currTime":timeSp,
        @"checkSum":ss
    };
    NSString *pathStr = @"user/getRealResult";
    NSString *baseurl = ML_KBaseUrl;
    [manager POST:[NSString stringWithFormat:@"%@/%@?token=%@&certifyId=%@", baseurl, pathStr, [ML_AppUserInfoManager sharedManager].currentLoginUserData.token,self.certifyId] parameters:dict headers:dictttt progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            NSDictionary *dictrespo = [weakself dictionaryWithJsonString:aesDecryptString(responseObject[@"data"]?:@"", AESKey)];
            NSLog(@"请求服务器返回的信息%@", dictrespo);
                NSDictionary *dd = dictrespo[@"data"];
                if ([dd[@"msg"] isEqualToString:@"认证通过"]) {
                    self.bgimg.image = [UIImage imageNamed:@"yitongguo23"];
                    self.indextitlelabel.text = Localized(@"实名认证通过!", nil);
                    [self.cancelbtn setTitle:Localized(@"关闭", nil) forState:UIControlStateNormal];
                }else if([dd[@"msg"] isEqualToString:@"认证失败"]){
                    self.bgimg.image = [UIImage imageNamed:@"weitguo"];
                    self.indextitlelabel.text = Localized(@"实名认证失败!", nil);
                    [self.cancelbtn setTitle:Localized(@"重新认证", nil) forState:UIControlStateNormal];
                }else{
                    self.bgimg.image = [UIImage imageNamed:@"shenhezhong2"];
                    self.indextitlelabel.text = Localized(@"资料审核中!", nil);
                    [self.cancelbtn setTitle:Localized(@"关闭", nil) forState:UIControlStateNormal];
                    
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@请求失败,返回的错误信息%@", pathStr, error);
        }];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.ML_titleLabel.text = Localized(@"认证结果", nil);
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
}

-(void)setupUI{
    
    UIImageView *bgimg = [[UIImageView alloc]init];
    bgimg.image = [UIImage imageNamed:@"shenhezhong2"];
    [self.view addSubview:bgimg];
    self.bgimg = bgimg;
    [bgimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(24);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-24);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ML_NavViewHeight + SSL_StatusBarHeight);
        make.height.mas_equalTo(211);
    }];

    UILabel *indextitlelabel = [[UILabel alloc]init];
//    indextitlelabel.text = @"实名认证失败!";
    indextitlelabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    indextitlelabel.textColor = [UIColor colorWithHexString:@"#000000"];
    indextitlelabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:indextitlelabel];
    self.indextitlelabel = indextitlelabel;
    [indextitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgimg.mas_bottom).mas_offset(13);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];

    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelbtn setTitle:@"重新认证" forState:UIControlStateNormal];
    cancelbtn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [cancelbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelbtn.layer.borderColor = kZhuColor.CGColor;
    cancelbtn.layer.borderWidth = 1;
    cancelbtn.layer.cornerRadius = 16;
    cancelbtn.layer.masksToBounds = YES;
    [cancelbtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelbtn];
    self.cancelbtn = cancelbtn;
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(indextitlelabel.mas_bottom).mas_offset(13);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(40);
    }];
    
    if ([self.result isEqualToString:@"认证结果"]) {
        ////0-审核中 //1-已通过 //2-失败 //-1-未认证
        if ([self.msg isEqualToString:Localized(@"已通过", nil)]) {
            self.bgimg.image = [UIImage imageNamed:@"yitongguo23"];
            self.indextitlelabel.text = Localized( @"实名认证通过!", nil);
            [self.cancelbtn setTitle:Localized(@"关闭", nil) forState:UIControlStateNormal];
        }else if([self.msg isEqualToString:@"失败"]){
            self.bgimg.image = [UIImage imageNamed:@"weitguo"];
            self.indextitlelabel.text = Localized(@"实名认证失败!", nil);
            [self.cancelbtn setTitle:Localized(@"重新认证", nil) forState:UIControlStateNormal];
        }else{
            self.bgimg.image = [UIImage imageNamed:@"shenhezhong2"];
            self.indextitlelabel.text = Localized(@"资料审核中!", nil);
            [self.cancelbtn setTitle:Localized(@"关闭", nil) forState:UIControlStateNormal];
        }
    }
}

-(void)cancelClick{
    //NSLog(@"关闭页面");
    if ([self.result isEqualToString:@"认证结果"]) {
        UILabel*label = self.cancelbtn.titleLabel;
        if ([label.text isEqualToString:Localized(@"重新认证", nil)]) {
            NSLog(@"重新认证");
            MLFaceRenzhengViewController *homeVC = [[MLFaceRenzhengViewController alloc] init];
            [self.navigationController pushViewController:homeVC animated:YES]; //跳转
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
