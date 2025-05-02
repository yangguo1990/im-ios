//
//  MLRenzhengWebViewController.m
//  miliao
//
//  Created by apple on 2022/9/30.
//

#import "MLRenzhengWebViewController.h"
#import <WebKit/WebKit.h>
#import <AlipayVerifySDK/MPVerifySDKService.h>
#import <AFNetworking/AFNetworking-umbrella.h>
#import "MLAESUtil.h"
#import "MLFaceRenResultViewController.h"
#import "UIViewController+MLHud.h"

@interface MLRenzhengWebViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic,strong)WKWebView *webview;

@end

@implementation MLRenzhengWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ML_titleLabel.text = @"实名认证";
    self.view.backgroundColor = UIColor.whiteColor;
    //[self setupUI];
    
    NSMutableDictionary *extParams = [NSMutableDictionary new];
    [extParams setValue:@"FF0000"forKey:ZIM_EXT_PARAMS_KEY_FACE_CIRCLE_COLOR];
    [extParams setValue:@"00FF00"forKey:ZIM_EXT_PARAMS_KEY_ACTIVITYINDICATOR_COLOR];
    
    [[MPVerifySDKService sharedInstance] verifyWith:self.certifyId currentCtr:self extParams:extParams onCompletion:^(ZIMResponse *response) {
    NSString *result = [NSString stringWithFormat:@"结果：code: %@, reason: %@, retCodeSub = %lu, retMessageSub = %@", @(response.code), response.reason, (unsigned long)response.retCode, response.retMessageSub];
        NSLog(@"支付宝认证结果----%@",result);

        [self setSHowApi];
        
        }];
}

-(void)setSHowApi{
    
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
                if ([dd[@"result"] boolValue] == 1) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }else {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            }
                [self showMessage:dd[@"msg"]];
    
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






@end
