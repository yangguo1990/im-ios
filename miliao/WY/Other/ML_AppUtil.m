

#import "ML_AppUtil.h"
#import "NTESFileLocationHelper.h"


NSString * LVResetMsgLimitCountNotification = @"LVResetMsgLimitCountNotification";
NSString * LVRefreshFriendlyNotification = @"LVRefreshFriendlyNotification";
NSString * LVForceHangupNotification = @"LVForceHangupNotification";
NSString * LVForceEndCallNotification = @"LVForceEndCallNotification";
NSString *  LVGoldNumberCacheKey = @"LVGoldNumberCacheKey";
NSString * LVRefreshGoldNumberNotificaton = @"LVRefreshGoldNumberNotificaton";
NSString * LVVideoTextCMD = @"videotext";
NSString * LVReceiveGiftProfitNotification = @"LVReceiveGiftProfitNotification";
NSString * LVLiveNoticeNotification = @"LVLiveNoticeNotification";
NSString * LVLiveEnterNotification = @"LVLiveEnterNotification";
NSString * LVLiveGiftTipNotification = @"LVLiveGiftTipNotification";
NSString * LVLiveTextTipNotification = @"LVLiveTextTipNotification";
NSString * LVChargeNotification = @"LVChargeNotification";
NSString *  LVGuardSessionKey =  @"LVGuardSessionKey";
NSString * const LVOpenGuardVIPSuccessNotification = @"LVOpenGuardVIPSuccessNotification";
extern NSString * const LVOpenGuardVIPSuccessNotification ;

#define LVAllGold @"余额"

#define LVProductCacheKey    @"LVProductCacheKey"


@interface ML_AppUtil()

@end

@implementation ML_AppUtil

+ (BOOL)isCensor
{
    if (kisTF) {
        return YES;
    }
    NSDictionary * allConfigDic = [ML_AppConfig sharedManager].configDic;
    NSDictionary * configDic = allConfigDic;
    
    if([configDic isKindOfClass:[NSDictionary class]]){
        
        BOOL isCensor = NO;
        NSArray *arr = configDic[@"arr"];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appBid = [[NSString alloc] initWithString:[infoDictionary objectForKey:@"CFBundleIdentifier"]];
        for (NSDictionary *dic in arr) {
            NSString *appName = dic[@"appName"];
            if ([appName isEqualToString:appBid]) {
                isCensor = [dic[@"isCensor"] boolValue];
                break;
            }
        }
        
        return isCensor;
    }
    
    static NSDateFormatter * dateFormat = nil;
    if(!dateFormat){
        dateFormat = [NSDateFormatter new];
    }
    dateFormat.dateFormat = @"yyyy-MM-dd";
    NSString *buildDateStr = [[[NSBundle mainBundle]objectForInfoDictionaryKey:@"BuildDate"] substringFromIndex:7];
    NSDate * buildDate = [dateFormat dateFromString:buildDateStr];
    
    NSTimeInterval minusStartTime = buildDate.timeIntervalSince1970 - 13 * 3600;//美国时间比我们晚12小时
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
    if(currentInterval >= minusStartTime && currentInterval < minusStartTime + 7*24*3600 ){
        return YES;
    }
    
    return  YES;
}

+(void) fetchUserInfoNecessaryById:(NSString *) userId
{
   /* NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:userId];
    NIMUserInfo *userInfo = user.userInfo;*/
//    if(/*(!userInfo.avatarUrl.length || !userInfo.nickName.length) &&*/ userId.length){
//        [[NIMSDK sharedSDK].userManager fetchUserInfos:@[userId]
//                                            completion:^(NSArray *users, NSError *error) {
//                                                if (!error) {
//                                                    //通知会导致死循环-reload->fetch->reload,所以上层必须控制
//                                                    [[NIMKit sharedKit] notfiyUserInfoChanged:@[userId]];
//                                                }
//                                            }];
//
//    }
}

+(NSString *) lvVideoLocalPathWithServerUrl:(NSString *) serverUrl
{
    if(![serverUrl isKindOfClass:[NSString class]] || !serverUrl.length){
        return @"";
    }
    NSString * lastPath = [serverUrl lastPathComponent];
    return [NTESFileLocationHelper filepathForVideo:lastPath];
}

+(void) fetchUserInfoNecessaryById:(NSString *) userId withBlock:(LVFetchUserBlock) block
{

}


@end
