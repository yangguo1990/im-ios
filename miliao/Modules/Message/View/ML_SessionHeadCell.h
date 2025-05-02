//
//  NTESSessionListCell.h
//  NIMDemo
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMBadgeView.h"

@class NIMAvatarImageView;
@class NIMRecentSession;

@interface ML_SessionHeadCell : UIView

@property (nonatomic,strong) UIImageView *avatarImageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *messageLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIView *lineTop;
@property (nonatomic,strong) NIMBadgeView *badgeView;
- (void)refresh:(NIMRecentSession*)recent;

@end
