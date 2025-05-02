//
//  MLNetwork.h
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import <YTKNetwork/YTKNetwork.h>
#import "MLNetworkResponse.h"

//#define AESKey  @"a5uJAS8HNqxWbvDdnA2fNtlW3vz7LOMb"
#define AESKey  @"40ef07e3fb408c8249717b797fe09b75"//@"e6c9d18c6e253d8c8320f1c15b63516e"
typedef void(^DZHNetworkSuccess)(MLNetworkResponse *response);
typedef void(^DZHNetworkError)(MLNetworkResponse *response);
typedef void(^DZHNetworkFailure)(NSError *error);

@interface MLNetwork : YTKRequest

@property (nonatomic, assign) BOOL needShowHUD;
@property (nonatomic, assign) BOOL needShowErrorMsg;
@property (nonatomic, assign) BOOL needShowFailMsg;

- (void)networkWithCompletionSuccess:(DZHNetworkSuccess)success error:(DZHNetworkError)error failure:(DZHNetworkFailure)failure;

@end
