//
//  MLLogoutApi.h
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "MLNetwork.h"

typedef void(^uploadCallblock)(NSString* _Nonnull url);
 
NS_ASSUME_NONNULL_BEGIN

@interface ML_CommonApi : MLNetwork

@property (nonatomic,copy)NSString *urlStr;

- (id)initWithPDic:(NSDictionary *)pDic urlStr:(NSString *)urlStr;


/// 上传图片
+ (void)uploadImages:(NSArray *)images dic:(NSDictionary *)dic block:(uploadCallblock)result;

@end

NS_ASSUME_NONNULL_END
