//
//  ML_CustomTextAttachment.h
//  LiveVideo
//
//  Created by 林必义 on 2017/6/22.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESCustomAttachmentDefines.h"

#define LVTextCMD @"TEXT"
#define LVMsg @"msg"

@interface ML_CustomTextAttachment : NSObject<NIMCustomAttachment,NTESCustomAttachmentInfo>
@property(nonatomic,strong) NSDictionary * info;
@property(nonatomic,copy) NSString * cmd;
@property(nonatomic,copy) NSString * msg;

+(instancetype) initWithDic:(NSDictionary *) dic;

@end
