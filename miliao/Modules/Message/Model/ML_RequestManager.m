//
//  ML_RequestManager.m
//  Tutuyue
//
//  Created by t on 2019/9/19.
//  Copyright © 2019 t. All rights reserved.
//

#import "ML_RequestManager.h"
#import <AFNetworking/AFNetworking-umbrella.h>
#import "MLNetwork.h"
#import "MLAESUtil.h"

@interface ML_RequestManager ()

@end


@implementation ML_RequestManager

+ (AFHTTPSessionManager *)sharedAfnManager {
    static AFHTTPSessionManager *manager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

        // 为了处理SNI问题，这里替换了NSURLProtocol的实现
//        NSMutableArray *protocolsArray = [NSMutableArray arrayWithArray:configuration.protocolClasses];
//        [protocolsArray insertObject:[HttpDnsNSURLProtocolImpl class] atIndex:0];
//        [configuration setProtocolClasses:protocolsArray];

        manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];

        AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = NO;
        securityPolicy.validatesDomainName = YES;
        manager.securityPolicy = securityPolicy;

        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
        manager.requestSerializer  = [AFJSONRequestSerializer  serializer];
        manager.requestSerializer.timeoutInterval = 2.0f;
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });

    return manager;
}



+ (void)requestGetPath:(NSString *)pathStr parameters:(nullable NSDictionary *)parameters doneBlockWithSuccess:(requestDoneBlock)success failure:(requestCompletionBlock)failure
{
    
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
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];


    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [muDic setObject:[self jsonStringForDictionary] forKey:@"extra"];
    kSelf;

    
    NSDictionary *dictttt = @{
        @"nonce":numstr,
        @"currTime":timeSp,
        @"checkSum":ss
    };
    NSString *baseurl = ML_KBaseUrl;
    //ML_KBaseUrl
    [manager GET:[NSString stringWithFormat:@"%@/%@?token=%@", baseurl, pathStr, [ML_AppUserInfoManager sharedManager].currentLoginUserData.token] parameters:parameters headers:dictttt progress:^(NSProgress * _Nonnull downloadProgress) {
            
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[responseObject allKeys] count] > 1) {
            dict = responseObject;
        } else {
            dict = [weakself dictionaryWithJsonString:aesDecryptString(responseObject[@"data"]?:@"", AESKey)];
        }

        NSLog(@"请求服务器返回的信息%@", dict);
        if ([dict[@"code"] intValue] == 0) {
            
            success(dict);
        } else {
            kplaceToast(Localized(@"请求失败", nil));
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


+ (void)requestPath2:(NSString *)pathStr parameters:(nullable NSDictionary *)parameters doneBlockWithSuccess:(requestDoneBlock)success failure:(requestCompletionBlock)failure
{
    
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
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];


    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [muDic setObject:[self jsonStringForDictionary] forKey:@"extra"];
    kSelf;

    
    NSDictionary *dictttt = @{
        @"nonce":numstr,
        @"currTime":timeSp,
        @"checkSum":ss
    };
    NSString *baseurl = ML_KBaseUrl;
    //ML_KBaseUrl
    [manager POST:[NSString stringWithFormat:@"%@/%@", baseurl, pathStr] parameters:parameters headers:dictttt progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
                NSDictionary *dict = (NSDictionary *)responseObject;
                if ([[responseObject allKeys] count] > 1) {
                    dict = responseObject;
                } else {
                    dict = [weakself dictionaryWithJsonString:aesDecryptString(responseObject[@"data"]?:@"", AESKey)];
                }
    
            NSLog(@"请求服务器返回的信息%@", dict);
                if ([dict[@"code"] intValue] == 0) {
                    
                    success(dict);
                } else {
                    kplaceToast(Localized(@"请求失败", nil));
                }
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
            NSLog(@"%@请求失败,返回的错误信息%@", pathStr, error);
            
            kplaceToast(Localized(@"请求失败", nil));
            failure(error);
        }];
        
    
    
    
}

+ (void)requestPath:(NSString *)pathStr parameters:(nullable NSDictionary *)parameters doneBlockWithSuccess:(requestDoneBlock)success failure:(requestCompletionBlock)failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    NSString *apiKey = kML_ApiKey;
    NSString *timeSp = [self giveformatter];
    NSString *numstr = [self numstr];
    NSString *newString = [NSString stringWithFormat:@"%@%@%@", apiKey,numstr,timeSp];
    NSString *ss = [self sha1:newString];

     [manager.requestSerializer setValue:numstr forHTTPHeaderField:@"nonce"];
     [manager.requestSerializer setValue:timeSp forHTTPHeaderField:@"currTime"];
     [manager.requestSerializer setValue:ss forHTTPHeaderField:@"checkSum"];
//    application/x-www-form-urlencoded;charset=utf-8
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/javascript",@"text/html",nil];

//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];


    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [muDic setObject:[self jsonStringForDictionary] forKey:@"extra"];
    kSelf;

    
    NSDictionary *dictttt = @{
        @"nonce":numstr,
        @"currTime":timeSp,
        @"checkSum":ss
    };
    NSString *baseurl = ML_KBaseUrl;
    NSString *urlStr = nil;
    if ([pathStr containsString:@"http"]) {
        urlStr = pathStr;
    } else {
        urlStr = [NSString stringWithFormat:@"%@/%@?token=%@", baseurl, pathStr, [ML_AppUserInfoManager sharedManager].currentLoginUserData.token];
    }
    [manager POST:urlStr parameters:parameters headers:dictttt progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
                NSDictionary *dict = (NSDictionary *)responseObject;
                if ([[responseObject allKeys] count] > 1) {
                    dict = responseObject;
                } else {
                    dict = [weakself dictionaryWithJsonString:aesDecryptString(responseObject[@"data"]?:@"", AESKey)];
                }
    
            NSLog(@"请求服务器返回的信息%@", dict);
                if ([dict[@"code"] intValue] == 0) {
                    
                    success(dict);
                } else {
                    kplaceToast(Localized(@"请求失败", nil));
                    [SVProgressHUD dismiss];
                }
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
            NSLog(@"%@请求失败,返回的错误信息%@", pathStr, error);
            
            kplaceToast(Localized(@"请求失败", nil));
            failure(error);
        }];
        
    
    
    
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
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
