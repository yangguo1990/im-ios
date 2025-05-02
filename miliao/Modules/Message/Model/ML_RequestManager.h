//
//  ML_RequestManager.h
//  Tutuyue
//
//  Created by t on 2019/9/19.
//  Copyright © 2019 t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking-umbrella.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^requestDoneBlock)(NSDictionary *responseObject);
typedef void(^requestCompletionBlock)(NSError *error);
typedef void(^progress)(NSProgress *uploadProgress);

typedef enum {
    ML_uploadTypeeImage = 0,
    ML_uploadTypeAudio,
    ML_uploadTypeVideo,
} ML_UploadType;

@interface ML_RequestManager : NSObject
+ (void)requestGetPath:(NSString *)pathStr parameters:(nullable NSDictionary *)parameters doneBlockWithSuccess:(requestDoneBlock)success failure:(requestCompletionBlock)failure;

+ (void)requestPath:(NSString *)pathStr parameters:(nullable NSDictionary *)parameters doneBlockWithSuccess:(requestDoneBlock)success
            failure:(requestCompletionBlock)failure;
+ (void)requestPath2:(NSString *)pathStr parameters:(nullable NSDictionary *)parameters doneBlockWithSuccess:(requestDoneBlock)success
            failure:(requestCompletionBlock)failure;
+ (AFHTTPSessionManager *)sharedAfnManager;
@end

NS_ASSUME_NONNULL_END
