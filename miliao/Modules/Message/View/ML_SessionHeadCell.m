//
//  NTESSessionListCell.m
//  NIMDemo
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "ML_SessionHeadCell.h"
#import "NIMAvatarImageView.h"
#import "UIView+NIM.h"
#import "NIMKitUtil.h"
#import "NIMBadgeView.h"

@interface ML_SessionHeadCell ()

@property (nonatomic,strong) UIView *lineBom;
@end

@implementation ML_SessionHeadCell
#define AvatarWidth 58
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AvatarWidth, AvatarWidth)];
        _avatarImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_avatarImageView];
        
        _lineBom = [[UIView alloc] initWithFrame:CGRectZero];
        _lineBom.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        [self addSubview:_lineBom];
        
        _lineTop = [[UIView alloc] initWithFrame:CGRectZero];
        _lineTop.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
//        [self addSubview:_lineTop];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLabel.font            = [UIFont systemFontOfSize:16.f];
        [self addSubview:_nameLabel];
        
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLabel.font            = [UIFont systemFontOfSize:16.f];
        [self addSubview:_nameLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _messageLabel.font            = [UIFont systemFontOfSize:14.f];
//        _messageLabel.textColor       = [UIColor lightGrayColor];
        [self addSubview:_messageLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _timeLabel.font            = [UIFont systemFontOfSize:12.f];
//        _timeLabel.textColor       = [UIColor lightGrayColor];
        [self addSubview:_timeLabel];
        
        _badgeView = [NIMBadgeView viewWithBadgeTip:@""];
        [self addSubview:_badgeView];
        
    }
    return self;
}


#define NameLabelMaxWidth    160.f
#define MessageLabelMaxWidth 200.f
- (void)refresh:(NIMRecentSession*)recent{
    self.nameLabel.nim_width = self.nameLabel.nim_width > NameLabelMaxWidth ? NameLabelMaxWidth : self.nameLabel.nim_width;
    self.messageLabel.nim_width = self.messageLabel.nim_width > MessageLabelMaxWidth ? MessageLabelMaxWidth : self.messageLabel.nim_width;
    if (recent.unreadCount) {
        self.badgeView.hidden = NO;
        self.badgeView.badgeValue = @(recent.unreadCount).stringValue;
    }else{
        self.badgeView.hidden = YES;
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    //Session List
    NSInteger sessionListAvatarLeft             = 15;
    NSInteger sessionListNameTop                = 15;
    NSInteger sessionListNameLeftToAvatar       = 15;
    NSInteger sessionListMessageLeftToAvatar    = 15;
    NSInteger sessionListMessageBottom          = 15;
    NSInteger sessionListTimeRight              = 15;
    NSInteger sessionListTimeTop                = 15;
    NSInteger sessionBadgeTimeBottom            = 15;
    NSInteger sessionBadgeTimeRight             = 15;
    
    _avatarImageView.nim_left    = sessionListAvatarLeft;
    _avatarImageView.nim_centerY = self.nim_height * .5f;
    _nameLabel.nim_top           = sessionListNameTop;
    _nameLabel.nim_left          = _avatarImageView.nim_right + sessionListNameLeftToAvatar;
    _messageLabel.nim_left       = _avatarImageView.nim_right + sessionListMessageLeftToAvatar;
    _messageLabel.nim_bottom     = self.nim_height - sessionListMessageBottom;
    _timeLabel.nim_right         = self.nim_width - sessionListTimeRight;
    _timeLabel.nim_top           = sessionListTimeTop;
    _badgeView.nim_right         = self.nim_width - sessionBadgeTimeRight;
    _badgeView.nim_bottom        = self.nim_height - sessionBadgeTimeBottom;
    
    _lineBom.frame = CGRectMake(90, 83, ML_ScreenWidth - 90, 1);
    _lineTop.frame = CGRectMake(90, 0, ML_ScreenWidth - 90, 1);
}

@end
