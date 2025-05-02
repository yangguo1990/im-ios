//
//  LVSVGADownloadManager.m
//  LiveVideo
//
//  Created by some on 2018/12/12.
//  Copyright © 2018 史贵岭. All rights reserved.
//

#import "LVSVGADownloadManager.h"
#import <YYCache.h>
#import <CommonCrypto/CommonDigest.h>
#import <AFNetworking/AFNetworking-umbrella.h>
#import "ML_RequestManager.h"
#import "LDSGiftCellModel.h"

static SVGAParser *parser;

@interface LVSVGADownloadManager()


@end

@implementation LVSVGADownloadManager

+ (instancetype)shareInstance{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)downloadWithGiftModel:(LDSGiftModel *) giftModel
{

    //1.创建会话管理者
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    
    //2.创建请求对象
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:giftModel.giftGifImage]];
    
    
    
    //3.创建下载Task
    
    /*
     
     第一个参数：请求对象
     
     第二个参数：进度回调
     
     downloadProgress.completedUnitCount :已经下载的数据
     
     downloadProgress.totalUnitCount：数据的总大小
     
     第三个参数：destination回调，该block需要返回值（NSURL类型），告诉系统应该把文件剪切到什么地方
     
     targetPath：文件的临时保存路径
     
     response：响应头信息
     
     第四个参数：completionHandler请求完成后回调
     
     response：响应头信息
     
     filePath：文件的保存路径，即destination回调的返回值
     
     error：错误信息
     
     */
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%f----%@",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount, request.URL);
        
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"下载完成destination回调打印------%@\n%@",targetPath,fullPath);
        
        if (fullPath) {
            
            [[LVSVGADownloadManager shareInstance].cache setObject:[NSData dataWithContentsOfFile:fullPath] forKey:giftModel.special_zip_md5];
            
        }
        
        return [NSURL fileURLWithPath:fullPath];
        
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"%@",filePath);
        
    }];
    
    
    
    //4.执行Task
    
    [downloadTask resume];
    
}

+ (void)downloadWithMusicDic:(NSDictionary *)dic
{

    //1.创建会话管理者
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //2.创建请求对象
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:dic[@"MusicUrl"]]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%f----%@",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount, request.URL);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"下载完成destination回调打印------%@\n%@",targetPath,fullPath);
        
        if (fullPath) {
            
            [[LVSVGADownloadManager shareInstance].cache setObject:[NSData dataWithContentsOfFile:fullPath] forKey:dic[@"MusicUrl"]];
            
        }
        
        return [NSURL fileURLWithPath:fullPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"%@",filePath);
        
    }];
    
    
    
    //4.执行Task
    
    [downloadTask resume];
    
}


- (void)downloadAndLoadSVGAData{
    
    // 获取基础礼物列表数据
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"im/getGifts"];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        
        NSMutableArray *muArr = [NSMutableArray array];

        for (NSDictionary *dic in response.data[@"gifts"]) {
            LDSGiftCellModel *giftModel = [LDSGiftCellModel mj_objectWithKeyValues:dic];
            [muArr addObject:giftModel];
            
            
            
            kSelf2;
            if (![weakself.cache containsObjectForKey:giftModel.special_zip_md5]) {

                
                [weakself downloadSVGADataWithUrlString:giftModel.icon_gif completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    if (error == nil && data != nil) {
                        
                        [weakself2.cache setObject:data forKey:giftModel.special_zip_md5];
                        
                        NSLog(@"***downloadAndLoadSVGAData******** %@下载完成", giftModel.name);
                    }else{
                        NSLog(@"*********** %@下载出错", giftModel.name);
                    }
                }];
                                
                
                
            }
            if ([weakself.cache containsObjectForKey:giftModel.special_zip_md5]) {
                NSLog(@"****已有gif缓存******* %@", giftModel.name);
            }
            
            
            
        }
        [ML_AppConfig sharedManager].giftArr = muArr;
        
        
    } error:^(MLNetworkResponse *response) {

    } failure:^(NSError *error) {
        
    }];
      
}

- (void)downloadSVGADataWithUrlString:(NSString *)urlString completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler{
    [[[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:200000.0] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(data,response,error);
        }
    }] resume];
}

- (YYCache *)cache{
    if (!_cache) {
        _cache = [YYCache cacheWithPath:[self svgaCachePath]];
    }
    return _cache;
}

- (NSString *)svgaCachePath{
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if (paths.count < 1) {
        return nil;
    }
    return  [paths.firstObject stringByAppendingPathComponent:@"LVkvFile"];
}

@end
