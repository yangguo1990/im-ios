//
//  ML_CustomTipsAttachment.h
//  SiMiZhiBo
//
//  Created by 林必义 on 2017/12/17.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NTESCustomAttachmentDefines.h"

#define LVTipsCMD @"TIPS_TEXT"
#define LVMsg @"msg"

@interface ML_CustomTipsAttachment : NSObject <NIMCustomAttachment,NTESCustomAttachmentInfo>
@property(nonatomic,strong) NSDictionary * info;
@property(nonatomic,strong) NSDictionary * iconDic;
@property(nonatomic,copy) NSString * cmd;
@property(nonatomic,copy) NSString * msg;

+(instancetype) initWithDic:(NSDictionary *) dic;
@end
