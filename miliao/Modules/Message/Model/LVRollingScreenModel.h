//
//  LVRollingScreenModel.h
//  LiveSendGift
//
//  Created by 史贵岭 on 2018/2/1.
//  Copyright © 2018年 com.wujh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVRollingScreenModel : NSObject
@property(nonatomic,copy) NSString * senderUserId;
@property(nonatomic,copy) NSString * senderName;
@property(nonatomic,copy) NSString * senderIconUrl;
@property(nonatomic,copy) NSString * receiverUserId;
@property(nonatomic,copy) NSString * receiverName;
@property(nonatomic,copy) NSString * receiverIconUrl;
@property(nonatomic,copy) NSString * giftName;
@property(nonatomic,copy) NSString * giftId;
@property(nonatomic,copy) NSString * giftCount;
@property(nonatomic,copy) NSString * giftUrl;
@property(nonatomic,strong) NSAttributedString * showAttStr;
@property(nonatomic,copy) NSString  * bgColor;
@property(nonatomic,copy) NSString  * extImgTag;
@property(nonatomic,copy) NSString  * opacityStr;
@end


@interface LVRollingScreenNormalModel: NSObject
@property(nonatomic,copy) NSString * avatarUrl;
@property(nonatomic,copy) NSString * title;
@property(nonatomic,copy) NSString * titleColor;
@property(nonatomic,copy) NSString * subTitle;
@property(nonatomic,copy) NSString * subTitleColor;
@property(nonatomic,copy) NSString * redirectUrl;
@property(nonatomic,copy) NSString * extImgTag;
@property(nonatomic,copy) NSString * bgColor;
@property(nonatomic,copy) NSString * opacityStr;
@end
