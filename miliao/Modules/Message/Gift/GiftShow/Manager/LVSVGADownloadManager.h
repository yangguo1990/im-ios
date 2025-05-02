//
//  LVSVGADownloadManager.h
//  LiveVideo
//
//  Created by some on 2018/12/12.
//  Copyright © 2018 史贵岭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDSGiftModel.h"
#import <SVGA.h>
#import <YYCache/YYCache.h>

NS_ASSUME_NONNULL_BEGIN

@interface LVSVGADownloadManager : NSObject

@property (nonatomic, strong) YYCache *cache;

+ (void)downloadWithGiftModel:(LDSGiftModel *) giftModel;
+ (void)downloadWithMusicDic:(NSDictionary *)dic;
+ (instancetype)shareInstance;

- (void)downloadAndLoadSVGAData;

- (void)downloadSVGADataWithUrlString:(NSString *)urlString completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
