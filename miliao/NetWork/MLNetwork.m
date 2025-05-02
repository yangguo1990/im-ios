//
//  MLNetwork.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLNetwork.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import<CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import <sys/utsname.h>
#import "MLAESUtil.h"
//#import <Bugly/Bugly.h>
//#import "ML_TanchuangView.h"
#define WeakSelf __weak typeof(self) weakSelf = self;


@implementation MLNetwork


- (instancetype)init {
    self = [super init];
    if (self) {
        self.needShowHUD = YES;
        self.needShowErrorMsg = YES;
        self.needShowFailMsg = YES;
    }
    return self;
}

- (void)networkWithCompletionSuccess:(DZHNetworkSuccess)success error:(DZHNetworkError)error failure:(DZHNetworkFailure)failure {
    
    WeakSelf
    [self setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *dataString = request.responseJSONObject[@"data"];
        NSDictionary *dict = [NSDictionary dictionary];
        if (dataString != nil) {
            dict = [weakSelf dictionaryWithJsonString:aesDecryptString(dataString, AESKey)];
        }

        if (dict.count == 0) {
            NSDictionary *buglyInfo = @{@"url": request.requestUrl, @"argument": request.requestArgument, @"response": request.responseString};
            NSError *buglyError = [NSError errorWithDomain: @"service response data is nill" code:-1 userInfo: buglyInfo];
//            [Bugly reportError: buglyError];
        }
//        NSDictionary *dict = [weakSelf dictionaryWithJsonString:aesDecryptString(dataString, AESKey)];
        MLNetworkResponse *response = [[MLNetworkResponse alloc] init];
        response.status = dict[@"code"]?:@"";
        response.msg = dict[@"msg"]?:@"";
        if ([dict[@"data"] isEqual:[NSNull null]]) {
            response.data = @{};
            NSLog(@"登录data--%@",response.data);
        } else {
            response.data = dict[@"data"];
        }
        
        NSLog(@"请求返回代码块之前 ----%@",response);
        
        if (response.status.integerValue == 0 || response.status.integerValue == 20) {
            NSLog(@"请求返回----%@",response);
            success(response);
        } else if (response.status.integerValue == 2 && weakSelf.needShowHUD) {
            
            NSLog(@"request.data===%@", response.data);

            extern NSString *NTESNotificationLogout;
            [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
            kplaceToast(@"登录过期，请重新登录！");
            
            
            [SVProgressHUD dismiss];
        } else {
            if (error && weakSelf.needShowHUD) {
                
                if ([dict[@"code"] intValue] == 106) { //
                    
                    success(response);
//                            NSString *str = response.msg;
//                            ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
//                            tanV.dic = @{@"type" : @(ML_TanchuangViewType_chongzhi), @"data" : str?:@"余额不足，请充值！"};
                    
                } else {
                    
                    [SVProgressHUD dismiss];
                    error(response);
                    if ([ML_AppUtil isCensor]) {
                        kplaceToast(([NSString stringWithFormat:@"%@", dict[@"msg"]?:@""]));
                    }
                }
                NSLog(@"返回error----%@",response);
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
       NSLog(@"baseUrl:%@/%@, argument:%@ response: %@ error:%@", [weakSelf baseUrl], [weakSelf requestUrl], [weakSelf requestArgument], request.responseJSONObject, request.error);
        
        [SVProgressHUD dismiss];
        
        if (failure) {
            failure(request.error);
        }
    }];
    [self start];
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

//
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}


-(NSData *)extraMessage{
    UIDevice *device = [[UIDevice alloc] init];
    NSString *name = [self getCurrentDeviceModel];       //获取设备所有者的名称
    NSString *systemName = device.systemName;   //获取当前运行的系统
    NSString *systemVersion = device.systemVersion;//获取当前系统的版本
    NSString *udid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    NSString *ppversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *parameters= @{@"sysType":systemName,
                                @"sysVersion":systemVersion,
                                @"appVersion":ppversion,
                                @"phoneType":name,
                                @"imei":udid,
                                @"location":@"",
                                @"platform":@""};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:NSJSONWritingPrettyPrinted  error:nil];
    return jsonData;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
        NSString *apiKey = kML_ApiKey;
        NSString *timeSp = [self giveformatter];
        NSString *numstr = [self numstr];
        NSString *newString = [NSString stringWithFormat:@"%@%@%@", apiKey,numstr,timeSp];
        NSString *ss = [self sha1:newString];
    
    
    return @{
             @"nonce":numstr,
             @"currTime":timeSp,
             @"checkSum":ss,
    };
}
/*
- (NSString *) sha1:(NSString *)input{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

-(NSString *)numstr{
    int num = (arc4random() % 10000);
    NSString *numstr = [NSString stringWithFormat:@"%.4d", num];
    return numstr;
}

-(NSString *)giveformatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
     [formatter setDateStyle:NSDateFormatterMediumStyle];
     [formatter setTimeStyle:NSDateFormatterShortStyle];
     [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
     NSDate *datenow = [NSDate date];
     NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}
*/
//- (void)showErrorMsg:(NSString *)msg {
//    if (!self.needShowErrorMsg) { return; }
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    if (!keyWindow) { return; }
//    if (!msg) { return; }
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
//    hud.userInteractionEnabled = NO;
//    hud.mode = MBProgressHUDModeText;
//    hud.detailsLabel.text = msg;
//    NSTimeInterval time = 1.5 + msg.length * 0.1;
//    [hud hideAnimated:YES afterDelay:time];
//}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    if (!self.needShowFailMsg) { return; }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) { return; }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
//    hud.label.text = @"当前网络不稳定，请重试";
    hud.detailsLabel.text = self.error.localizedDescription;
    NSTimeInterval time = 2.0;
    [hud hideAnimated:YES afterDelay:time];
}

@end
