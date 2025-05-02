//
//  ML_PictureTextAttachment.h
//  LiveVideo
//
//  Created by 林必义 on 2017/11/11.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NTESCustomAttachmentDefines.h"

#define LVPictureTextCMD @"RICH_TEXT"
#define LVPictureTextMsg @"msg"
#define LVPictureTextImg @"image"
#define LVPictureTextHref @"href"

@interface ML_PictureTextAttachment : NSObject<NIMCustomAttachment,NTESCustomAttachmentInfo>
@property(nonatomic,strong) NSDictionary * info;
@property(nonatomic,copy) NSString * cmd;
@property(nonatomic,copy) NSString * textMsg;
@property(nonatomic,copy) NSString * imgUrl;
@property(nonatomic,copy) NSString * imgHref;

+(instancetype) initWithDic:(NSDictionary *) dic;
@end
