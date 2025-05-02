//
//  MLNetworkArgumentsFilter.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLNetworkArgumentsFilter.h"
#import <AFNetworking/AFNetworking-umbrella.h>

@interface MLNetworkArgumentsFilter()
@property (nonatomic, strong) NSDictionary *arguments;
@end

@implementation MLNetworkArgumentsFilter

- (instancetype)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        self.arguments = arguments;
    }
    return self;
}

+ (MLNetworkArgumentsFilter *)filterUrlWithArguments:(NSDictionary *)arguments {
    return [[self alloc] initWithArguments:arguments];
}

/**
 编辑request，添加参数

 @param originUrlString 原url
 @param parameters 要添加的参数
 @return 编辑之后的url
 */
- (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters {
    NSString *paraUrlString = AFQueryStringFromParameters(parameters);
    
    if (!(paraUrlString.length > 0)) {
        return originUrlString;
    }
    NSURLComponents *components = [NSURLComponents componentsWithString:originUrlString];
    NSString *queryString = components.query ?: @"";
    NSString *newQueryString = [queryString stringByAppendingFormat:queryString.length > 0 ? @"&%@" : @"%@", paraUrlString];
    components.query = newQueryString;
    return components.URL.absoluteString;
}

#pragma mark - YTKUrlFilterProtocol
- (nonnull NSString *)filterUrl:(nonnull NSString *)originUrl withRequest:(nonnull YTKBaseRequest *)request {
    return [self urlStringWithOriginUrlString:originUrl appendParameters:self.arguments];
}


@end
