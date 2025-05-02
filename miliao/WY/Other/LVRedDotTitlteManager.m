

#import "LVRedDotTitlteManager.h"

@implementation LVRedDotTitlteManager

+(LVRedDotType) LVRedDotTypeWithStr:(NSString *) strType
{
    LVRedDotType redDotType = LVRedDotTypeNone;
    if([strType isEqualToString:@"message_friend"]){
        redDotType = LVRedDotTypeMessageFriend;
    }else if([strType isEqualToString:@"me_buyvip"]){
        redDotType = LVRedDotTypeMeBuyVIP;
    }else if([strType isEqualToString:@"me_chargegold"]){
        redDotType = LVRedDotTypeMeChargeGold;
    }else if([strType isEqualToString:@"me_income"]){
        redDotType = LVRedDotTypeMeProfit;
    }else if([strType isEqualToString:@"me_invite"]){
        redDotType = LVRedDotTypeMeInvite;
    }else if([strType isEqualToString:@"me_feerate"]){
        redDotType = LVRedDotTypeMeFeeSet;
    }else if([strType isEqualToString:@"me_videoverify"]){
        redDotType = LVRedDotTypeMeVideoVerify;
    }
    return redDotType;
}

+(NSString *) LVRedDotKeyForType:(LVRedDotType) redDotType
{
    if(redDotType == LVRedDotTypeMeVideoVerify){
        return @"me_videoverify_red";
    }else if(redDotType == LVRedDotTypeMessageFriend){
        return @"message_friend_red";
    }else if(redDotType == LVRedDotTypeMeBuyVIP){
        return @"me_buyvip_red";
    }else if(redDotType == LVRedDotTypeMeChargeGold){
        return @"me_chargegold_red";
    }else if(redDotType == LVRedDotTypeMeProfit){
        return @"me_income_red";
    }else if(redDotType == LVRedDotTypeMeInvite){
        return @"me_invite_red";
    }else if(redDotType == LVRedDotTypeMeVideoVerify){
        return @"me_feerate_red";
    }
    return @"none";
}

+(NSString *) LVTitleKeyForType:(LVRedDotType) redDotType
{
    if(redDotType == LVRedDotTypeMeVideoVerify){
        return @"me_videoverify_title";
    }else if(redDotType == LVRedDotTypeMessageFriend){
        return @"message_friend_title";
    }else if(redDotType == LVRedDotTypeMeBuyVIP){
        return @"me_buyvip_title";
    }else if(redDotType == LVRedDotTypeMeChargeGold){
        return @"me_chargegold_title";
    }else if(redDotType == LVRedDotTypeMeProfit){
        return @"me_income_title";
    }else if(redDotType == LVRedDotTypeMeInvite){
        return @"me_invite_title";
    }else if(redDotType == LVRedDotTypeMeVideoVerify){
        return @"me_feerate_title";
    }
    return @"none_title";
}

+(NSString *) LVTitleClickKeyForType:(LVRedDotType) redDotType
{
    if(redDotType == LVRedDotTypeMeVideoVerify){
        return @"me_videoverify_c_title";
    }else if(redDotType == LVRedDotTypeMessageFriend){
        return @"message_friend_c_title";
    }else if(redDotType == LVRedDotTypeMeBuyVIP){
        return @"me_buyvip_c_title";
    }else if(redDotType == LVRedDotTypeMeChargeGold){
        return @"me_chargegold_c_title";
    }else if(redDotType == LVRedDotTypeMeProfit){
        return @"me_income_c_title";
    }else if(redDotType == LVRedDotTypeMeInvite){
        return @"me_invite_c_title";
    }else if(redDotType == LVRedDotTypeMeVideoVerify){
        return @"me_feerate_c_title";
    }
    return @"none_c_title";
}

+(BOOL) LVTitleClickedForType:(LVRedDotType) redDotType
{
    NSString * key = [self LVTitleClickKeyForType:redDotType];
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
}

+(NSString *) LVTitleForType:(LVRedDotType) redDotType
{
    NSString * key = [self LVTitleKeyForType:redDotType];
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(BOOL) LVShowRedDotForType:(LVRedDotType) redDotType
{
    NSString * key = [self LVRedDotKeyForType:redDotType];
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
}

+(void) LVUpdateRedDotValue:(BOOL) show forTypeStr:(NSString *) redDotTypeStr
{
    LVRedDotType redDotType = [self LVRedDotTypeWithStr:redDotTypeStr];
    NSString * key = [self LVRedDotKeyForType:redDotType];
    NSNumber * value = @(show);
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) LVUpdateRedDotValue:(BOOL) show forType:(LVRedDotType) redDotType
{
    NSString * key = [self LVRedDotKeyForType:redDotType];
    NSNumber * value = @(show);
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) LVUpdateTitleValue:(NSString *)title forTypeStr:(NSString *)redDotTypeStr
{
    LVRedDotType redDotType  = [self LVRedDotTypeWithStr:redDotTypeStr];
    
    NSString * key = [self LVTitleKeyForType:redDotType];
    NSString * value = title;
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(title.length){
        [self LVUpdateTitleClikedValue:NO forType:redDotType];
    }
}

+(void) LVUpdateTitleClikedValue:(BOOL) clicked forType:(LVRedDotType) redDot
{
    NSString * key = [self LVTitleClickKeyForType:redDot];
    NSNumber * value = @(clicked);
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
