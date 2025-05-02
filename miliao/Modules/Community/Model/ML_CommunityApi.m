//
//  ML_CommunityApi.m
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "ML_CommunityApi.h"
#import "MLNameCheckApi.h"
#import<CommonCrypto/CommonDigest.h>

@interface  ML_CommunityApi()

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,copy)NSString *location;

@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end

@implementation ML_CommunityApi


- (id)initWithType:(NSString *)type
            ID:(NSString *)ID
              page:(NSString *)page
             limit:(NSString *)limit
          location:(NSString *)location {

    if (self = [super init]) {
        
        UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        
        self.token = currentData.token?:@"123456";
        self.nonce = (NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)];
        self.currTime = [self giveformatter];
        self.checkSum = [self shaData];
        self.extra = [self jsonStringForDictionary];
        
        self.type = type;
        self.ID = ID;
        self.page = page;
        self.limit = limit;
        self.location = location;
        
    }
    return self;
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

-(NSString *)shaData{
    NSString *apiKey = kML_ApiKey;
    NSString *timeSp = [self giveformatter];
    NSString *numstr = [self numstr];
    NSString *newString = [NSString stringWithFormat:@"%@%@%@", apiKey,numstr,timeSp];
    NSString *ss = [self sha1:newString];
    return ss;
}


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


- (NSString *)requestUrl
{
    return @"/dynamic/getDynamics";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"nonce":self.nonce,
        @"currTime":self.currTime,
        @"checkSum":self.checkSum,
        @"extra":self.extra,
        
        @"type" : self.type,
        @"id" : self.ID,
        @"page" : self.page,
        @"limit" : self.limit,
        @"location" : self.location,
     };
}


- (NSString *)jsonStringForDictionary{
        UIDevice *device = [[UIDevice alloc] init];
        NSString *name = [self getCurrentDeviceModel];       //获取设备所有者的名称
        NSString *systemName = device.systemName;   //获取当前运行的系统
        NSString *systemVersion = device.systemVersion;//获取当前系统的版本
        NSString *udid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        NSString *ppversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *dicJson= @{@"sysType":systemName,
                                    @"sysVersion":systemVersion,
                                    @"appVersion":ppversion,
                                    @"phoneType":name,
                                    @"ip":@"",
                                    @"imei":udid,
                                    @"location":@"",
                                    @"platform":@""};
    if (![dicJson isKindOfClass:[NSDictionary class]] || ![NSJSONSerialization isValidJSONObject:dicJson]) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicJson options:0 error:nil];
    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return strJson;
}


@end
