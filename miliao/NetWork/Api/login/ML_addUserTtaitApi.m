//
//  ML_addUserTtaitApi.m
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import "ML_addUserTtaitApi.h"
@interface ML_addUserTtaitApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *datingModeId;
@property (nonatomic,copy)NSString *emotioRelationId;
@property (nonatomic,copy)NSString *targetAgeId;
@property (nonatomic,copy)NSString *labelIds;
@property (nonatomic,copy)NSString *extra;


@end
@implementation ML_addUserTtaitApi

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra
             userId:(NSString *)userId
       datingModeId:(NSString *)datingModeId
   emotioRelationId:(NSString *)emotioRelationId
        targetAgeId:(NSString *)targetAgeId
           labelIds:(NSString *)labelIds{

    if (self = [super init]) {
        self.token = token;
        self.extra = extra;
        self.userId = userId;
        self.datingModeId = datingModeId;
        self.emotioRelationId = emotioRelationId;
        self.targetAgeId = targetAgeId;
        self.labelIds = labelIds;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/trait/addUserTtait";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"extra":self.extra,
        @"userId":self.userId,
        @"datingModeId":self.datingModeId,
        @"emotioRelationId":self.emotioRelationId,
        @"targetAgeId":self.targetAgeId,
        @"labelIds":self.labelIds
     };
}

@end
