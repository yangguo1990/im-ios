//
//  LVRollingScreenView.m
//  LiveSendGift
//
//  Created by 史贵岭 on 2018/1/29.
//  Copyright © 2018年 com.wujh. All rights reserved.
//

#import "LVRollingScreenView.h"
#import "LVSVGADownloadManager.h"

static SVGAParser *parser;

@interface LVRollingScreenView()<SVGAPlayerDelegate>

@property (nonatomic, strong) SVGAPlayer *giftPlayer;//大礼物动画展示
@property (nonatomic, strong) YYCache *cache;
@end

@implementation LVRollingScreenView

- (void)removeView
{
    [self.giftPlayer stopAnimation];
    
    [self removeFromSuperview];
}


+ (instancetype)sharedRollingScreenView
{
    static LVRollingScreenView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LVRollingScreenView alloc] init];
        
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
//    self = [super initWithFrame:CGRectMake(0, kNavViewHeight, UIScreenWidth, UIScreenHeight - kNavViewHeight - kSHInPutHeight - kSHBottomSafe)];
    self = [super initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    if(self) {
        self.userInteractionEnabled = NO;
        [self addSubview:self.giftPlayer];
        parser = [[SVGAParser alloc] init];
    }
    return self;
}


- (void)startShowGiftViewWithBigGiftModel:(LDSGiftModel *) giftModel
{
    UIViewController *vc = [UIViewController topShowViewController];
    
    [vc.view addSubview:self];
    
    id data = [self.cache objectForKey:giftModel.special_zip_md5];
    
    if ([data isKindOfClass:[NSData class]]) {
        NSLog(@"有缓存===%@", data);
        kSelf;
        [parser parseWithData:data cacheKey:giftModel.special_zip_md5 completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            if (videoItem != nil) {
                
                weakself.giftPlayer.frame = CGRectMake(0, 0,  weakself.width, weakself.height);
                
                weakself.giftPlayer.videoItem = videoItem;
                [weakself.giftPlayer startAnimation];
                
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        }];
        
    }
    else
    {
        NSLog(@"没缓存===");
        
        [LVSVGADownloadManager downloadWithGiftModel:giftModel];
        
        kSelf;
        [parser parseWithURL:kGetUrlPath(giftModel.giftGifImage) completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            
            if (videoItem != nil) {
                
                weakself.giftPlayer.frame = CGRectMake(0, 0,  weakself.width, weakself.height);
                 
                weakself.giftPlayer.videoItem = videoItem;
                [weakself.giftPlayer startAnimation];
            }
            
        } failureBlock:^(NSError * _Nullable error) {
            
        }];
        
        
    }

  
}

- (YYCache *)cache{
    if (!_cache) {
        _cache = [YYCache cacheWithPath:[self svgaCachePath]];
    }
    return _cache;
}

- (NSString *)svgaCachePath{
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if (paths.count < 1) {
        return nil;
    }
    return  [paths.firstObject stringByAppendingPathComponent:@"LVkvFile"];
}


-(void) startShowGiftViewWithModel:(LDSGiftModel *) giftModel
{
    kSelf;
    @synchronized(weakself){
        
        kSelf2;
        dispatch_async(dispatch_get_main_queue(), ^{
            // 大动画
            __weak typeof(self) weakself3 = weakself2;
            [parser parseWithURL:kGetUrlPath(giftModel.giftGifImage) completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                
                if (videoItem != nil) {
                    weakself3.giftPlayer.videoItem = videoItem;
                    [weakself3.giftPlayer startAnimation];
                }
                
            } failureBlock:^(NSError * _Nullable error) {
                
                if (weakself3.giftPlayer) {
                    [weakself3.giftPlayer removeFromSuperview];
                }
            }];
            
        });
        
    }
    
}

- (SVGAPlayer *)giftPlayer{
    if (!_giftPlayer) {
        _giftPlayer = [[SVGAPlayer alloc] init];
        _giftPlayer.contentMode = UIViewContentModeScaleAspectFill;
        _giftPlayer.clipsToBounds = YES;
        _giftPlayer.delegate = self;
        _giftPlayer.loops = 0;
        _giftPlayer.clearsAfterStop = YES;
    }
    return _giftPlayer;
}


-(void) dealloc
{
    [self.giftPlayer stopAnimation];
    [self removeFromSuperview];
}

#pragma mark SVGAPlayerDelegate

- (void)svgaPlayerDidAnimatedToPercentage:(CGFloat)percentage{
    
    if (percentage == 1.0) {
        [self.giftPlayer stopAnimation];
        
        [self removeFromSuperview];
    }
}


@end
