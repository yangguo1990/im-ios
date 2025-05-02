//
//  CMVideoRecordPlayer.m
//  CMVideoRecordDemo
//
//  Created by 宋国华 on 2019/4/10.
//  Copyright © 2019 MPM. All rights reserved.
//

#import "CMVideoRecordPlayer.h"

@interface CMVideoRecordPlayer ()

@property (nonatomic, strong) CALayer *playerLayer;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CMVideoRecordPlayer

- (CALayer *)playerLayer {
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.bounds;
    //playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    return playerLayer;
}

- (void)playerButtons {
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(296);
    }];
    
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = Localized(@"视频认证", nil);
    titlelabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titlelabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.top.mas_equalTo(view.mas_top).mas_offset(12);
    }];

    UILabel *titlelabelone = [[UILabel alloc]init];
    titlelabelone.text = @"·拍摄3-10秒视频,通过审核有丰富奖励";
    titlelabelone.numberOfLines = 0;
    titlelabelone.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    titlelabelone.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    titlelabelone.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titlelabelone];
    [titlelabelone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).mas_offset(16);
        make.right.mas_equalTo(view.mas_right).mas_offset(-5);
        make.top.mas_equalTo(titlelabel.mas_bottom).mas_offset(14);
    }];

    CGFloat scale = [UIScreen mainScreen].bounds.size.width / 375.0;
    CGFloat width = 65.0 * scale;
    
    
    
    UILabel *canceltitle = [[UILabel alloc]init];
    canceltitle.text = @"重拍";
    canceltitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    canceltitle.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    canceltitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:canceltitle];
    [canceltitle mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(self->_cancelButton.mas_bottom).mas_offset(8);
        //make.centerX.mas_equalTo(self->_cancelButton.mas_centerX);
        make.left.mas_equalTo(view.mas_left).mas_offset(93);
        make.bottom.mas_equalTo(view.mas_bottom).mas_offset(-SSL_TabbarMLMargin);
    }];
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.alpha = 0;
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"record_video_cancel"] forState:UIControlStateNormal];
    //_cancelButton.frame = CGRectMake((self.frame.size.width - width)/2, self.frame.size.height - 150 * scale, 60, 60);
    [_cancelButton addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(canceltitle.mas_top).mas_offset(-8);
        make.centerX.mas_equalTo(canceltitle.mas_centerX);
        make.width.height.mas_equalTo(60);
    }];
    
    UILabel *nettitle = [[UILabel alloc]init];
    nettitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    nettitle.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    nettitle.textAlignment = NSTextAlignmentCenter;
    nettitle.text = Localized(@"下一步", nil);
    [self addSubview:nettitle];
    [nettitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view.mas_right).mas_offset(-85);
        make.centerY.mas_equalTo(canceltitle.mas_centerY);
    }];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
     _confirmButton.alpha = 0;
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"record_video_confirm"] forState:UIControlStateNormal];
    //_confirmButton.frame = CGRectMake((self.frame.size.width - width)/2, _cancelButton.frame.origin.y , width, width);
    [_confirmButton addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(nettitle.mas_top).mas_offset(-8);
        make.centerX.mas_equalTo(nettitle.mas_centerX);
        make.width.height.mas_equalTo(60);
    }];
    
}

- (void)clickConfirm {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    [self.player pause];
}

- (void)clickCancel {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self.player pause];
    [self removeFromSuperview];
}

- (void)showPlayerButtons {
    CGFloat deta = [UIScreen mainScreen].bounds.size.width/375.0;
    CGFloat width = 60.0*deta;
    CGRect cancelRect = _cancelButton.frame;
    CGRect confirmRect = _confirmButton.frame;
    cancelRect.origin.x = 60*deta;
    confirmRect.origin.x = self.frame.size.width - 60*deta - width;
    [UIView animateWithDuration:0.2 animations:^{
        self.cancelButton.frame = cancelRect;
        self.confirmButton.frame = confirmRect;
        self.confirmButton.alpha = 1;
        self.cancelButton.alpha = 1;
    }];
}

- (void)setPlayUrl:(NSURL *)playUrl {
    _playUrl = playUrl;
    if (!self.player) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.playUrl];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [self addObserverToPlayerItem:playerItem];
    }
    [self.layer addSublayer:self.playerLayer];
    if (!_confirmButton) {
        [self playerButtons];
    }
    [self showPlayerButtons];
    [self.player play];
}

- (void)playbackFinished:(NSNotification *)notification {
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.frame = self.bounds;
        [self addSubview:_imageView];
    }
    if (!_confirmButton) {
        [self playerButtons];
    }
    [self showPlayerButtons];
}

- (void)dealloc {
    [self.player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

@end
