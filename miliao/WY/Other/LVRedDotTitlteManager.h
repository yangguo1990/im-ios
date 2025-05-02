

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LVRedDotType) {
    LVRedDotTypeNone = 0,
    LVRedDotTypeMessageFriend = 1,
    LVRedDotTypeMeChargeGold ,
    LVRedDotTypeMeBuyVIP,
    LVRedDotTypeMeProfit,
    LVRedDotTypeMeInvite,
    LVRedDotTypeMeFeeSet,
    LVRedDotTypeMeVideoVerify,
};
@interface LVRedDotTitlteManager : NSObject
+(NSString *) LVTitleForType:(LVRedDotType) redDotType;
+(BOOL) LVShowRedDotForType:(LVRedDotType) redDotType;
+(BOOL) LVTitleClickedForType:(LVRedDotType) redDotType;
+(void) LVUpdateRedDotValue:(BOOL) show forTypeStr:(NSString *) redDotTypeStr;
+(void) LVUpdateTitleValue:(NSString *)title forTypeStr:(NSString *)redDotTypeStr;
+(void) LVUpdateRedDotValue:(BOOL) show forType:(LVRedDotType) redDotType;
+(void) LVUpdateTitleClikedValue:(BOOL) clicked forType:(LVRedDotType) redDot;
@end
