//
//  LVUIKitConfig.m
//  SiMiZhiBo
//
//  Created by 史贵岭 on 2017/12/19.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import "NTESUIKitConfig.h"
#import "NTESSkinManager.h"

@implementation NTESUIKitConfig

/*根据消息取到配置*/

- (NIMKitSetting *)setting:(NIMMessage *)message
{
    NIMKitConfig * tempSettingConfig = [[NTESSkinManager sharedManager] showChatConfig];
    tempSettingConfig.avatarType = NIMKitAvatarTypeRounded;
    if(tempSettingConfig){
        return [tempSettingConfig setting:message];
    }
    return [super setting:message];
}
@end
