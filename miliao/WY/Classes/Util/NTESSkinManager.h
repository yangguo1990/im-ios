//
//  LVSkinManager.h
//  SiMiZhiBo
//
//  Created by 史贵岭 on 2017/12/19.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMMessageModel(minWidth)

@end
@interface NTESSkinManager : NSObject
@property(nonatomic,strong) NSDictionary * useingChatTextDic;

+(instancetype) sharedManager;

-(void) tryAppNewChatTextDic:(NSDictionary *) theNewChatTextDic;
-(NIMKitConfig *) showChatConfig;
@end
