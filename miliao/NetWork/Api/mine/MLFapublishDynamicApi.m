//
//  MLFapublishDynamicApi.m
//  miliao
//
//  Created by apple on 2022/9/28.
//

#import "MLFapublishDynamicApi.h"
@interface  MLFapublishDynamicApi()

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *latitudeAndLongitude;
@property (nonatomic,copy)NSString *location;
@property (nonatomic,copy)NSString *chargeId;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *dynamic;
@property (nonatomic,copy)NSString *extra;

@end
@implementation MLFapublishDynamicApi

- (id)initWithtoken:(NSString *)token
            extra:(NSString *)extra

               type:(NSString *)type
            dynamic:(NSString *)dynamic
           chargeId:(NSString *)chargeId
              title:(NSString *)title
           location:(NSString *)location
latitudeAndLongitude:(NSString *)latitudeAndLongitude{

    if (self = [super init]) {
        self.token = token;
        self.extra = extra;
        self.type = type;
        self.dynamic = dynamic;
        self.chargeId = chargeId;
        self.title = title;
        self.location = location;
        self.latitudeAndLongitude = latitudeAndLongitude;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/dynamic/publishDynamic";
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"extra":self.extra,
        @"type":self.type,
        @"dynamic":self.dynamic,
        @"chargeId":self.chargeId,
        @"title":self.title,
        @"location":self.location,
        @"latitudeAndLongitude":self.latitudeAndLongitude
    };
}

@end
