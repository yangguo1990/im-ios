//
//  LDSGiftCellModel.m
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import "LDSGiftCellModel.h"

@implementation LDSGiftCellModel

+ (NSDictionary *) mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id", @"icon_gif" : @"vfx"}; // , @"icon_gif2" : @"vfx"
}

- (NSString *)type
{
    if (_icon_gif) {
        return @"1";
    }
    return @"0";
}

- (NSString *)special_zip_md5
{
    if (_icon_gif) {
        return [_icon_gif md5];
    }
    return nil;
}

- (NSString *)icon
{
    
     if (![_icon containsString:@"http"]) {
         
         UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
         NSString *urlStr = [NSString stringWithFormat:@"%@/%@", currentData.domain, _icon];
         
         return urlStr;
     }
     
    return _icon;
}

- (NSString *)icon_gif
{
    if ([_coin integerValue] < 100) {
        return nil;
    }
    
    if (![_icon_gif containsString:@"http"] && [_icon_gif length]) {
        
        UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@", currentData.domain, _icon_gif];
        
        return urlStr;
    }
    
   return _icon_gif;
}

MJExtensionCodingImplementation

@end
